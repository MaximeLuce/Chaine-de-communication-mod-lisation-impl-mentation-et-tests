function [x, Ntot, z] = modulationBPSK(m, nus, fp, Db, A)
    
    Ts = 1/nus;     % période d'échantillonnage (sec)
    iim = 1i;       
    
    
    Nsymb = numel(m); % # de symb
    ux = A * (1 - 2*m); % on convertit 0→+1, 1→−1 (BPSK=
    
    %  suréchantillonnage
    Rs = Db; % débit symbole = débit binaire pour BPSK
    nrepet = round(nus/Rs);      
    u_ups = repelem(ux, nrepet);  
    Ntot = numel(u_ups);
    t = (0:Ntot-1)*Ts;

    
    % mod sur fp
    x = real(u_ups).*cos(2*pi*fp*t); % signal réel uniquement car BPSK
    
    % bruit
    sigma2 = 1; % sigma = sqrt(N0)
    z = x + sqrt(sigma2)*randn(1,length(x)); 
end
