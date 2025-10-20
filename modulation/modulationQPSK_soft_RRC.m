function [x, Ntot, z, t, u_shaped, delay] = modulationQPSK_soft_RRC(m, nus, fp, Db, A, alpha)
% Modulation QPSK avec filtrage RRC
% Sorties alignées pour correspondre à la démodulation

    Ts = 1/nus;
    iim = 1i;

    % === Mapping QPSK ===
    Nsymb = numel(m)/2;
    msymbole = reshape(m, 2, Nsymb);
    nphase = bin2dec(num2str(msymbole'))'; % 00->0, 01->1, 10->2, 11->3
    ux = A * exp(iim * (2*pi*nphase/4 + pi/4)); % symboles QPSK

    % === Paramètres temporels ===
    Rs = Db/2;
    nrepet = round(nus / Rs);
    span = 6; % durée du filtre (en symboles)

    % === Suréchantillonnage ===
    u_ups = upsample(ux, nrepet);

    % === Filtre RRC ===
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    rrcFilter = rrcFilter / norm(rrcFilter);

    % === Filtrage de mise en forme ===
    u_shaped = conv(u_ups, rrcFilter, 'full');

    % === Délai du filtre ===
    delay = (span/2) * nrepet;

    % === Troncature pour enlever le retard ===
    u_shaped = u_shaped(delay+1:end-delay);

    % === Signal RF ===
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped).*cos(2*pi*fp*t) - imag(u_shaped).*sin(2*pi*fp*t);

    % === Ajout de bruit (désactivé ici) ===
    sigma2 = 0.1;
    z = x + sqrt(sigma2) * randn(1, length(x));
end