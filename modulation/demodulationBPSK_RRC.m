function [Y, uzbase, nrepet] = demodulationBPSK_RRC(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded)
% demodulationBPSK_RRC
% Démodulation BPSK avec filtrage adapté Root Raised Cosine (RRC)
%
% Entrées :
%   y           : signal reçu (réel)
%   nus         : fréquence d'échantillonnage
%   fp          : fréquence porteuse
%   Db          : débit binaire
%   A           : amplitude des symboles
%   b           : filtre RRC utilisé à l'émetteur
%   Nsymb       : nombre de symboles
%   nrepet      : échantillons par symbole
%   group_delay : délai total émetteur+récepteur (échantillons)
%   orig_len    : longueur originale du message
%   padded      : indicateur de padding
%
% Sorties :
%   Y       : bits estimés (0 ou 1)
%   uzbase  : signal bande de base complexe
%   nrepet  : échantillons par symbole (inchangé)

    Ts = 1 / nus;
    iim = 1i;
    t = (0:length(y)-1) * Ts;

    % --- signal analytique bande de base ---
    uzbase = hilbert(y) .* exp(-iim * 2*pi*fp*t);

    % --- filtrage adapté RRC ---
    uz_base_filtered = conv(uzbase, b, 'full');   % filtre adapté
    uz_full = conv(uz_base_filtered, b, 'full');  % double RRC = RC global

    % --- échantillonnage symbolique ---
    start_idx = group_delay + 1;
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    if idx(end) > length(uz_full)
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationBPSK_RRC: truncation', ...
            'On tronque Nsymb de %d à %d pour tenir dans y.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    % --- décision BPSK ---
    sampled = real(uz_full(idx));
    Y_full = zeros(1, Nsymb);
    for k = 1:Nsymb
        if sampled(k) >= 0
            Y_full(k) = 0;
        else
            Y_full(k) = 1;
        end
    end

    % --- suppression padding éventuel ---
    if padded == 1
        Y = Y_full(1:orig_len);
    else
        Y = Y_full;
    end
end
