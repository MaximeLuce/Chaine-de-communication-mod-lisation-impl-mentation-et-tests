function [z] = modulationQPSK(m)
    nus = 1000;   % Hz
    fp = 200;    % Hz
    Db = 200;    % bits/s
    A = 1;
    
    Ts = 1/nus;
    iim = 1i;
    
    % Mapping QPSK (2 bits/symbole)
    Nsymb = numel(m)/2;
    msymbole = reshape(m,2,Nsymb);
    nphase = bin2dec(num2str(msymbole'))';% 00->0, 01->1, 10->2, 11->3
    ux = A*exp(iim*(2*pi*nphase/4 + pi/4));% points QPSK
    
    % suréchantillonnage
    Rs = Db/2;
    nrepet = round(nus/Rs);             
    u_ups = repelem(ux, nrepet); % donne la forme rectangulaire
    Ntot = numel(u_ups);
    t = (0:Ntot-1)*Ts;
    
    x = real(u_ups).*cos(2*pi*fp*t) - imag(u_ups).*sin(2*pi*fp*t);
    
    % Canal sans bruit
    
    sigma2 = 50/50;
    z = x+sqrt(sigma2)*randn(1,length(x)); % BRUIT !!!
end
