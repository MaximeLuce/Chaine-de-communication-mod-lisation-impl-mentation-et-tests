function [m_reconstruit, ux_reconstruit, t, y_matched, y_complex] = demodulationBPSK_RRC(z, nus, fp, Db, A, alpha)
% Démodulation BPSK avec filtrage RRC adapté et compensation du délai
%
% Entrées :
%   z : signal reçu (réel)
%   nus : fréquence d'échantillonnage (Hz)
%   fp : fréquence porteuse (Hz)
%   Db : débit binaire (bits/s)
%   A : amplitude des symboles (±A)
%   alpha : facteur de roll-off du filtre RRC
%
% Sorties :
%   m_reconstruit : bits décodés (0/1)
%   ux_reconstruit : symboles reconstruits après échantillonnage
%   t : axe temporel
%   y_matched : signal après filtrage adapté

    % === Paramètres de base ===
    Ts = 1/nus;          % période d'échantillonnage
    Rs = Db;             % débit symbole (BPSK : 1 bit/symbole)
    nrepet = round(nus / Rs);  % nombre d'échantillons par symbole
    span = 6;            % durée du filtre RRC en symboles
    delay = (span/2) * nrepet; % délai du filtre (en échantillons)
    
    % === Axe temporel ===
    t = (0:length(z)-1) * Ts;

    % === Démodulation cohérente ===
    % Produit par la porteuse cosinus
    y_bb = z .* cos(2*pi*fp*t);   % signal bande de base (réel)
    y_complex = z .* exp(-1j*2*pi*fp*t); 
    
    % === Filtre RRC ===
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    rrcFilter = rrcFilter / norm(rrcFilter); % normalisation énergétique

    % === Filtrage adapté ===
    y_matched = conv(y_bb, rrcFilter, 'full');

    % === Compensation du délai du filtre ===
    y_sync = y_matched(delay+1:end-delay);

    % === Échantillonnage aux instants symbole ===
    ux_reconstruit = y_sync(1:nrepet:end);

    % === Décision sur constellation ===
    % Constellation BPSK : +A → bit 0, -A → bit 1
    m_reconstruit = zeros(1, length(ux_reconstruit));
    m_reconstruit(real(ux_reconstruit) < 0) = 1;

end
