clear all; close all;

Ntest = 1000;
resultat = zeros(Ntest,1);
for i = 1:Ntest
    MessageCodeCanal = randi([0 1], 1, 1000);
    pourcentage = testQPSK(MessageCodeCanal);
    resultat(i)=pourcentage;
end
moyenne_pourcentage = sum(resultat)/Ntest

function [pourcentage] = testQPSK(MessageCodeCanal)
    nus = 10000;    % frequence d'echantillonnage (Hz)
    fp = 100;      % frequence porteuse (Hz)
    Db = 200;      % débit binaire (baud=1/sec)
    B=100; % bande passante
    A = 1;         % amplitude du signal
    Ts=1/nus;
    
    alpha = 0.35; % pour le RCC
    rolloff = 0.35; span = 6; % pour le RCOS
    % MODULATION
    %[x, Ntot, y] = modulationBPSK(MessageCodeCanal, nus, fp, Db, A);

    %[x, Ntot, y, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RCOS(MessageCodeCanal, nus, fp, Db, A, rolloff);
    %[x, Ntot, y] = modulationBPSK_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);
    
    %[x, Ntot, y, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_FGaussien2(MessageCodeCanal, nus, fp, Db, A);
    
    [x, Ntot, y, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RRC(MessageCodeCanal, nus, fp, Db, A, rolloff, span);
    
        
    % DEMODULATION
    
    % BPSK
    %[uz_nus, Y] = demodulationBPSK(y,nus, fp, Db, A);
    
    %[Y, uz_nus, nrepet] = demodulationBPSK_RCOS(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);
    
    %[Y, uz_nus, nrepet_out] = demodulationBPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded);
    
    [Y, uz_nus, nrepet_out] = demodulationBPSK_RRC(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);
        
    % Vérification
    erreur = sum(MessageCodeCanal ~= Y);
    pourcentage = 100*erreur/numel(MessageCodeCanal);
    
end


MessageCodeCanal = randi([0 1], 1, 1000);

nus = 10000;    % frequence d'echantillonnage (Hz)
fp = 100;      % frequence porteuse (Hz)
Db = 800;      % débit binaire (baud=1/sec)
B=100; % bande passante
A = 1;         % amplitude du signal
Ts=1/nus;

alpha = 0.35; % pour le RCC
rolloff = 0.35; span = 6; % pour le RCOS

%% MODULATION
%[x, Ntot, y] = modulationBPSK(MessageCodeCanal, nus, fp, Db, A);

%[x, Ntot, y, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RCOS(MessageCodeCanal, nus, fp, Db, A, rolloff);
%[x, Ntot, y] = modulationBPSK_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);

[x, Ntot, y, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_FGaussien2(MessageCodeCanal, nus, fp, Db, A);

%[x, Ntot, y, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationBPSK_RRC(MessageCodeCanal, nus, fp, Db, A, rolloff, span);


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

%% DEMODULATION

disp('Démodulation')
% BPSK
%[uz_nus, Y] = demodulationBPSK(y,nus, fp, Db, A);

%[Y, uz_nus, nrepet] = demodulationBPSK_RCOS(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);

[Y, uz_nus, nrepet_out] = demodulationBPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded);

%[Y, uz_nus, nrepet_out] = demodulationBPSK_RRC(y, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);
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