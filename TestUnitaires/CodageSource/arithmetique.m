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
[MessageEncode, L] = codageArithmetique(messageFiltre, symbols, probs, cum_probs);

disp("Message codé");

%% DECODAGE DE SOURCE
MessageDecode = decodageArithmetique(MessageEncode, symbols, probs, cum_probs, L);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)
