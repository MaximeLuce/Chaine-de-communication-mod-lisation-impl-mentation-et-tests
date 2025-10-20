function [Y, uzbase, nrepet] = demodulationQPSK_FGaussien(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay)
% demodulationQPSK_soft_gauss_fixed
%   Démodulation QPSK avec filtrage adapté.
%   Nécessite g, Nsymb, nrepet et group_delay renvoyés par la modulation.
%
% Entrées:
%   y : signal reçu (vecteur)
%   nus, fp, Db, A : paramètres (nus, fp, Db, A)
%   g : pulse gaussienne utilisée par l'émetteur (vecteur)
%   Nsymb : nombre de symboles d'origine
%   nrepet : échantillons par symbole
%   group_delay : délai (en échantillons) introduit par g (floor((len(g)-1)/2))
%
% Sorties:
%   Y : bits décodés (1 x 2*Nsymb)
%   uzbase : signal analytique baseband filtré (utile pour debug)
%   nrepet : renvoi pour usage extérieur

    Ts = 1 / nus;
    iim = 1i;
    t = (0:length(y)-1) * Ts;

    % --- signal analytique et translation en base ---
    uzbase = hilbert(y) .* exp(-iim * 2*pi*fp*t);

    % --- filtrage adapté (convolution full) ---
    uz_full = conv(uzbase, g, 'full');

    % On veut les échantillons alignés avec l'upsampled sequence d'origine :
    start_idx = group_delay + 1; % premier échantillon correspondant au 1er échantillon upsampled
    % Indices de sampling des symboles (on échantillonne à 1 point par symbole au centre)
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    % S'assurer que idx est dans les bornes
    if idx(end) > length(uz_full)
        % Si on manque d'échantillons (rare si longueur y correcte), tronquer Nsymb
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationQPSK: truncation', 'On tronque Nsymb de %d à %d pour tenir dans y.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    sampled = uz_full(idx);

    % --- décisions sur I et Q ---
    I_vals = real(sampled);
    Q_vals = imag(sampled);

    nphaseprime = zeros(1, Nsymb);
    for k = 1:Nsymb
        nphaseprime(k) = decisionQPSK(I_vals(k), Q_vals(k));
    end

    % reconversion en bits
    Y = str2num(reshape(dec2bin(nphaseprime, 2)', 2*Nsymb, 1))';
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