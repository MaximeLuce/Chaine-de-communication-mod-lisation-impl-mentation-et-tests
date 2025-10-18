function [compressed] = codageLZW(input_text)

    % Initialisation du dictionnaire avec tous les caractères possibles
    dict = containers.Map;
    symbols = [' ','a':'z'];

    for i = 1:27
        dict(symbols(i)) = i; % Mise en place du dico
    end
    nextCode = length(symbols) + 1; 

    % Variables
    w = '';               % Chaîne courante
    compressed = [];      % Résultat final

    for i = 1:length(input_text)
        c = input_text(i);
        wc = [w c];

        if isKey(dict, wc)
            w = wc;
        else
            % Ajouter le code de w dans le flux de sortie
            compressed(end+1) = dict(w); % Agrandissement du compressed avec end+1

            % Ajouter wc au dictionnaire
            dict(wc) = nextCode;
            nextCode = nextCode + 1;
            
            w = c;
        end
    end

    % Ajouter le dernier code
    if ~isempty(w)
        compressed(end+1) = dict(w);
    end
    
    converted = dec2bin(compressed,8);
    compressed = reshape(converted', 1, []);
    
   
end