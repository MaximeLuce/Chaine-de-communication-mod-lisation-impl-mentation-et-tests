function [x, Ntot, z, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_FGaussien2(m, nus, fp, Db, A)
% modulationBPSK_FGaussien2
% Version BPSK de modulationQPSK_FGaussien2.
% Structure identique, mais mapping BPSK (1 bit -> 1 symbole).
% Ajoute un test sur la cohérence de la longueur entrée/sortie.

    orig_len = numel(m);
    padded = 0; % pas besoin de padding sauf si on veut longueur paire
    if mod(orig_len,1) ~= 0
        m = [m, 0];
        padded = 1;
    end

    Ts = 1 / nus;
    iim = 1i;

    % --- mapping BPSK ---
    % bits 0 -> +A, bits 1 -> -A
    Nsymb = numel(m);
    ux = A * (1 - 2*m);  % mapping BPSK

    % --- sur-échantillonnage ---
    Rs = Db;  % débit symbole = débit binaire pour BPSK
    nrepet = round(nus / Rs);

    % --- pulse gaussienne ---
    spanSymbols = 6;
    L = spanSymbols * nrepet + 1;
    center = (L + 1) / 2;
    sigma = (spanSymbols * nrepet) / 6;
    n = (1:L);
    g = exp(-0.5 * ((n - center) / sigma).^2);
    g = g / sqrt(sum(g.^2)); % normalisation énergétique

    % --- upsample ---
    u_ups = upsample(ux, nrepet);

    % --- mise en forme ---
    u_full = conv(u_ups, g, 'full');
    group_delay = floor((length(g)-1)/2);
    u_shaped = u_full(group_delay+1 : group_delay + length(u_ups));

    % --- modulation porteuse ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped) .* cos(2*pi*fp*t);

    % --- bruit (sigma2=1 pour test) ---
    sigma2 = 1;
    z = x + sqrt(sigma2) * randn(1, length(x));

    % --- test cohérence longueur ---
    assert(length(x) == length(z), 'Erreur : longueur x et z incohérente');
end
