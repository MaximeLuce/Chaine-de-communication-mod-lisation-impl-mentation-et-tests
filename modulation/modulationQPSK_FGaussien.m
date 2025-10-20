function [x, Ntot, z, g, nrepet, Nsymb, group_delay] = modulationQPSK_FGaussien(m, nus, fp, Db, A)
% modulationQPSK_soft_gauss_fixed
%   Modulation QPSK avec pulse gaussienne. Cette version corrige le
%   décalage introduit par la convolution et renvoie les meta-infos
%   nécessaires à la démodulation (nrepet, Nsymb, group_delay).
%
% Entrées:
%   m   : vecteur de bits (1 x (2*Nsymb))
%   nus : fréquence d'échantillonnage (Hz)
%   fp  : fréquence porteuse (Hz)
%   Db  : débit binaire (bits/s)
%   A   : amplitude des symboles
%
% Sorties:
%   x, z      : signal modulé (x sans bruit, z bruité)
%   g         : pulse gaussienne utilisée (vecteur)
%   nrepet    : échantillons par symbole
%   Nsymb     : nombre de symboles
%   group_delay : délai (en échantillons) introduit par la pulse

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
    sigma = (spanSymbols * nrepet) / 6; % approx => ±3*sigma ~ spanSymbols/2 each side
    n = (1:L);
    g = exp(-0.5 * ((n - center) / sigma).^2);
    % Normalisation en énergie (option recommandée)
    g = g / sqrt(sum(g.^2));

    % --- upsample (insertion de zéros entre symboles) ---
    u_ups = upsample(ux, nrepet);        % longueur = Nsymb * nrepet

    % --- mise en forme (convolution full) ---
    u_full = conv(u_ups, g, 'full');    % convolution full
    % group delay (en échantillons)
    group_delay = floor((length(g)-1)/2);
    % On recadre pour retrouver une séquence alignée sur u_ups (même length)
    u_shaped = u_full(group_delay+1 : group_delay + length(u_ups));

    % --- modulation porteuse ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped) .* cos(2*pi*fp*t) - imag(u_shaped) .* sin(2*pi*fp*t);

    % --- bruit (par défaut sigma2=0 pour test ; change si besoin) ---
    sigma2 = 1; 
    z = x + sqrt(sigma2) * randn(1, length(x));
end
