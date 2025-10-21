function [decoded] = decodageArithmetique(code, symbols, probs, cum_probs, L)
    %L = (length(code) - mod(length(code),4))/4+1
    code = BinToFloat(code);
    rangZero = detecterZero(code);
    %code = 0.289861042869181

    % longueur du message à décoder
    decoded = repmat(' ', 1, L);
    
    low = 0;
    high = 1;
    value = code;
    
    for i = 1:L
        range = high - low;
        % normaliser le code dans [0,1)
        scaled_value = (value - low) / range;
        
        % trouver le symbole correspondant
        idx = find(cum_probs <= scaled_value, 1, 'last');
        if idx == length(cum_probs)  % sécurité
            idx = idx - 1;
        end
        
     
        decoded(i) = symbols(idx);
        
        % mise à jour de l'intervalle
        high = low + range * cum_probs(idx+1);
        low  = low + range * cum_probs(idx);
    end
end

function [code] = BinToFloat(codeBinaire)
    % Vérifie que la longueur de la ligne binaire est un multiple de 4
    if mod(length(codeBinaire), 4) ~= 0
        error('La longueur de la ligne binaire doit être un multiple de 4.');
    end

    nGroups = length(codeBinaire)/4;
    decimales = zeros(1, nGroups);

    % Conversion de chaque groupe de 4 bits en décimal
    for i = 1:nGroups
        idx = (i-1)*4 + (1:4); % indices du groupe
        groupBits = codeBinaire(idx);
        decimales(i) = groupBits(1)*8 + groupBits(2)*4 + groupBits(3)*2 + groupBits(4)*1;
    end
    
    m = length(decimales);
    s = '0.';

    for i = 1:m
        s = append(s,num2str(decimales(i)));
    end

    % Concaténation des chiffres pour former un string
    code = str2num(s);
end

function[c] = detecterZero(code)
    code = sprintf('%.10f', code)- '0';
    % n = length(code);
    % c=0
    % for i = 1:n
    %     if code(n-i+1:end) ~= 0
    %         c=n-i+1;
    %     end
    % end
    c = length(code) - 1;
end