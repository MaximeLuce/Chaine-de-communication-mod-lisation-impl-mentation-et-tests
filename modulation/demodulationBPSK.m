function [Y] = demodulationBPSK(y)
    nus = 5000;   % fréquence d'échantillonnage (Hz)
    fp = 200;      % fréquence porteuse (Hz)
    Db = 200;      % débit binaire (bits/s)
    A = 1;         % amplitude du signal

    Ts = 1/nus;    
    iim = 1i;
    t = (0:length(y)-1)*Ts;

    % --- Paramètres de suréchantillonnage ---
    Rs = Db;                         % en BPSK : Rs = Db
    nrepet = round(nus/Rs);
    Ntot = floor(numel(y)/nrepet)*nrepet;
    Nsymb = Ntot / nrepet;
    

    % Extraction de l'enveloppe complexe (comme pour QPSK)
    uznus = hilbert(y).*exp(-iim*2*pi*fp*t);  % signal démodulé complexe

    % % --- Prélèvement au centre de chaque symbole ---
    % k = (nrepet/2) : nrepet : Ntot;           % indices des symboles
    % uz = uznus(k);
    % 
    % % --- Décision binaire ---
    % % En BPSK, les points sont sur l'axe réel : +1 → bit 0, -1 → bit 1
    % n = length(uz);
    % Y = zeros(1, n);
    % for i = 1:n
    %     if real(uz(i)) >= 0
    %         Y(i) = 0;
    %     else
    %         Y(i) = 1;
    %     end
    % end


    % On ne prend plus seulement le centre : on intègre (somme) sur chaque symbole
    % On travaille sur la partie utile (Ntot échantillons)
    uz_block = reshape(uznus(1:Ntot), nrepet, Nsymb);   % matrix nrepet x Nsymb
    
    % Option 1 : intégration sur la composante réelle (matched filter rectangulaire)
    symb_vals = sum(real(uz_block), 1);   % somme sur les nrepet échantillons
    
    % Option 2 (si tu veux la moyenne) :
    % symb_vals = mean(real(uz_block), 1);
    
    % Décision BPSK : >0 => 0, <0 => 1
    Y = zeros(1, Nsymb);
    for idx = 1:Nsymb
    if symb_vals(idx) >= 0
        Y(idx) = 0;
    else
        Y(idx) = 1;
    end
end
