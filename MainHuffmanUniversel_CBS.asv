close all;clear all;

parametres; % on importe les paramètres de parametres.m
%utilitaires; %


%% SOURCE PRINCIPALE
m='h';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m)

%% CODAGE DE SOURCE
% on recupere le traitement issu de python

fid = fopen('fichier.txt', 'r');
data = textscan(fid, '%s %f', 'Delimiter', ';');
fclose(fid);

lettres = data{1};
valeurs = data{2};

valeurs(1) = 1-sum(valeurs(2:end))

% Affichage sous forme de table
T = table(lettres, valeurs)
%disp(T);

%M = [lettres valeurs]

mC = huffmanUniversel(messageFiltre, lettres, valeurs)

% %% CODAGE DE CANAL 
% function code = Hamming(messageCode, n, k)
% % Hamming - Encode un message avec un code de Hamming (n, k)
% %
% % Syntaxe :
% %    code = Hamming(messageCode, n, k)
% %
% % Entrées :
% %    messageCode : vecteur binaire du message (1 x k)
% %    n           : longueur du mot codé (nombre total de bits)
% %    k           : nombre de bits d'information
% %
% % Sortie :
% %    code        : vecteur binaire du mot codé (1 x n)
% %
% % Exemple :
% %    code = Hamming([1 0 1 1], 7, 4)
% 
%     % Vérification des dimensions
%     if length(messageCode) ~= k
%         error('La longueur du message doit être égale à k.');
%     end
% 
%     % Calcul du nombre de bits de parité
%     r = n - k;
% 
%     % Vérification que (n,k) correspond à un code de Hamming valide
%     if n ~= 2^r - 1
%         error('Les valeurs de n et k ne correspondent pas à un code de Hamming valide (n = 2^r - 1, k = n - r).');
%     end
% 
%     % Construction de la matrice de parité A (ou P)
%     % Pour un code de Hamming, chaque colonne de H est le binaire de 1:n
%     H = de2bi(1:n, r, 'left-msb')';
%     A = H(:, 1:k)';  % Sous-matrice utilisée pour G
% 
%     % Générateur G = [I_k | A]
%     G = [eye(k) A];
% 
%     % Encodage : code = msg * G (mod 2)
%     code = mod(messageCode * G, 2);
% 
% end
% 
% code = Hamming(mC, 7, 4)

%% CANAL D'INFORMATION

Pe=1/(2*N0)^(1/2) % calcul de l'erreur du CBS

function [r] = H2(p)
    r = p*log(p)+(1-p)*log(1-p);
end

C_CBS = 1 - H2(Pe) % calcul de la capacité du canal d'information

function [Y] = applicationCBS(X,p)
    n = length(X);
    Y = zeros(n,1);
    % I love u :)
    %n = 10; % However many numbers you want.
    for i=1:n
        randomNumbers = randi([0, 1], 1);
        if randomNumbers <= p % alors on a une erreur
            if X(i) == 1
                Y(i) = 0;
            end
            if X(i) == 0
                Y(i) = 1;
            end
        end
        if randomNumbers > p
            Y(i) = X(i);
        end
    end
    
end

MessageY = applicationCBS(mC, Pe);
T2 = table(mC, MessageY)

%% DECODAGE DE SOURCE

messageStr = num2str(MessageY') ;     % transforme les nombres en texte séparé par des espaces
messageStr(messageStr == ' ') = '';   % enlève les espaces

[MessageEncode, MessageDecode, dictionnaire, probas] = huffmanUniversel(messageStr, lettres, valeurs)

%mC, mDecode = huffmanUniversel(MessageYSeq, lettres, valeurs);

%table(m,mDecode)