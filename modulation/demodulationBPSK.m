function [uz_block, Y] = demodulationBPSK(y, nus, fp, Db, A)

    Ts = 1/nus;    
    iim = 1i;
    t = (0:length(y)-1)*Ts;

    Rs = Db;                      
    nrepet = round(nus/Rs);
    Ntot = floor(numel(y)/nrepet)*nrepet;
    Nsymb = Ntot / nrepet;
    

    % demod
    uznus = hilbert(y).*exp(-iim*2*pi*fp*t);  % signal démodulé complexe

    %
    % k = (nrepet/2) : nrepet : Ntot;           % indices des symboles
    % uz = uznus(k);
    % 
    % %decision dure
    % n = length(uz);
    % Y = zeros(1, n);
    % for i = 1:n
    %     if real(uz(i)) >= 0
    %         Y(i) = 0;
    %     else
    %         Y(i) = 1;
    %     end
    % end

    % DECISION SOUPLE
    % partie utile = Ntot échantillons
    uz_block = reshape(uznus(1:Ntot), nrepet, Nsymb); % matrice de taille nrepet x Nsymb
    
    % intégration sur la composante réelle
    symb_vals = sum(real(uz_block), 1);   % somme sur les nrepet échantillons
    % autre façon : on intègre pas mais on prend la moyenne :
    % symb_vals = mean(real(uz_block), 1);

    % decision
    Y = zeros(1, Nsymb);
    for idx = 1:Nsymb
    if symb_vals(idx) >= 0
        Y(idx) = 0;
    else
        Y(idx) = 1;
    end
end
