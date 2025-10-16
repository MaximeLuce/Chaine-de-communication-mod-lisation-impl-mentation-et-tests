function [Y] = applicationCBS(X,p)
    n = length(X);
    Y = zeros(n,1);
    % I love u :)
    %n = 10; % However many numbers you want.
    for i=1:n
        randomNumbers = rand(1);
        if randomNumbers < p % alors on a une erreur
            if X(i) == 1
                Y(i) = 0;
            end
            if X(i) == 0
                Y(i) = 1;
            end
        end
        if randomNumbers >= p
            Y(i) = X(i);
        end
    end
    Y=Y';
end
