function [Y, uzbase, nrepet] = demodulationQPSK_RCOS(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded)
% demodulationQPSK_RCOS
% Démodulation QPSK avec filtrage adapté Raised Cosine.
%
% Entrées :
%   y           : signal reçu (réel)
%   nus         : fréquence d'échantillonnage
%   fp          : fréquence porteuse
%   Db          : débit binaire
%   A           : amplitude des symboles
%   b           : filtre Raised Cosine utilisé à la modulation
%   Nsymb       : nombre de symboles
%   nrepet      : échantillons par symbole
%   group_delay : délai de groupe du filtre RC
%   orig_len    : longueur originale du message
%   padded      : indicateur de padding
%
% Sorties :
%   Y       : bits estimés
%   uzbase  : signal complexe démodulé en bande de base
%   nrepet  : échantillons par symbole (inchangé)

    Ts = 1 / nus;
    iim = 1i;
    t = (0:length(y)-1) * Ts;

    % --- signal analytique en bande de base ---
    uzbase = hilbert(y) .* exp(-iim * 2*pi*fp*t);

    % --- filtrage adapté (Raised Cosine) ---
    uz_full1 = conv(uzbase, b, 'full');
    uz_full = conv(uz_full1, b, 'full');

    % --- échantillonnage symbolique ---
    start_idx = group_delay + 1;
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    if idx(end) > length(uz_full)
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationQPSK: truncation', ...
            'On tronque Nsymb de %d à %d pour tenir dans y.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    sampled = uz_full(idx);

    % --- décision (QPSK) ---
    I_vals = real(sampled);
    Q_vals = imag(sampled);

    nphaseprime = zeros(1, Nsymb);
    for k = 1:Nsymb
        nphaseprime(k) = decisionQPSK(I_vals(k), Q_vals(k));
    end

    % --- reconversion en bits ---
    Y_full = str2num(reshape(dec2bin(nphaseprime, 2)', 2*Nsymb, 1))';

    % --- suppression du padding éventuel ---
    if padded == 1
        Y = Y_full(1:orig_len);
    else
        Y = Y_full;
    end
end

function [d] = distance(x1, y1, x2, y2)
    d = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

function [min_idx] = decisionQPSK(x1, y1)
    % Points QPSK normalisés (phase 45°)
    pts = [ 0.7071+0.7071i,  -0.7071+0.7071i,  -0.7071-0.7071i,  0.7071-0.7071i ];
    L = abs(x1 + 1i*y1 - pts);
    [~, min_idx] = min(L);
    min_idx = min_idx - 1; % indices 0,1,2,3
end
