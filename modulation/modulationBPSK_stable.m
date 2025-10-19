function [z] = modulationBPSK(m)
    nus = 10000;    % fréquence d'échantillonnage (Hz)
    fp = 200;       % fréquence porteuse (Hz)
    Db = 200;       % débit binaire (baud)
    A = 1;          % amplitude du signal
    
    Ts = 1/nus;     % période d'échantillonnage (sec)
    iim = 1i;       % unité imaginaire
    
    % --- Mapping BPSK (1 bit / symbole) ---
    % 0 -> +1 ; 1 -> -1
    Nsymb = numel(m);             % nombre de symboles (un bit par symbole)
    ux = A * (1 - 2*m);           % mapping BPSK : 0→+1, 1→−1
    
    % --- Suréchantillonnage et génération du signal ---
    Rs = Db;                      % débit symbole = débit binaire pour BPSK
    nrepet = round(nus/Rs);       % nombre d'échantillons par symbole
    u_ups = repelem(ux, nrepet);  % forme rectangulaire (suréchantillonnée)
    Ntot = numel(u_ups);
    t = (0:Ntot-1)*Ts;

    
    % --- Modulation porteuse ---
    x = real(u_ups).*cos(2*pi*fp*t); % BPSK : signal réel uniquement
    
    % --- Ajout de bruit ---
    sigma2 = 1;
    z = x + sqrt(sigma2)*randn(1,length(x)); % ajout de bruit blanc gaussien
end
