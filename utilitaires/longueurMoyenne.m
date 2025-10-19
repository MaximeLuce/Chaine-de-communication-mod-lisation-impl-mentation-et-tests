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