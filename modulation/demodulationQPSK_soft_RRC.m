function [m_reconstruit, ux_reconstruit, t, y_matched, y_bb] = demodulationQPSK_soft_RRC(z, nus, fp, Db, A, alpha, Nb_bits_original)
% Démodulation QPSK avec filtrage RRC adapté et compensation du délai
% Gestion du padding bit (si utilisé à l'émission)
%
% Sorties :
%   m_reconstruit : bits estimés (padding retiré si Nb_bits_original fourni)
%   ux_reconstruit: symboles complexes estimés (échantillonnés)
%   t             : axe temporel du signal reçu z
%   y_matched     : signal après filtrage adapté (base-bande) — aligné (delay compensé si possible)
%
% Notes :
%  - Si Nb_bits_original est fourni, la fonction tronque le bit de padding ajouté à l'émission.
%  - La fonction protège contre les signaux trop courts pour la compensation complète du délai.

    % --- Paramètres temporels / filtres ---
    Ts = 1/nus;
    Rs = Db/2;
    nrepet = round(nus / Rs);
    if mod(nrepet,2) ~= 0
        nrepet = nrepet + 1; % rend pair
    end

    span = 1;
    delay = (span/2) * nrepet;

    % --- Axe temporel ---
    t = (0:length(z)-1) * Ts;

    % --- Démodulation cohérente (RF -> BB complexe) ---
    z_I = z .* cos(2*pi*fp*t);
    z_Q = -z .* sin(2*pi*fp*t);
    y_bb = z_I + 1i*z_Q;

    % --- Filtre RRC racine carrée (réception) ---
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    rrcFilter = rrcFilter / norm(rrcFilter);

    % --- Filtrage adapté (full pour garder tous les échantillons) ---
    y_matched_full = conv(y_bb, rrcFilter, 'full');

    % --- Compensation du délai (si possible) ---
    if length(y_matched_full) > 2*delay
        y_sync = y_matched_full(delay+1:end-delay);
    else
        % si trop court, on retourne sans tronquer pour ne pas perdre tout
        warning('Signal reçu trop court pour compensation complète du délai ; retournement sans truncation.');
        y_sync = y_matched_full;
    end

    % --- Assigner la sortie y_matched (toujours définie) ---
    y_matched = y_sync;

    % --- Echantillonnage aux instants symboles ---
    ux_reconstruit = y_matched(1:nrepet:end);

    % --- Décision sur la constellation QPSK ---
    % angle normalisé en [0,2*pi)
    phase_reconstruit = mod(angle(ux_reconstruit), 2*pi);
    % ramener l'angle sur les indices 0..3 en tenant compte du décalage pi/4
    nphase = round((phase_reconstruit - pi/4) / (pi/2));
    nphase = mod(nphase, 4);

    % --- Mapping inverse QPSK : 0->00, 1->01, 2->10, 3->11 ---
    bits = de2bi(nphase, 2, 'left-msb')';
    m_reconstruit = bits(:).';  % vecteur ligne

    % --- Si on a fourni la longueur originale, retirer le bit de padding ---
    if nargin >= 7 && ~isempty(Nb_bits_original)
        if numel(m_reconstruit) > Nb_bits_original
            m_reconstruit = m_reconstruit(1:Nb_bits_original);
        end
    end
end
