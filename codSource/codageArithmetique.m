function [code, L] = codageArithmetique(message, symbols, probs, cum_probs) 
    L = numel(message);
    % Initialisation
    low = 0;
    high = 1;
    
    for i = 1:length(message)
        sym = message(i);
        indice = find(symbols == sym, 1);
        range = high - low;
        high = low + range * cum_probs(indice+1);
        low  = low + range * cum_probs(indice);
    end
    
    % Code final (dans [low, high))
    code = (low + high) / 2;

    rang = detection(low,high);
    
    code = FloatToBin(code,rang);
end

function [codeBinaire] = FloatToBin(code,rang)
    % Convertir le nombre avec haute précision (20 décimales ici)
    test = append('%.', num2str(rang),'f');
    codeStr = sprintf(test, code);
    
    % Extraire la partie après le point décimal
    decimalPart = extractAfter(codeStr, '.');
    
    % Supprimer les zéros de fin inutiles
    decimalPart = regexprep(decimalPart, '0+$', '');
    
    % Convertir les caractères décimaux en valeurs numériques
    decimalValue = decimalPart - '0';
    
    % Convertir chaque chiffre en binaire sur 4 bits (0 -> 0000, 9 -> 1001)
    codeBinaire = dec2bin(decimalValue, 4); 
    
    % Mettre en forme en vecteur ligne binaire (0/1)
    codeBinaire = reshape(codeBinaire.', 1, []);
    codeBinaire = codeBinaire - '0';
end

function [c] = detection(low,high)

    lowFlottant = sprintf('%.10f', low)- '0';


    highFlottant = sprintf('%.10f', high)- '0';
    
    diff = highFlottant - lowFlottant;
    
    c = 0;
    n = length(diff);
    
    for i = 1:n
        if diff(n-i+1) ~= 0
            c=n-i+1;
        end
    end
end
