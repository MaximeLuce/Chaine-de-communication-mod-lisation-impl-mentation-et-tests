close all; clear all;

% on ajoute les dossiers au répertoire
addpath config\;
addpath utilitaires\;

addpath codSource\;

addpath codCanal\;

addpath CBS\;

addpath modulation\;
% addpath BABG\;
% addpath demodulation\;

parametres; % on importe les paramètres de parametres.m

%% SOURCE PRINCIPALE
m='coucou c est moi tu vas bien ';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m);





%% CODAGE DE SOURCE

% on recupere le traitement issu de python
[lettres, valeurs] = traitementAnalyseFreq('fichier.txt');

% Affichage sous forme de table
%T = table(lettres, valeurs)

% on code avec Huffman
[MessageEncode, dictionnaire, probas] = huffmanUniverselCod(messageFiltre, lettres, valeurs);
disp("Message codé");

%% CODAGE DE CANAL

disp("Message en sortie du codage canal");
[MessageCodeCanal, doublon] = codageCanalH_7_2(MessageEncode);

%% MODULATION + Ajout du bruit
% DEBIT + bande passante + puissance de x (fixée)
y = modulationQPSK(MessageCodeCanal);

%size(y)

%% DEMODULATION

Y = demodulationQPSK(y);

%% CANAL D'INFORMATION - CBS

Pe_m=1/(2*N0)^(1/2); % calcul de l'erreur du CBS
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0.14;

C_CBS = 1 - H2(Pe); % calcul de la capacité du canal d'information

MessageY = applicationCBS(MessageCodeCanal, Pe);
%T2 = table(mC, MessageY)<

%% DECODAGE CANAL
% on l'applique à Y (qui provient de la mod/demod) ou à MessageY (qui
% provient du CBS)
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanalH_7_2(MessageY, doublon);


%% DECODAGE DE SOURCE

%messageStr = num2str(MessageY)     % transforme les nombres en texte séparé par des espaces

%messageStr(messageStr == ' ') = ''   % enlève les espaces

%dictionnaire = huffmandict(lettres, valeurs);

%decodedCell = huffmandeco(messageStr, dictionnaire)

[MessageDecode, dictionnaire, probas] = huffmanUniverselDecod(MessageDecodeCanal, lettres, valeurs);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)

%mC, mDecode = huffmanUniversel(MessageYSeq, lettres, valeurs);

%table(m,mDecode)