function [messageRobuste, doublon] = codageCanal(message)
    n = 7;
    k = 4;
    r = n - k;
    G = [1 1 1 0 0 0 0; 1 0 0 1 1 0 0; 0 1 0 1 0 1 0; 1 1 0 1 0 0 1];
    lMessage = length(message);

    % on traite le cas si la longueur de message n'est pas un multiple de k=4
    if mod(lMessage, k) ~= 0 % si pas multiple
        message = [message; zeros(1,k- (lMessage-mod(lMessage, k))/k)]; % on complète avec des zéros
    end
    messageRobuste = codage(message, G);
    doublon = mod(lMessage, k);
end


function [decoupe] = decoupage(octets) %les bits supp sont supposés appartenant à la chaine d'après
    l = length(octets);
    j = 1;
    decoupe = [];
    for i = 1:(floor(l/4))
        decoupe = [decoupe ; [octets(j) octets(j+1) octets(j+2) octets(j+3)]];
        j = j + 4;
    end
end

function [code] = codage(octets, G)
    decoupe = decoupage(octets);
    taille = floor(length(octets)/4);
    code = [];
    
    for i = 1:taille % remplissage de code
        partie_a_coder = decoupe(i,:);
        elt_code = partie_a_coder * G;
        for j = 1:length(elt_code)
            elt_code(j) = mod(elt_code(j),2); % modulo 2 pour revenir en binaire
        end
        code = [code elt_code];% pour debug ajouter le ; entre code et elt_code
    end
end




