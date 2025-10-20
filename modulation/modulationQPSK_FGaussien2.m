function [x, Ntot, z, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_FGaussien2(m, nus, fp, Db, A)
% modulationQPSK_soft_gauss_fixed_pad
% Même que modulationQPSK_soft_gauss_fixed mais gère numel(m) impair par padding.
%
% Retourne également orig_len (longueur initiale de m) et padded (0/1).

    orig_len = numel(m);
    padded = 0;
    if mod(orig_len,2) ~= 0
        m = [m, 0]; % pad par 0 (on peut choisir 1 si tu préfères)
        padded = 1;
    end

    Ts = 1 / nus;
    iim = 1i;

    % --- mapping QPSK ---
    Nsymb = numel(m) / 2;
    msymbole = reshape(m, 2, Nsymb);
    nphase = bin2dec(num2str(msymbole'))'; % 00->0,01->1,10->2,11->3
    ux = A * exp(iim * (2*pi*nphase/4 + pi/4)); % symboles complexes

    % --- sur-échantillonnage ---
    Rs = Db / 2;
    nrepet = round(nus / Rs);    % échantillons par symbole

    % --- pulse gaussienne ---
    spanSymbols = 6;                 % étendue en symboles (±3 symbols)
    L = spanSymbols * nrepet + 1;    % longueur en échantillons
    center = (L + 1) / 2;
    sigma = (spanSymbols * nrepet) / 6;
    n = (1:L);
    g = exp(-0.5 * ((n - center) / sigma).^2);
    g = g / sqrt(sum(g.^2)); % normalisation par énergie

    % --- upsample ---
    u_ups = upsample(ux, nrepet);        % longueur = Nsymb * nrepet

    % --- mise en forme (convolution full) ---
    u_full = conv(u_ups, g, 'full');    % convolution full
    group_delay = floor((length(g)-1)/2);
    u_shaped = u_full(group_delay+1 : group_delay + length(u_ups));

    % --- modulation porteuse ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped) .* cos(2*pi*fp*t) - imag(u_shaped) .* sin(2*pi*fp*t);

    % --- bruit (sigma2 par défaut = 0 pour test) ---
    sigma2 = 1;
    z = x + sqrt(sigma2) * randn(1, length(x));
end
