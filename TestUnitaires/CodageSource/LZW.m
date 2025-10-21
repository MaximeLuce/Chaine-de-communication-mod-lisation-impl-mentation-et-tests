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
m='coucou adrien tu vas bien';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m)

%% CODAGE DE SOURCE

% on code le message en arithmetique
MessageEncode = codageLZW(messageFiltre);

disp("Message codé");


%% DECODAGE DE SOURCE

MessageDecode = decodageLZW(MessageEncode);
disp("Message décodé :")
disp(MessageDecode)
