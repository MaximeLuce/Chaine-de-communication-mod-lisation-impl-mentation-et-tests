%% DECODAGE DU CANAL H(5,4)

% Fonction decodageCanal ramenant l'élément reçu et corrigeant via le 
% syndrome calculé (syndrome valant, en binaire, la position de l'erreur).
%
% Entrées : messageCode => matrice ligne contenant le message reçu en 
%           sortie de canal, renforcé
%           doublon => valeur valant 1 si la longueur du message envoyé est
%           impaire
%
% Sorties : messageDecode => élément le plus proche de la liste l_possibles

function [messageDecode] = decodageCanalH_5_4bis(messageCode, doublon)


    messageDecode = [];
    H = [1 1 1 1 1];    
    G = [1 0 0 0 1;
         0 1 0 0 1;
         0 0 1 0 1;
         0 0 0 1 1];         % Matrice génératrice

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
end