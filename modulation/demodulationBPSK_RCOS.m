function [Y, uzbase, nrepet] = demodulationBPSK_RCOS(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded)
% demodulationBPSK_RCOS
% Démodulation BPSK avec filtrage adapté Raised Cosine.
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
%   padded      : indicateur de padding (compatibilité)
%
% Sorties :
%   Y       : bits estimés
%   uzbase  : signal démodulé en bande de base
%   nrepet  : échantillons par symbole

    Ts = 1 / nus;
    t = (0:length(y)-1) * Ts;

    % --- démodulation en bande de base ---
    uzbase = y .* cos(2*pi*fp*t);

    % --- filtrage adapté ---
    uz_full = conv(uzbase, b, 'full');

    % --- échantillonnage symbolique ---
    start_idx = group_delay + 1;
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    if idx(end) > length(uz_full)
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationBPSK: truncation', ...
            'On tronque Nsymb de %d à %d pour tenir dans y.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    sampled = uz_full(idx);

    % --- décision BPSK ---
    Y_full = double(sampled >= 0);

    % --- suppression du padding éventuel ---
    if padded == 1
        Y = Y_full(1:orig_len);
    else
        Y = Y_full;
    end

    % --- test de cohérence ---
    assert(length(Y) == orig_len, 'Erreur : longueur de sortie incohérente.');
end
