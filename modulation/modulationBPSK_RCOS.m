function [x, Ntot, z, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RCOS(m, nus, fp, Db, A, rolloff)
% modulationBPSK_RCOS
% Modulation BPSK avec filtrage en cosinus surélevé (Raised Cosine).
%
% Entrées :
%   m        : bits d'entrée (0/1)
%   nus      : fréquence d'échantillonnage (Hz)
%   fp       : fréquence porteuse (Hz)
%   Db       : débit binaire (bits/s)
%   A        : amplitude des symboles
%   rolloff  : facteur de rolloff du filtre RC (ex: 0.25)
%
% Sorties :
%   x        : signal modulé réel
%   Ntot     : longueur totale du signal modulé
%   z        : signal modulé bruité
%   b        : coefficients du filtre RC
%   nrepet   : échantillons par symbole
%   Nsymb    : nombre de symboles
%   group_delay : délai de groupe du filtre (en échantillons)
%   orig_len : longueur initiale du message
%   padded   : indicateur de padding (0 toujours ici, gardé pour compatibilité)

    orig_len = numel(m);
    padded = 0; % Pas de besoin de padding en BPSK

    Ts = 1 / nus;

    % --- mapping BPSK : 0 -> -A, 1 -> +A ---
    Nsymb = numel(m);
    ux = A * (2*m - 1);  % symboles réels ±A

    % --- sur-échantillonnage ---
    Rs = Db;                     % débit symbole = débit binaire
    nrepet = round(nus / Rs);    % échantillons par symbole

    % --- filtre Raised Cosine ---
    span = 6;                    % span en symboles
    sps = nrepet;                % samples per symbol
    b = rcosdesign(rolloff, span, sps);

    % --- upsample ---
    u_ups = upsample(ux, nrepet);

    % --- mise en forme ---
    u_full = conv(u_ups, b, 'full');
    group_delay = floor((length(b)-1)/2);
    u_shaped = u_full(group_delay+1 : group_delay + length(u_ups));

    % --- modulation porteuse ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped) .* cos(2*pi*fp*t);

    % --- bruit (sigma2=1 pour test) ---
    sigma2 = 1;
    z = x + sqrt(sigma2)*randn(1, length(x));

    % --- test de cohérence ---
    assert(length(x) == Ntot, 'Erreur : longueur de sortie incohérente.');
end