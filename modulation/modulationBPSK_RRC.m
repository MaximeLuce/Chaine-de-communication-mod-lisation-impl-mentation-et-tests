function [x, Ntot, z, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RRC(m, nus, fp, Db, A, rolloff, span)
% modulationBPSK_RRC
% Modulation BPSK avec filtrage Root Raised Cosine (RRC)
%
% Entrées :
%   m        : bits d'entrée (0/1)
%   nus      : fréquence d'échantillonnage (Hz)
%   fp       : fréquence porteuse (Hz)
%   Db       : débit binaire (bits/s)
%   A        : amplitude des symboles
%   rolloff  : facteur de rolloff du filtre RRC
%   span     : durée du filtre en symboles
%
% Sorties :
%   x            : signal modulé réel (après RRC et porteuse)
%   Ntot         : longueur totale du signal modulé
%   z            : signal modulé bruité (AWGN sigma^2=1)
%   b            : coefficients du filtre RRC
%   nrepet       : échantillons par symbole
%   Nsymb        : nombre de symboles
%   group_delay  : délai total émetteur+récepteur (en échantillons)
%   orig_len     : longueur initiale du message
%   padded       : indicateur de padding (toujours 0 ici)

    orig_len = numel(m);
    padded = 0;

    Ts = 1 / nus;

    % --- mapping BPSK ---
    ux = A * (1 - 2*m(:)).';  % vecteur ligne, 0->+A, 1->-A
    Nsymb = numel(ux);

    % --- échantillons par symbole ---
    Rs = Db;
    nrepet = round(nus / Rs);

    % --- filtre RRC ---
    b = rcosdesign(rolloff, span, nrepet, 'sqrt'); % Root Raised Cosine

    % --- suréchantillonnage ---
    u_ups = upsample(ux, nrepet);

    % --- mise en forme (filtrage émetteur RRC) ---
    x_baseband = conv(u_ups, b, 'full');

    % --- modulation sur porteuse ---
    Ntot = numel(x_baseband);
    t = (0:Ntot-1) * Ts;
    x = real(x_baseband) .* cos(2*pi*fp*t);

    % --- bruit AWGN simple ---
    sigma2 = 1;
    z = x + sqrt(sigma2)*randn(1, length(x));

    % --- délai de groupe total (émetteur + récepteur) ---
    % filtre longueur Lb = span*nrepet +1
    % RRC émetteur + RRC récepteur -> group_delay = span*nrepet
    group_delay = span * nrepet;
end
