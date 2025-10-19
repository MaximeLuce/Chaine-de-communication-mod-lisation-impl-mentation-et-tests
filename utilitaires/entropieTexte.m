function [H] = entropieTexte(texte)
    symboleUnique = unique(texte);
    matrice = proba(symboleUnique, texte)
    
    H = CalculHP(matrice);
end

function [matrice] = proba(symboleUnique, message)
    n = length(symboleUnique);
    m = length(message);
    matrice = zeros(1,n);

    for i=1:n
        matrice(1,i) = sum(message == symboleUnique(i));
    end
    matrice = matrice/m;
end

function [H] =CalculHP(proba) % entropie à partir des probas
    n = length(proba);
    H=0;
    for i=1:n
        H = H - proba(i)*log2(proba(i));
    end

end