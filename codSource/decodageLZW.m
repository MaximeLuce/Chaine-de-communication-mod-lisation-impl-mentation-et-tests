function output_text = decodageLZW(compressed)
    binaryStream = compressed;  % ton flux binaire (ex: [0 1 0 1 ...] ou '0101...')
    
    % Si c'est un vecteur de nombres, on le convertit en chaîne de caractères :
    if isnumeric(binaryStream)
        binaryStream = char(binaryStream + '0');
    end
    
    % Vérifie que la longueur est bien multiple de 8
    n = length(binaryStream) / 8;
    if mod(length(binaryStream), 8) ~= 0
        error('La longueur du flux binaire doit être un multiple de 8.');
    end
    
    % Découpe en blocs de 8 bits
    reshaped = reshape(binaryStream, 8, n)';
    
    % Conversion ligne par ligne en entier
    reshapedCell = cellstr(reshaped);
    compressed = bin2dec(reshapedCell);


    symbols = [' ','a':'z'];
    dict = containers.Map('KeyType','int32','ValueType','char');

    for i = 1:length(symbols)
        dict(i) = symbols(i); % Création du dico de zéro
    end

    nextCode = length(symbols) + 1; 

    oldCode = compressed(1);
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