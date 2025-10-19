function [matrice] = proba(symboleUnique, message)
    n = length(symboleUnique);
    m = length(message);
    matrice = zeros(1,n);

    for i=1:n
        matrice(1,i) = sum(message == symboleUnique(i));
    end
    matrice = matrice/m
end

function [dico] = unicite(message) % utile pour lzw
    n = length(message);
    dico = [-1];
    for i=1:n
        caractere = message(i);
        if not(ismember(dico,caractere))
            dico(end+1) = caractere;
        end
    end
    dico = dico(2:end)
end



function [H] = entropieTexte(texte)
    symboleUnique = unique(texte);
    matrice = proba(symboleUnique, texte);
    
    H = CalculHP(matrice);
end

function [rendement] = rendement(texte, K)
    rendement = entropieTexte(texte)/log2(K);
end


function [l_k] = fromDicoToListL_k(dict)
    l_k = zeros(length(dict), 1);
    
    for i = 1:length(dict) % on parcourt le dico
        l_k(i) = length(dict{i, 2}); % on ajoute la longueur du symb. codé
    end
    l_k = l_k'; % on prend la transposée pour compatiblité avec longueurMoyenne
end

function [longueur] = longueurMoyenne(listeSymb, proba)
    if length(listeSymb) ~= length(proba)
        error('Pb de taille des paramètres !');
    end
    
    % pb de conversion en tableau
    if ischar(listeSymb) || isstring(listeSymb)
        listeSymb = str2num(listeSymb); % conversion
    end
   
    longueur = sum(proba .* listeSymb); % on fait la moyenne
end


texte = '23 djhf vdshf sdjhfg yhtzesfg qyesfgd zeyqtf tqzsefhg sqdctyvf';
H = entropieTexte(texte)
eta = rendement(texte, 27)