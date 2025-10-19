function L = longueurMoyenneEmpirique(message, dictionnaire, probas)
    % LONGUEUR_MESSAGE Calcule la longueur moyenne du message codé
    %
    % message : chaîne de caractères
    % dictionnaire : dictionnaire Huffman (cell array {symbole, code})
    % probas : vecteur de probabilités correspondantes aux symboles
    
    % Initialisation
    L = 0;
    
    % Lettres uniques présentes dans le message
    %lettres_message = unique(message);
    
    % Créer un map pour accéder aux longueurs des codes et probabilités
    code_map = containers.Map();
    proba_map = containers.Map();
    
    for k = 1:size(dictionnaire,1)
        symbole = dictionnaire{k,1};
        code = dictionnaire{k,2};
        code_map(symbole) = length(code);     % longueur du code binaire
        proba_map(symbole) = probas(k);      % probabilité du symbole
    end
    
    % Calcul de la longueur moyenne
    for k = 1:length(message)
        lettre = message(k);
        if isKey(code_map, lettre) && isKey(proba_map, lettre)
            code_map(lettre);
            proba_map(lettre);
            L = L + code_map(lettre) * proba_map(lettre);
        end
    end
end
