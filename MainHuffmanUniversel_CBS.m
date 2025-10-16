close all; clear all;

% on ajoute les dossiers au répertoire
addpath config\;
addpath utilitaires\;

addpath codSource\;

addpath codCanal\;

addpath CBS\;

addpath modulation\;
addpath BABG\;
addpath demodulation\;

parametres; % on importe les paramètres de parametres.m

%% SOURCE PRINCIPALE
m='Coucou';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m)

%% CODAGE DE SOURCE

% on recupere le traitement issu de python
[lettres, valeurs] = traitementAnalyseFreq('fichier.txt');

% Affichage sous forme de table
%T = table(lettres, valeurs)

% on code avec Huffman
[MessageEncode, dictionnaire, probas] = huffmanUniverselCod(messageFiltre, lettres, valeurs);
disp("Message codé");
disp(MessageEncode');

%% CODAGE DE CANAL

disp("Message en sortie du codage canal");
[MessageCodeCanal, doublon] = codageCanal(MessageEncode);
disp(MessageCodeCanal)
%% MODULATION

%% PERTURBATION : BABG


%% DEMODULATION


%% CANAL D'INFORMATION - CBS

Pe_m=1/(2*N0)^(1/2); % calcul de l'erreur du CBS
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0;

C_CBS = 1 - H2(Pe); % calcul de la capacité du canal d'information

MessageY = applicationCBS(MessageCodeCanal, Pe);
%T2 = table(mC, MessageY)

%% DECODAGE CANAL
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanal(MessageY, doublon);
disp(MessageDecodeCanal')


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