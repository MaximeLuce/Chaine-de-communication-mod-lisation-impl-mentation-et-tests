
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


function [decoupe] = decoupage(octets) %les bits supp sont supposés appartenant à la chaine d'après
    l = length(octets);
    j = 1;
    decoupe = [];
    for i = 1:(floor(l/4))
        decoupe = [decoupe ; [octets(j) octets(j+1) octets(j+2) octets(j+3)]];
        j = j + 4;
    end
end


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

function [messageDecode] = decodageCanal(messageCode, doublon)


    messageDecode = [];
    H = [1 0 1 0 1 0 1; 0 1 1 0 0 1 1; 0 0 0 1 1 1 1];
    G = [1 1 1 0 0 0 0; 1 0 0 1 1 0 0; 0 1 0 1 0 1 0; 1 1 0 1 0 0 1];

    % découper messageCode en bloc de 7
    n = length(messageCode);
    r = mod(n,7);
    nbBlocs = (n-r)/7;

    for i=1:nbBlocs
        debut = (i-1)*7 + 1;
        fin = min(i*7, n);
        message = messageCode(debut:fin);

        % on complète par des 0 si c'est pas un multiple de 7
        if length(message) < 7
            message = [message, zeros(1, 7 - length(message))];
        end
        
        % correction du message sélectionné
        syndrome = mod(message * H',2);
        syndrome = flip(syndrome);
        
        dec_val = binaryVectorToDecimal(syndrome);
        corrige = message;
        if not(dec_val==0)
            if corrige(dec_val)==1
                corrige(dec_val)=0;
            else
                corrige(dec_val)=1;
            end
        end
        % on décode le message corrigé
        % on retir les 0 ajoutés artificiellements
        %messageCode = messageCode(1,1:end-doublon);
        if i == nbBlocs
            if doublon == 1
                u = [corrige(3); corrige(5); corrige(6)];
            else
                u = [corrige(3); corrige(5); corrige(6); corrige(7)];
            end
        else
            u = [corrige(3); corrige(5); corrige(6); corrige(7)];
        end
        % on ajoute le mot au messageDecode
        messageDecode = [messageDecode ; u];
    end
    messageDecode = messageDecode'
end

msg = [0 1 0 1 0 1 0 1]
[rho_cc,msg_code,doublon] = codageCanalH_7_4(msg);
msg_code
msg_recu = decodageCanal(msg_code,doublon)