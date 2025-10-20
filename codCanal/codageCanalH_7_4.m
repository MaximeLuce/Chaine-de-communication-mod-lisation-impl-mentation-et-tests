%% CODAGE DU CANAL H(7,4)

% Fonction appliquant le codage canal H(7,4) sur le message entré. Découpe
% le message selon des morceaux de longueur k et code les blocs avant de
% les assembler à nouveau
%
% Entrées : message => matrice quelconque binaire contenant le message
%
% Sorties : messageRobuste => matrice ligne binaire contenant le msg robuste
%           doublon => vaut 1 si le nb de bits du msg est impair. Dans ce
%           cas, le codage canal ajoute un bit (ici 0) pour compléter le
%           couple et le coder de la même façon

function [rho_cc, messageRobuste, doublon] = codageCanalH_7_4(message)
    n = 7;
    k = 4;
    r = n - k;

    G = [1 1 1 0 0 0 0; 
        1 0 0 1 1 0 0; 
        0 1 0 1 0 1 0; 
        1 1 0 1 0 0 1];

    lMessage = length(message);

    % on traite le cas si la longueur de message n'est pas un multiple de k=4
    if mod(lMessage, k) ~= 0 % si pas multiple
        message = [message; zeros(1,k- (lMessage-mod(lMessage, k))/k)]; % on complète avec des zéros
    end

    messageRobuste = codage(message, G);
    doublon = mod(lMessage, k);
    rho_cc = k/n;
end

% Fonction codée avant la découverte de l'existence de reshape. Ne sert
% plus à rien, mais on se sentait trop bêtes après l'avoir découverte donc
% on l'a gardée dans H(7,4).

function [decoupe] = decoupage(octets) %les bits supp sont supposés appartenant à la chaine d'après
    l = length(octets);
    j = 1;
    decoupe = [];
    for i = 1:(floor(l/4))
        decoupe = [decoupe ; [octets(j) octets(j+1) octets(j+2) octets(j+3)]];
        j = j + 4;
    end
end


% Fonction intervenant dans codageCanal servant à coder les bits d'entrée
%
% Entrées : bits => matrice ligne contenant les bits à coder. Sera remis en
%           forme via reshape puis remis sous format ligne 
%           G => matrice génératrice
%
% Sorties : code => matrice ligne contenant bits codé via la génératrice G


function [code] = codage(bits, G)
    decoupe = decoupage(bits);
    taille = floor(length(bits)/4);
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




