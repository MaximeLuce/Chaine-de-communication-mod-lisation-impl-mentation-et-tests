function [z] = modulationQPSK_soft(m)
    nus = 10000;    % frequence d'echantillonnage (Hz)
    fp = 200;      % frequence porteuse (Hz)
    Db = 200;      % débit binaire (baud=1/sec)
    A = 1;         % amplitude du signal
    
    Ts = 1/nus; % periode d'echantillonnage (sec)
    iim = 1i;
    
    % Mapping QPSK (2 bits/symbole)
    Nsymb = numel(m)/2; % nombre de symboles dans le message
    
    msymbole = reshape(m,2,Nsymb); % sequence de symbole (matrice 2*Nsymb)
    nphase = bin2dec(num2str(msymbole'))';% 00->0, 01->1, 10->2, 11->3
    ux = A*exp(iim*(2*pi*nphase/4 + pi/4));% points QPSK
    
    % suréchantillonnage échantillonnage et débit symbole
    Rs = Db/2;
    nrepet = round(nus/Rs);             
    u_ups = repelem(ux, nrepet); % donne la forme rectangulaire
    Ntot = numel(u_ups);
    t = (0:Ntot-1)*Ts;

    
    x = real(u_ups).*cos(2*pi*fp*t) - imag(u_ups).*sin(2*pi*fp*t);
    
    sigma2 = 1;
    z = x +sqrt(sigma2)*randn(1,length(x)); % BRUIT !!!
end
