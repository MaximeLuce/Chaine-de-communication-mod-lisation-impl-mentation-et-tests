
function [MessageDecode, dictionnaire, probas] = huffmanUniverselDecod(MessageEncode, symbolsCell, probas)
    % Huffman encode pour un message (chaîne de caractères)
    % Entrée: message - 1xN char (ex : 'exemple')
    % Sorties: encodedMessage - vecteur binaire (0/1)
    %         dictionnaire - chaîne décodée (char)
    % probas

 
    dictionnaire = huffmandict(symbolsCell, probas);
    probas = probas;
    
    
    % Décoder et reconstituer la chaîne
    try
        decodedCell = huffmandeco(MessageEncode, dictionnaire); % retourne {'e','x',...}

        % Étape 1: Trouver les index de toutes les cellules qui sont vides
        indexVides = cellfun('isempty', decodedCell);
        
        % Étape 2: Remplacer ces cellules vides par un espace
        decodedCell(indexVides) = {' '};
        MessageDecode = [decodedCell{:}];  % concatène en 'exemple'
    catch
        warning("Il y a eu plus d'une erreur donc pas de correction.");
        MessageDecode = 0;
    end
    
end
