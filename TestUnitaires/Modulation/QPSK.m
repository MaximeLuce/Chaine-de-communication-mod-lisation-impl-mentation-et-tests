

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
    
    alpha = 0.5; % pour le RCC
    rolloff = 0.35; span = 6; % pour le RCOS
    % MODULATION
    % QPSK
    
    %[x,Ntot, y] = modulationQPSK(MessageCodeCanal,nus, fp, Db, A);
    %[x,Ntot, y] = modulationQPSK_soft(MessageCodeCanal,nus, fp, Db, A);
    %[x,Ntot, y, h] = modulationQPSK_Fcos(MessageCodeCanal,nus, fp, Db, A);
    %[x, Ntot, y, g, nrepet, Nsymb_out, group_delay] = modulationQPSK_FGaussien(MessageCodeCanal,nus, fp, Db, A);
    %[x, Ntot, y, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_FGaussien2(MessageCodeCanal, nus, fp, Db, A);
    
    %[x, Ntot, z, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_RCOS(MessageCodeCanal, nus, fp, Db, A, rolloff);
    
    [x, Ntot, y, t, u_shaped, delay] = modulationQPSK_soft_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);
   
    
    % DEMODULATION
    
    % QPSK
    %[Y, uznus] = demodulationQPSK(y,nus, fp, Db, A);
    %[Y, uz_nus] = demodulationQPSK_soft(y,nus, fp, Db, A);
    %[Y, uz_nus] = demodulationQPSK_Fcos(y,nus, fp, Db, A, h);
    %[Y, uz_nus, nrep_ret] = demodulationQPSK_FGaussien(y, nus, fp, Db, A, g, Nsymb_out, nrepet, group_delay);
    %[Y, uz_nus, nrepet_out] = demodulationQPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded);
    
    %[Y, uz_nus, nrepet] = demodulationQPSK_RCOS(z, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);
    
    [Y, ux_hat, t_rx, y_bb, uz_nus] = demodulationQPSK_soft_RRC(y, nus, fp, Db, A, alpha, numel(MessageCodeCanal));
    
    
    % Vérification
    erreur = sum(MessageCodeCanal ~= Y);
    pourcentage = 100*erreur/numel(MessageCodeCanal);
    
end
%%
nus = 10000;    % frequence d'echantillonnage (Hz)
fp = 100;      % frequence porteuse (Hz)
Db = 800;      % débit binaire (baud=1/sec)
B=100; % bande passante
A = 1;         % amplitude du signal
Ts=1/nus;

alpha = 0.5; % pour le RCC
rolloff = 0.35; span = 6; % pour le RCOS
MessageCodeCanal = randi([0 1], 1, 1000);
%% MODULATION
% QPSK

%[x,Ntot, y] = modulationQPSK(MessageCodeCanal,nus, fp, Db, A);
%[x,Ntot, y] = modulationQPSK_soft(MessageCodeCanal,nus, fp, Db, A);
%[x,Ntot, y, h] = modulationQPSK_Fcos(MessageCodeCanal,nus, fp, Db, A);
%[x, Ntot, y, g, nrepet, Nsymb_out, group_delay] = modulationQPSK_FGaussien(MessageCodeCanal,nus, fp, Db, A);
%[x, Ntot, y, g, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_FGaussien2(MessageCodeCanal, nus, fp, Db, A);

%[x, Ntot, z, b, nrepet, Nsymb, group_delay, orig_len, padded] = modulationQPSK_RCOS(MessageCodeCanal, nus, fp, Db, A, rolloff);

[x, Ntot, y, t, u_shaped, delay] = modulationQPSK_soft_RRC(MessageCodeCanal, nus, fp, Db, A, alpha);


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
% QPSK
%[Y, uznus] = demodulationQPSK(y,nus, fp, Db, A);
%[Y, uz_nus] = demodulationQPSK_soft(y,nus, fp, Db, A);
%[Y, uz_nus] = demodulationQPSK_Fcos(y,nus, fp, Db, A, h);
%[Y, uz_nus, nrep_ret] = demodulationQPSK_FGaussien(y, nus, fp, Db, A, g, Nsymb_out, nrepet, group_delay);
%[Y, uz_nus, nrepet_out] = demodulationQPSK_FGaussien2(y, nus, fp, Db, A, g, Nsymb, nrepet, group_delay, orig_len, padded);

%[Y, uz_nus, nrepet] = demodulationQPSK_RCOS(z, nus, fp, Db, A, b, Nsymb, nrepet, group_delay, orig_len, padded);

[Y, uz_nus, t_rx, y_bb, uz_nus] = demodulationQPSK_soft_RRC(y, nus, fp, Db, A, alpha, numel(MessageCodeCanal));


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