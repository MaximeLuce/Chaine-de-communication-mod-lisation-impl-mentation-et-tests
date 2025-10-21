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
m='hello ca va';

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m)

%% CODAGE DE SOURCE

% on code le message en ASCII
MessageEncode = codageASCII(messageFiltre);

disp("Message codé");

%% DECODAGE DE SOURCE

% on decode en ASCII
MessageDecode = decodageASCII(MessageEncode);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)
