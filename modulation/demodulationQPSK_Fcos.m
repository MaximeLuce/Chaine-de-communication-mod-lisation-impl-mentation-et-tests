function [Y, uznus, nrepet] = demodulationQPSK_Fcos(y, nus, fp, Db, A, hcos2)
    Ts = 1/nus;
    iim = 1i;
    t = (0:length(y)-1)*Ts;
    Rs = Db/2;
    nrepet = round(nus/Rs);

    % --- Démodulation en bande de base ---
    uznus = hilbert(y) .* exp(-iim*2*pi*fp*t); % signal complexe

    % --- Filtrage adapté (cos²) ---
    uz_filt = conv(uznus, hcos2, 'same');

    % --- Extraction symbole ---
    Nsymb = floor(numel(uz_filt)/nrepet);
    uz_block = reshape(uz_filt(1:Nsymb*nrepet), nrepet, Nsymb);

    % Intégration (décision douce)
    I_vals = sum(real(uz_block), 1);
    Q_vals = sum(imag(uz_block), 1);

    % --- Décision ---
    nphaseprime = zeros(1, Nsymb);
    for i = 1:Nsymb
        nphaseprime(i) = decisionQPSK(I_vals(i), Q_vals(i));
    end

    % --- Bits en sortie ---
    Y = str2num(reshape(dec2bin(nphaseprime,2)', 2*Nsymb, 1))';
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