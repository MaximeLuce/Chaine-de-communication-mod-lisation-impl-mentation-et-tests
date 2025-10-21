function [x, Ntot, z, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_RCOS(m, nus, fp, Db, A, rolloff)
% modulationQPSK_RCOS
% Modulation QPSK avec filtrage en cosinus surélevé (Raised Cosine).
%
% Entrées :
%   m        : bits d'entrée (0/1)
%   nus      : fréquence d'échantillonnage (Hz)
%   fp       : fréquence porteuse (Hz)
%   Db       : débit binaire (bits/s)
%   A        : amplitude des symboles
%   rolloff  : facteur de rolloff du filtre RC (ex: 0.25)
%
% Sorties :
%   x        : signal modulé réel (Bande passante réduite)
%   Ntot     : longueur totale du signal modulé
%   z        : signal modulé bruité
%   b        : coefficients du filtre RC
%   nrepet   : échantillons par symbole
%   Nsymb    : nombre de symboles
%   group_delay : délai de groupe du filtre (en échantillons)
%   orig_len : longueur initiale du message
%   padded   : indicateur de padding (1 si impair)

    orig_len = numel(m);
    padded = 0;
    if mod(orig_len,2) ~= 0
        m = [m, 0]; % pad pour rendre la longueur paire
        padded = 1;
    end

    Ts = 1 / nus;
    iim = 1i;

    % --- mapping QPSK ---
    Nsymb = numel(m) / 2;
    msymbole = reshape(m, 2, Nsymb);
    nphase = bin2dec(num2str(msymbole'))'; % 00->0,01->1,10->2,11->3
    ux = A * exp(iim * (2*pi*nphase/4 + pi/4)); % symboles complexes QPSK

    % --- sur-échantillonnage ---
    Rs = Db / 2;                    % débit symbole
    nrepet = round(nus / Rs);       % échantillons par symbole

    % --- filtre Raised Cosine ---
    span = 6;                       % span en symboles
    sps = nrepet;                   % samples per symbol
    b = rcosdesign(rolloff, span, sps); % filtre RC

    % --- upsample ---
    u_ups = upsample(ux, nrepet);        % suréchantillonnage

    % --- mise en forme ---
    u_full1 = conv(u_ups, b, 'full');
    u_full = conv(u_full1, b, 'full');
    group_delay = floor((length(b)-1)/2);
    u_shaped = u_full(group_delay+1 : group_delay + length(u_ups));

    % --- modulation porteuse ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped).*cos(2*pi*fp*t) - imag(u_shaped).*sin(2*pi*fp*t);

    % --- bruit (facultatif, sigma2=1 pour test) ---
    sigma2 = 1;
    z = x + sqrt(sigma2)*randn(1, length(x));
end
