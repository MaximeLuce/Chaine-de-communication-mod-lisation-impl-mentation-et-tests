function output_text = decodageLZW(compressed)    

    % Remise en forme en ligne
    compressed = reshape(compressed, 1, []);

    n = length(compressed) / 8;
    reshaped = reshape(compressed, 8, n)'; % Découpage en blocs de 8 bits

    % Adapte le vecteur numérique compressed ene ntrée en vecteur de
    % caractères
    reshapedChars = char(reshaped + '0');   
    reshapedCell  = cellstr(reshapedChars); 

    % Conversion binaire -> entier
    compressed = bin2dec(reshapedCell);      % vecteur d'entiers

    symbols = [' ','a':'z','A':'Z','?','.',',','!',';'];
    dict = containers.Map('KeyType','int32','ValueType','char');

    for i = 1:length(symbols)
        dict(i) = symbols(i);   % Recréation du dico de zéro
    end

    nextCode = length(symbols) + 1; 

    oldCode = compressed(1);    % Premier elt comme initialisation
    w = dict(oldCode);
    output_text = w;

    for i = 2:length(compressed)
        newCode = compressed(i);
        if isKey(dict, newCode)
            entry = dict(newCode);
        else
            entry = [w w(1)];
        end

        output_text = [output_text entry];
        dict(nextCode) = [w entry(1)];
        nextCode = nextCode + 1;

        w = entry;
    end
end