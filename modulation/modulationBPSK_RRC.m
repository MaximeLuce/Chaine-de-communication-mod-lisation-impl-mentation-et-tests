function [x, Ntot, z, t, u_shaped, delay] = modulationBPSK_RRC(m, nus, fp, Db, A, alpha)
% modulationBPSK_RRC : Modulation BPSK avec filtrage RRC
% Entrées :
%   m      : séquence binaire (0/1)
%   nus    : fréquence d'échantillonnage (Hz)
%   fp     : fréquence porteuse (Hz)
%   Db     : débit binaire (bit/s)
%   A      : amplitude du signal BPSK
%   alpha  : facteur de roll-off du filtre RRC
%
% Sorties :
%   x         : signal modulé réel (RF)
%   Ntot      : nombre total d'échantillons du signal
%   z         : signal bruité (actuellement bruit désactivé)
%   t         : vecteur temporel (s)
%   u_shaped  : signal BPSK filtré par le RRC (complexe)
%   delay     : délai introduit par le filtre (en échantillons)

    Ts = 1/nus;  % période d'échantillonnage
    iim = 1i;    % unité imaginaire (utile pour cohérence avec QPSK)

    % === Mapping BPSK ===
    % 0 → +A, 1 → -A
    Nsymb = numel(m);
    ux = A * (1 - 2*m);  % symboles BPSK sur l'axe réel

    % === Paramètres temporels ===
    Rs = Db;  % débit symbole = débit binaire
    nrepet = round(nus / Rs);
    span = 6; % durée du filtre RRC en symboles

    % === Suréchantillonnage ===
    u_ups = upsample(ux, nrepet);

    % === Filtre RRC ===
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    rrcFilter = rrcFilter / norm(rrcFilter); % normalisation énergétique

    % === Filtrage de mise en forme ===
    u_shaped = conv(u_ups, rrcFilter, 'full');

    % === Délai du filtre ===
    delay = (span/2) * nrepet;

    % === Troncature pour enlever le retard ===
    u_shaped = u_shaped(delay+1:end-delay);

    % === Signal RF ===
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    % BPSK : seule la partie réelle est utilisée
    x = real(u_shaped).*cos(2*pi*fp*t);

    % === Ajout de bruit (désactivé ici) ===
    sigma2 = 1;
    z = x + sqrt(sigma2)*randn(1, length(x));
end
