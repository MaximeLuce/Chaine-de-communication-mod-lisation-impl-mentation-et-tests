close all; clear all;
format long;

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
m='coucou';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m)

%% CODAGE DE SOURCE

% on recupere le traitement issu de python
[symbols, probs] = traitementAnalyseFreq('fichier.txt');
    
symbols = string(symbols);
probs = probs';

% Intervalles cumulés
cum_probs = [0 cumsum(probs)]; % longueur K+1

% on code le message en arithmetique
MessageEncode = codageArithmetique(messageFiltre, symbols, probs, cum_probs);

disp("Message codé");
disp(MessageEncode);


%% CODAGE DE CANAL

disp("Message en sortie du codage canal");
[MessageCodeCanal, doublon] = codageCanal(MessageEncode);
disp(MessageCodeCanal)

size(MessageCodeCanal)
%% MODULATION + Ajout du bruit
% DEBIT + bande passante + puissance de x (fixée)
%y = modulationQPSK(MessageCodeCanal)

%size(y)

%% DEMODULATION

%Y = demodulationQPSK(y)

%% CANAL D'INFORMATION - CBS

% calcul de l'erreur du CBS
Pe_m=1/(2*N0)^(1/2); 
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0;

C_CBS = 1 - H2(Pe); % calcul de la capacité du canal d'information

MessageY = applicationCBS(MessageCodeCanal, Pe);
%T2 = table(mC, MessageY)<

%% DECODAGE CANAL
% on l'applique à Y (qui provient de la mod/demod) ou à MessageY (qui
% provient du CBS)
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanal(MessageY, doublon);
disp(MessageDecodeCanal')


%% DECODAGE DE SOURCE

% on decode en ASCII
MessageDecode = decodageArithmetique(MessageDecodeCanal, symbols, probs, cum_probs)
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)

%mC, mDecode = huffmanUniversel(MessageYSeq, lettres, valeurs);

%table(m,mDecode)