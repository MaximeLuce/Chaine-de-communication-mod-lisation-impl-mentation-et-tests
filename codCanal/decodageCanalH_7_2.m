
function [messageDecode] = decodageCanalH_7_2(messageCode, doublon)
    G = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1; 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1];

    messageCode = messageCode(:).';

    [k, n] = size(G);
    l = numel(messageCode);
    nbBlocs = floor(l/n);
    M = reshape(messageCode, n, [])';
    Mcorr = zeros(nbBlocs,n);
    messageDecode = [];

    for i=1:nbBlocs
        Mcorr(i,:) = correction(M(i,:));
        messageDecode = [messageDecode Mcorr(i,1) Mcorr(i,2)];
    end

    if doublon == 1
        messageDecode = messageDecode(1:end-1);
    end
end

function [d] = distance(x,y)
    d = 0;
    for i=1:numel(x)
        d = d + abs(x(i) - y(i));
    end
end

function [corrige] = correction(element)
    l_possibles = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1; 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1; 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0]; % dépend de G
    corrige = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % initialisé par le premier terme
    d_min = 15;

    for i=1:4
        dist = distance(l_possibles(i,:),element);
        if dist < d_min
            d_min = dist;
            corrige = l_possibles(i,:);
        end
    end
end

