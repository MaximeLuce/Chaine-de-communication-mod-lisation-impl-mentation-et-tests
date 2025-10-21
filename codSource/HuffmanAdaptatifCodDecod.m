function [MessageEncode, MessageDecode, dictionnaire, probas] = HuffmanAdaptatifCodDecod(message)
    % Huffman encode/decode pour un message (chaîne de caractères)
    % Entrée: message - 1xN char (ex : 'exemple')
    % Sorties: encodedMessage - vecteur binaire (0/1)
    %         decodedMessage - chaîne décodée (char)

    % Symboles uniques (chars) et leurs fréquences
    symboleUnique = unique(message); % on transforme le message en liste de symboles uniques
    %counts  = arrayfun(@(c) sum(message == c), symbols);
    effectifs = comptage(symboleUnique, message);
    probas    = effectifs / sum(effectifs);

    symbolsCell = cellstr(symboleUnique'); % on découpe la chaîne de caractère en matrice colonne de caractère
    dictionnaire = huffmandict(symbolsCell, probas);

    % Transformer le message en cellule (un symbole par cellule) pour encoder
    msgCell = cellstr(message');                      % {'e'; 'x'; 'e'; ...}
    MessageEncode = huffmanenco(msgCell, dictionnaire);

    % Décoder et reconstituer la chaîne
    decodedCell = huffmandeco(MessageEncode, dictionnaire); % retourne {'e','x',...}
    % Étape 1: Trouver les index de toutes les cellules qui sont vides
    indexVides = cellfun('isempty', decodedCell);
    
    % Étape 2: Remplacer ces cellules vides par un espace
    decodedCell(indexVides) = {' '};
    MessageDecode = [decodedCell{:}];    
end

function [matrice] = comptage(symboleUnique, message)
    n = length(symboleUnique);
    m = length(message);
    matrice = zeros(1,n);

    for i=1:n
        matrice(1,i) = sum(message == symboleUnique(i));
    end
end
