function [compressed] = codageLZW(input_text)

    % Initialisation du dictionnaire avec tous les caractères possibles.
    % Le dico est fait pour être adaptatif. Pour le changer, penser à le
    % changer dans decodageLZW également. ATTENTION au nombre de bits qui
    % peut être limitant ! Voir rapport

    dict = containers.Map;
    symbols = [' ','a':'z','A':'Z','?','.',',','!',';'];

    for i = 1:length(symbols)
        dict(symbols(i)) = i; % Mise en place du dico
    end

    nextCode = length(symbols) + 1;

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
            
            w = c; % Reset du w courant
        end
    end

    % Cas dernier élément
    if ~isempty(w)
        compressed(end+1) = dict(w);
    end
    
    converted = dec2bin(compressed,8);       % Conversion sur 8 bits.
    % Longueur maximale de texte garantissant 0 erreurs : 198 caractères

    compressed = reshape(converted', 1, []); % Remise en forme des données
end