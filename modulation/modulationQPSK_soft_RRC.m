function [x, Ntot, z, t, u_shaped, delay] = modulationQPSK_soft_RRC(m, nus, fp, Db, A, alpha)
% Modulation QPSK avec filtrage RRC (robuste pour longueur impaire de m)
% Sorties alignées pour correspondre à la démodulation
%
% Entrées :
%   m     : vecteur binaire (0/1)
%   nus   : fréquence d'échantillonnage (Hz)
%   fp    : fréquence porteuse (Hz)
%   Db    : débit binaire (bit/s)
%   A     : amplitude des symboles
%   alpha : roll-off du RRC
%
% Sorties :
%   x         : signal RF réel (émis)
%   Ntot      : longueur du signal émis
%   z         : signal reçu (ici identique à x si sigma2=0)
%   t         : axe temps (s)
%   u_shaped  : signal complexe après shaping (retard compensé)
%   delay     : nombre d'échantillons de retard du filtre (utile pour RX)

    Ts = 1/nus;
    iim = 1i;

    % --- Assurer que m est un vecteur ligne ---
    m = m(:).';  % row vector

    % --- Padding si nombre impair de bits ---
    if mod(numel(m),2) ~= 0
        m = [m 0]; % on pad avec 0 ; change si tu veux pad=1
        % note : la démod devra éventuellement enlever ce bit en trop
    end

    % === Mapping QPSK ===
    Nsymb = numel(m)/2;
    msymbole = reshape(m, 2, []);        % 2 x Nsymb (1ère ligne = MSB)
    % conversion bits -> valeur 0..3 (MSB en msymbole(1,:))
    nphase = msymbole(1,:) * 2 + msymbole(2,:); % vecteur 1 x Nsymb
    ux = A * exp(iim * (2*pi*nphase/4 + pi/4)); % symboles QPSK

    % === Paramètres temporels ===
    Rs = Db/2;
    nrepet = round(nus / Rs);
    if mod(nrepet,2) ~= 0
        nrepet = nrepet + 1; % rend pair
    end

    span = 6; % durée du filtre (en symboles)

    % === Suréchantillonnage ===
    u_ups = upsample(ux, nrepet);

    % === Filtre RRC ===
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    % normalisation (préserver énergie)
    rrcFilter = rrcFilter / norm(rrcFilter);

    % === Filtrage de mise en forme (full pour gérer bords) ===
    u_shaped_full = conv(u_ups, rrcFilter, 'full');

    % === Délai du filtre en échantillons ===
    delay = (span/2) * nrepet;

    % === Compensation du retard : on tronque les bords pour recentrer ===
    % On retire 'delay' échantillons au début et à la fin pour aligner.
    if length(u_shaped_full) > 2*delay
        u_shaped = u_shaped_full(delay+1:end-delay);
    else
        % garde au moins quelque chose si signal trop court (cas pathologique)
        u_shaped = u_shaped_full;
        warning('u_shaped_full trop court pour tronquer avec delay ; aucun tronquage appliqué.');
    end

    % === Signal RF ===
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped).*cos(2*pi*fp*t) - imag(u_shaped).*sin(2*pi*fp*t);

    % === Ajout de bruit (désactivé ici) ===
    sigma2 = 0.5;
    z = x + sqrt(sigma2) * randn(1, length(x));
end
