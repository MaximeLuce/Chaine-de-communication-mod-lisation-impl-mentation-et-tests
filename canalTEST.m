u = [];
n = 7;
k = 4;
r = n - k;
length(u);
G = [1 1 1 0 0 0 0; 1 0 0 1 1 0 0; 0 1 0 1 0 1 0; 1 1 0 1 0 0 1];
H = [1 0 1 0 1 0 1; 0 1 1 0 0 1 1; 0 0 0 1 1 1 1];

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


function [Y] = applicationCBS(X,p)
    n = length(X);
    Y = zeros(n,1);
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
end

p = 0.15

test = codage([0 0 0 1], G)

test2 = applicationCBS(test,p)'

function [corrige] = correction(message,H)
    syndrome = mod(message * H',2);
    syndrome = flip(syndrome);
    dec_val = binaryVectorToDecimal(syndrome)
    corrige = message;
    if not(dec_val==0)
        if corrige(dec_val)==1
            corrige(dec_val)=0;
        else
            corrige(dec_val)=1;
        end
    end
end

correction(test2,H)
