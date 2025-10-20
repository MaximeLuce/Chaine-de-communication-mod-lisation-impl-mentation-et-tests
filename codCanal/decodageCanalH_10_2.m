%% DECODAGE DU CANAL H(10,2)


% Fonction de décodage canal permettant, avec un message récupéré contenant
% des erreurs, de récupérer le message envoyé avant le canal de manière la
% plus précise possible.
%
% Entrées : messageCode => matrice ligne contenant le message reçu en 
%           sortie de canal, renforcé
%           doublon => valeur valant 1 si la longueur du message envoyé est
%           impaire
%
% Sorties : messageDecode => message décodé et corrigé via H(10,2) et G
%           donné

function [messageDecode] = decodageCanalH_10_2(messageCode, doublon)
    G = [1 0 1 0 1 0 1 0 1 0; 0 1 0 1 0 1 0 1 0 1];     % Matrice génératrice

    messageCode = messageCode(:).';

    [~, n] = size(G);
    l = numel(messageCode);
    nbBlocs = floor(l/n);

    M = reshape(messageCode, n, [])'; % Remise en forme du msg pour correction
    Mcorr = zeros(nbBlocs,n);
    messageDecode = [];

    for i=1:nbBlocs
        Mcorr(i,:) = correction(M(i,:));
        messageDecode = [messageDecode Mcorr(i,1) Mcorr(i,2)];
        % Récupération des deux premiers termes (I2 dans G), qui
        % correspondent aux deux bits envoyés en entrée. A modifier si G
        % est changée
    end

    if doublon == 1
        messageDecode = messageDecode(1:end-1); % Supprime le dernier bit
        % en cas de longueur envoyée impaire
    end
end



% Fonction distance déterminant la distance de Manhattan entre deux
% vecteurs en entrée
%
% Entrées : x => matrice ligne contenant le premier vecteur à étudier
%           y => matrice ligne contenant le second vecteur à étudier
%
% Sorties : d => distance de Manhattan entre les deux vecteurs

function [d] = distance(x,y)

    assert(numel(x)==numel(y))
    d = 0;

    for i=1:numel(x)            % boucle sur les éléments
        d = d + abs(x(i) - y(i));
    end

end

% Fonction correction ramenant l'élément reçu et corrigeant selon les 4
% valeurs réellement possibles (trouvées manuellement). Utilise la distance
% de Manhattan pour la comparaison.
%
% Entrées : element => matrice ligne de 10 élts à corriger
%
% Sorties : corrige => élément le plus proche de la liste l_possibles

function [corrige] = correction(element)

    l_possibles = [0 0 0 0 0 0 0 0 0 0; 
                   0 1 0 1 0 1 0 1 0 1; 
                   1 0 1 0 1 0 1 0 1 0; 
                   1 1 1 1 1 1 1 1 1 1];      % dépend de G

    corrige = [0 0 0 0 0 0 0 0 0 0];          % initialisé par le premier terme
    d_min = 10;                               % initialisé à la distance max possible

    for i=1:4                                 % boucle d'étude et de correction
        dist = distance(l_possibles(i,:),element);

        if dist < d_min
            d_min = dist;
            corrige = l_possibles(i,:);
        end
    end

end

