%% APPLICATION CBS

% Fonction appliquant le CBS. Fonction de comparaison avec le BABG
%
% Entrées : X => matrice ligne de bits à passer dans le CBS
%           p => Probabilité d'avoir l'apparition d'une erreur
%
% Sorties : Y => matrice ligne (longueur égale à X) des bits après CBS

function [Y] = applicationCBS(X,p)
    assert(0<=p<=1);

    n = length(X);
    Y = zeros(n,1);

    for i=1:n
        randomNumbers = rand(1);   % Génération aléatoire d'une erreur
        if randomNumbers < p       % Cas d'erreur => modification des bits
            if X(i) == 1
                Y(i) = 0;
            end
            if X(i) == 0
                Y(i) = 1;
            end
        end

        if randomNumbers >= p      % Cas sans erreur => on garde les bits
            Y(i) = X(i);
        end
    end
    
    Y=Y';                          % Remise en forme de la sortie
end
