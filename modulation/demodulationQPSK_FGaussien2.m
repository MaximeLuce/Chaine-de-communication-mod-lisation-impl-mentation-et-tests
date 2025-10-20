function [Y, uzbase, nrepet] = demodulationQPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded)
% demodulationQPSK_soft_gauss_fixed_pad
% Démodulation correspondante qui supprime le bit de padding si nécessaire.
%
% Entrées supplémentaires : orig_len et padded (retournés par la modulation).

    Ts = 1 / nus;
    iim = 1i;
    t = (0:length(y)-1) * Ts;

    % --- signal analytique baseband ---
    uzbase = hilbert(y) .* exp(-iim * 2*pi*fp*t);

    % --- filtrage adapté (convolution full) ---
    uz_full = conv(uzbase, g, 'full');

    start_idx = group_delay + 1;
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    if idx(end) > length(uz_full)
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationQPSK: truncation', 'On tronque Nsymb de %d à %d pour tenir dans y.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    sampled = uz_full(idx);

    % --- décision ---
    I_vals = real(sampled);
    Q_vals = imag(sampled);

    nphaseprime = zeros(1, Nsymb);
    for k = 1:Nsymb
        nphaseprime(k) = decisionQPSK(I_vals(k), Q_vals(k));
    end

    % reconversion en bits
    Y_full = str2num(reshape(dec2bin(nphaseprime, 2)', 2*Nsymb, 1))';

    % --- suppression du padding si nécessaire ---
    if padded == 1
        Y = Y_full(1:orig_len); % garde seulement les orig_len premiers bits
    else
        Y = Y_full;
    end
end

function [d] = distance(x1, y1, x2, y2)
    d = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

function [min_idx] = decisionQPSK(x1, y1)
    % Points QPSK normalisés
    pts = [ 0.7071+0.7071i,  -0.7071+0.7071i,  -0.7071-0.7071i,  0.7071-0.7071i ];
    L = abs(x1 + 1i*y1 - pts);
    [~, min_idx] = min(L);
    min_idx = min_idx - 1; % pour avoir 0,1,2,3
end