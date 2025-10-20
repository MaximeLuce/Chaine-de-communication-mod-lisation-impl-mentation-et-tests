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
m=['Bonjour adrien coucou'];

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m);
disp(messageFiltre);

% on recupere le traitement issu de python
[lettres, valeurs] = traitementAnalyseFreq('fichier.txt');

% Affichage sous forme de table
%T = table(lettres, valeurs)

% On calcule l'entropie et le débit de la source
H_S = entropieTexte(messageFiltre);
disp('H(S) = H(P_S) =');
disp(H_S);

D_S = calculDS(messageFiltre);
disp('D(S) =');
disp(D_S);

Ht_S = H_S * D_S;
disp('Débit d information Ht(S) = ');
disp(Ht_S);

%% CODAGE DE SOURCE

% on code avec Huffman
[MessageEncode, dictionnaire, probas] = huffmanUniverselCod(messageFiltre, lettres, valeurs);
disp("Message codé");


% On calcule l'entropie et le débit de la source
%L = longueurMoyenne(fromDicoToListL_k(dictionnaire), probas) % symb/mot code

l_k = fromDicoToListL_k(dictionnaire);
L = longueurMoyenne(l_k, probas)

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
% disp('H(P_S) =');
% disp(CalculHP(probas));
% 
% disp('H(U):');
% H_U = CalculHP(probas);
% disp(H_U);
% 
% disp('Rendement:');
% K = length(probas);
% eta = H_S/log2(K);
% disp(eta);
% 
% disp('Débit:')
% Q = 2; % c'est bu binaire
% L_min = H_S/log2(Q);
% D_min_U = L_min * D_S;
% disp(D_min_U)


%% CODAGE DE CANAL

disp("Message en sortie du codage canal");
[MessageCodeCanal, doublon] = codageCanalH_7_2(MessageEncode);

% On calcule l'entropie et le débit de la source
rho_cc = 2/29; % car H(7,4)

H_X = rho_cc * H_U;
disp('H(X) =');
disp(H_X);

D_X = 1/rho_cc*D_U;
disp('D(X) =');
disp(D_X);

%% MODULATION + Ajout du bruit
% DEBIT + bande passante + puissance de x (fixée)
disp('Modulation et ajout du bruit BABG')


nus = 10000;    % frequence d'echantillonnage (Hz)
fp = 100;      % frequence porteuse (Hz)
Db = 200;      % débit binaire (baud=1/sec)
B=100; % bande passante
A = 1;         % amplitude du signal
Ts=1/nus;

% QPSK
alpha = 0.25;
%[x, Ntot, z, t, u_shaped, delay] = modulationQPSK_soft_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);
%[x,Ntot, y] = modulationQPSK_soft(MessageCodeCanal,nus, fp, Db, A);

% BPSK
%[x, Ntot, y] = modulationBPSK(MessageCodeCanal, nus, fp, Db, A);
[x, Ntot, y] = modulationBPSK_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);

t = (0:Ntot-1)*Ts;

figure,
plot([-Ntot/2:Ntot/2-1]/Ntot*nus,abs(fftshift(fft(x))));
xlabel('frequence nu');
ylabel('module');
title('spectre X(nu) du signal émis');

epaisseur_ligne = 2;
xline(fp - B/2, '-m', 'LineWidth', epaisseur_ligne);
xline(fp + B/2, '-m', 'LineWidth', epaisseur_ligne);

xline(-fp - B/2, '-m', 'LineWidth', epaisseur_ligne);
xline(-fp + B/2, '-m', 'LineWidth', epaisseur_ligne);

yline(10^(-3),'-r', 'LineWidth', epaisseur_ligne);

%y = modulationQPSK(MessageCodeCanal);

% calcul de la capacité
C = log2(exp(1))/2*log2(1 + Pmax/N0);
disp('C =');
disp(C)

M = 4; % modulation 4-aire
Db=200;
n=2;
B = Db/n; % avec M=2^n
D_C = B*log2(M);
disp('D_C =');
disp(D_C);


%size(y)

%% DEMODULATION

disp('Démodulation')

% QPSK
%[Y, ux_hat, t_rx, y_bb] = demodulationQPSK_soft_RRC(z, nus, fp, Db, A, alpha);
%Y = demodulationQPSK_soft(y,nus, fp, Db, A);
%Y = demodulationQPSK(y,nus, fp, Db, A);

% BPSK
%Y = demodulationBPSK(y,nus, fp, Db, A);
Y = demodulationBPSK_RRC(y,nus, fp, Db, A, alpha);

% Vérification
nb_errors = sum(MessageCodeCanal ~= Y);
fprintf("Nombre d'erreurs : %d / %d bits (%.3f%%)\n", nb_errors, numel(MessageCodeCanal), 100*nb_errors/numel(MessageCodeCanal));

%% CANAL D'INFORMATION - CBS

Pe_m=1/(2*N0)^(1/2); % calcul de l'erreur du CBS
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0.16;

% calcul de la capacité
C_CBS = 1 - H2(Pe); % calcul de la capacité du canal d'information

% pas de notion de "debit" pour le CBS

MessageY = applicationCBS(MessageCodeCanal, Pe);
%T2 = table(mC, MessageY)<

%% DECODAGE CANAL
% on l'applique à Y (qui provient de la mod/demod) ou à MessageY (qui
% provient du CBS)
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanalH_7_2(Y, doublon);


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