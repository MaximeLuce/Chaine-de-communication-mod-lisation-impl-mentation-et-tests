function [l_k] = fromDicoToListL_k(dict)
    l_k = zeros(length(dict), 1);
    
    for i = 1:length(dict) % on parcourt le dico
        l_k(i) = length(dict{i, 2}); % on ajoute la longueur du symb. codé
    end
    l_k = l_k; % on prend la transposée pour compatiblité avec longueurMoyenne
end