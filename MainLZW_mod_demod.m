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
m='Tu veux venir !';

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
disp(MessageEncode);


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
[rho_cc,MessageCodeCanal, doublon] = codageCanalH_29_2(MessageEncode);

H_X = rho_cc * H_U;
disp('H(X) =');
disp(H_X);

D_X = 1/rho_cc*D_U;
disp('D(X) =');
disp(D_X);
%% MODULATION + Ajout du bruit
% DEBIT + bande passante + puissance de x (fixée)
%y = modulationQPSK(MessageCodeCanal)
nus = 10000;    % frequence d'echantillonnage (Hz)
fp = 100;      % frequence porteuse (Hz)
Db = 200;      % débit binaire (baud=1/sec)
B=100; % bande passante
A = 1;         % amplitude du signal
Ts=1/nus;

[x, Ntot, y, g, nrepet, Nsymb_out, group_delay] = modulationQPSK_FGaussien(MessageCodeCanal,nus, fp, Db, A);


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

%size(y)

%% DEMODULATION

[Y, uz_nus, nrep_ret] = demodulationQPSK_FGaussien(y, nus, fp, Db, A, g, Nsymb_out, nrepet, group_delay);

% Vérification
nb_errors = sum(MessageCodeCanal ~= Y);
fprintf("Nombre d'erreurs du à la mod/demod : %d / %d bits (%.3f%%)\n", nb_errors, numel(MessageCodeCanal), 100*nb_errors/numel(MessageCodeCanal));

nrepet=round(nus /(Db/2));
uz = uz_nus(nrepet/2:nrepet:end);

% Points normalisés
%pts = [ 0.7071+0.7071i,  -0.7071+0.7071i,  -0.7071-0.7071i,  0.7071-0.7071i ];%QPSK
pts = [-1+0i, +1+0i];% BPSK
figure,
plot(uz,'*b');hold on;
plot(pts, '*r');
xlim([-1 1]*2*A);
ylim([-1 1]*2*A);
grid on;
xlabel('Re(uz)');
xlabel('Im(uz)');
title('constellation à la réception');
%Y = demodulationQPSK(y)

%% CANAL D'INFORMATION - CBS

% calcul de l'erreur du CBS
Pe_m=1/(2*N0)^(1/2); 
%Pe = 2*erfc(1/(2*N0)^(1/2));
Pe = 0.14;

C_CBS = 1 - H2(Pe) % calcul de la capacité du canal d'information
B=100;
M=4;
D_c = B*log2(M)
MessageY = applicationCBS(MessageCodeCanal, Pe);

%% DECODAGE CANAL
% on l'applique à Y (qui provient de la mod/demod) ou à MessageY (qui
% provient du CBS)
disp("Message en sortie du décodage canal")
MessageDecodeCanal = decodageCanalH_29_2(Y, doublon);


%% DECODAGE DE SOURCE<

MessageDecode = decodageLZW(MessageDecodeCanal);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)

%mC, mDecode = huffmanUniversel(MessageYSeq, lettres, valeurs);

%table(m,mDecode)