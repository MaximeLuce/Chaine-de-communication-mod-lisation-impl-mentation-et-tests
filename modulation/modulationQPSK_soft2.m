function [x, Ntot, z, hcos2] = modulationQPSK_Fcos(m, nus, fp, Db, A)
    Ts = 1/nus;                 % période d'échantillonnage
    iim = 1i;
    Nsymb = numel(m)/2;         % nombre de symboles
    msymbole = reshape(m,2,Nsymb);
    nphase = bin2dec(num2str(msymbole'))'; % 00->0, 01->1, 10->2, 11->3
    ux = A * exp(iim * (2*pi*nphase/4 + pi/4)); % symboles QPSK

    % --- Suréchantillonnage ---
    Rs = Db/2;                  % débit symbole
    nrepet = round(nus/Rs);     % nb d'échantillons par symbole

    % --- Forme de pulse cos² ---
    t_pulse = linspace(-pi/2, pi/2, nrepet);
    hcos2 = (cos(t_pulse)).^2;  % cos² entre -pi/2 et +pi/2
    hcos2 = hcos2 / sum(hcos2); % normalisation en énergie

    % --- Génération du signal suréchantillonné ---
    u_ups = upsample(ux, nrepet);
    u_shaped = conv(u_ups, hcos2, 'same'); % mise en forme douce

    % --- Modulation ---
    Ntot = numel(u_shaped);
    t = (0:Ntot-1) * Ts;
    x = real(u_shaped).*cos(2*pi*fp*t) - imag(u_shaped).*sin(2*pi*fp*t);

    % --- Ajout de bruit ---
    sigma2 = 1;
    z = x + sqrt(sigma2) * randn(1, length(x));
end
