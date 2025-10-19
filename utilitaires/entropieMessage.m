function H = entropieMessage(message, lettres, valeurs)
    % ENTROPIE_MESSAGE Calcule l'entropie d'un message en bits
    %
    % message : chaîne de caractères
    % lettres : vecteur de caractères contenant les symboles possibles
    % valeurs : vecteur de probabilités correspondantes aux symboles
    
    H = 0; % initialisation de l'entropie
    
    % Créer un dictionnaire (map) pour accéder aux probabilités
    proba_map = containers.Map(lettres, valeurs);
    
    % Lettres uniques dans le message
    %lettres_message = unique(message);
    
    for k = 1:length(message)
        lettre = message(k);
        if isKey(proba_map, lettre)
            p = proba_map(lettre);
            if p > 0
                H = H - p * log2(p);
            end
        end
    end
end
