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
m='Ceci est un test ?!';

disp('Message :');
disp(m);

% On calcule l'entropie et le débit de la source
H_S = entropieTexte(m);
disp('H(S) = H(P_S) =');
disp(H_S);

D_S = calculDS(m);
disp('D(S) =');
disp(D_S);

Ht_S = H_S * D_S;
disp('Débit d information Ht(S) = ');
disp(Ht_S);
%% CODAGE DE SOURCE

% on code le message en LZW
MessageEncode = codageLZW(m);

disp("Message codé");


L = 8

L_min = H_S/log2(2)

%L = longueurMoyenneEmpirique(messageFiltre, dictionnaire, probas);
%L = 3.75; % cas pour message ="test"

eta = L_min/L

H_U = H_S/L;
disp('H(U) =');
disp(H_U);

D_U = L*D_S;
disp('D(U) =');
disp(D_U);

Ht_U = H_U * D_U;
disp('Débit d information Ht(U) = ');
disp(Ht_U);

%% CODAGE DE CANAL

disp("Message en sortie du codage canal");
[rho_cc,MessageCodeCanal, doublon] = codageCanalH_15_2(MessageEncode);

% Modifier les valeurs 15 et 2 selon le traitement souhaité. Attention à
% modifier également dans decodageCanal.

%% CANAL D'INFORMATION - CBS

% calcul de l'erreur du CBS
% Pe_m=1/(2*N0)^(1/2); 
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0.14; % Probabilité d'erreur

C_CBS = 1 - H2(Pe) % calcul de la capacité du canal d'information
B=100;
M=4;

D_C = B*log2(M)
MessageY = applicationCBS(MessageCodeCanal, Pe);

%% DECODAGE CANAL
% on l'applique à Y (qui provient de la mod/demod) ou à MessageY (qui
% provient du CBS)
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanalH_15_2(MessageY, doublon);


%% DECODAGE DE SOURCE<

MessageDecode = decodageLZW(MessageDecodeCanal);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)

%mC, mDecode = huffmanUniversel(MessageYSeq, lettres, valeurs);

%table(m,mDecode)