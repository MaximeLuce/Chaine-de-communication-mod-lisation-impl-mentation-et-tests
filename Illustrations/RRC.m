%% Paramètres généraux
M = 4;                 
k = log2(M);           
numSymbols = 1000;     
nrepet = 8;            
alpha = 0.35;          
span = 6;              

%% Génération de bits aléatoires
bits = randi([0 1], numSymbols*k, 1);

%% Mapping QPSK
symboles = bi2de(reshape(bits, k, []).','left-msb');
qpskMod = exp(1j*(pi/4 + pi/2*symboles)) / sqrt(2); 

%% --- Pulse rectangulaire (repetition) ---
u_ups = repelem(qpskMod, nrepet);  % forme rectangulaire

%% --- Filtre racine de cosinus surélevé (RRC) ---
rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
sig_rrc = conv(u_ups, rrcFilter, 'same');

%% --- Filtre Gaussien ---
spanSymbols = 6;                 
L = spanSymbols * nrepet + 1;    
center = (L + 1)/2;
sigma = (spanSymbols * nrepet)/6;
n = 1:L;
g = exp(-0.5*((n-center)/sigma).^2);
g = g / sqrt(sum(g.^2));          
sig_gauss = conv(u_ups, g, 'same');

%% --- Filtre Cos² ---
t_pulse = linspace(-pi/2, pi/2, nrepet);
hcos2 = (cos(t_pulse)).^2;       
hcos2 = hcos2 / sqrt(sum(hcos2.^2)); 
sig_cos2 = conv(u_ups, hcos2, 'same');

%% --- Filtre Raised Cosine classique ---
rcFilter = rcosdesign(alpha, span, nrepet, 'normal'); 
sig_rc = conv(u_ups, rcFilter, 'same');

%% --- Visualisation ---
numSamplesPlot = 100; 
figure;

subplot(5,1,1);
plot(real(u_ups(1:numSamplesPlot)), 'k-o');
title('Rectangle');
xlabel('Échantillon'); ylabel('Amplitude');
grid on;




subplot(5,1,2);
plot(real(sig_cos2(1:numSamplesPlot)), 'g-o');
title('Filtre Cos²');
xlabel('Échantillon'); ylabel('Amplitude');
grid on;

subplot(5,1,4);
plot(real(sig_rc(1:numSamplesPlot)), 'm-o');
title('Filtre RCOS');
xlabel('Échantillon'); ylabel('Amplitude');
grid on;

subplot(5,1,3);
plot(real(sig_gauss(1:numSamplesPlot)), 'b-o');
title('Filtre Gaussien');
xlabel('Échantillon'); ylabel('Amplitude');
grid on;

subplot(5,1,5);
plot(real(sig_rrc(1:numSamplesPlot)), 'r-o');
title('Filtre RRC');
xlabel('Échantillon'); ylabel('Amplitude');
grid on;


sgtitle('Effet des différents filtres sur un signal');
