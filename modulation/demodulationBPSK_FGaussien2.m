function [Y, uzbase, nrepet] = demodulationBPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded)
% demodulationBPSK_FGaussien2
% Démodulation BPSK correspondant à modulationBPSK_FGaussien2.
% Supprime le bit de padding si nécessaire.
% Vérifie que la longueur en sortie = longueur d'entrée.

    Ts = 1 / nus;
    iim = 1i;
    t = (0:length(y)-1) * Ts;

    % --- signal baseband ---
    uzbase = hilbert(y) .* exp(-iim * 2*pi*fp*t);

    % --- filtrage adapté ---
    uz_full = conv(uzbase, g, 'full');
    start_idx = group_delay + 1;
    idx = start_idx + (0:(Nsymb-1)) * nrepet;

    if idx(end) > length(uz_full)
        Nsymb_new = floor((length(uz_full) - start_idx + 1) / nrepet);
        warning('demodulationBPSK: truncation', 'On tronque Nsymb de %d à %d.', Nsymb, Nsymb_new);
        Nsymb = Nsymb_new;
        idx = start_idx + (0:(Nsymb-1)) * nrepet;
    end

    sampled = real(uz_full(idx));

    % --- décision BPSK ---
    Y_full = double(sampled < 0); % seuil à 0 -> bit 1 si négatif, 0 sinon

    % --- suppression du padding ---
    if padded == 1
        Y = Y_full(1:orig_len);
    else
        Y = Y_full;
    end

    % --- test cohérence longueur entrée/sortie ---
    assert(length(Y) == orig_len, 'Erreur : longueur de sortie différente de lentrée');
end
