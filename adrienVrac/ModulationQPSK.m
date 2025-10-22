
% parametres
%---------------------------------------------------------------------------%

nus = 1000;    % frequence d'echantillonnage (Hz)
fp = 200;      % frequence porteuse (Hz)
Db = 200;      % débit binaire (baud=1/sec)
A = 1;         % amplitude du signal

Ts = 1/nus;    % periode d'echantillonnage (sec)
iim = sqrt(-1);


% creation du message binaire à transmettre
%---------------------------------------------------------------------------%
imageaff = 1;
if(imageaff)
    filename = 'pikachu.jpg';
    [img] = imread(filename);
    figure, image(img);
    title('image émise');
    m = ImageToMessage(img);
    Nbit = length(m);   % nombre de bit à transmettre
else
    Nbit = 100;   % nombre de bit à transmettre (multiple de 2 pour une modulation QPSK)
    m = randi([0 1],1,Nbit);
    figure,
    plot(m);
    ylim([-0.5 1.5]);
    title('message binaire initial');
end


% modulation QPSK
%---------------------------------------------------------------------------%

% creation de la sequence de symboles à transmettre (QPSK : 1 symbole = 2 bits)
Nsymb = Nbit/2; % nombre de symboles dans le message
msymbole = reshape(m,2,Nsymb); % sequence de symbole (matrice 2*Nsymb)

% creation de l'enveloppe complexe ux(t) du signal : modulation de phase
nphase = bin2dec(num2str(msymbole'))'; % transposition de {00,01,10,11} vers {0,1,2,3}
ux = A*exp(iim*2*pi*nphase/4+iim*pi/4);

% Mise en forme du signal ux(t) : échantillonnage et débit symbole
Ds = Db/2;              % debit symbole (1/sec)
nrepet = floor(nus/Ds); % facteur de repetition
uxnus = reshape(ones(nrepet,1)*ux,1,Nsymb*nrepet); % chaque symbole est répété 'nrepet' fois

% creation du signal réel x(t) à émettre : modulation IQ
N = length(uxnus);
t = [0:N-1]*Ts;
x = real(uxnus).*cos(2*pi*fp*t)-imag(uxnus).*sin(2*pi*fp*t);

figure,
subplot(211),plot(t,real(uxnus),'b');
ylim([-1 1]*2*A);
xlabel('temps t');
ylabel('amplitude');
title('enveloppe complexe du signal émis - composantes p et q');
subplot(212),plot(t,imag(uxnus),'b');
ylim([-1 1]*2*A);
xlabel('temps t');
ylabel('amplitude');
figure,
plot(ux,'*');
xlim([-1 1]*2*A);
ylim([-1 1]*2*A);
grid on;
xlabel('Re(ux)');
ylabel('Im(ux)');
title('constellation à l''émission');
figure,
plot(t,x,'b');
ylim([-1 1]*2*A);
xlabel('temps t');
ylabel('amplitude');
title('signal émis x(t)');
figure,
plot([-N/2:N/2-1]/N*nus,abs(fftshift(fft(x))));
xlabel('frequence nu');
ylabel('module');
title('spectre X(nu) du signal émis');

% propagation
%---------------------------------------------------------------------------%


function [d] = distance(x1, y1, x2, y2)
    d = (x1 - x2)^2 + (y1 - y2)^2;
end

function [min] = decision(x1,y1)
    L = [distance(x1, y1, 0.7071, 0.7071), distance(x1,y1, -0.7071, 0.7071), distance(x1,y1, -0.7071, -0.7071), distance(x1,y1, 0.7071, -0.7071)];
    min = 0;
    for n=[0,1,2,3]
        if (L(min+1)>L(n+1))
            min = n;
        end
    end
end

function [teb] = teb(m,mprime)
    n = length(m);
    compte = 0;
    for i=1:n
        if not(m(i) == mprime(i))
            compte = compte + 1;
        end
    end
    teb = compte/n;
end

l_teb = zeros(50,1);
for value=1:50
    sigma2 = value/50;
    z = x+sqrt(sigma2)*randn(1,N);

    uznus = hilbert(z).*exp(-iim*2*pi*fp*t);
    uz = uznus(nrepet/2:nrepet:end);
    
    n = length(uz);
    nphaseprime = zeros(n,1);
    for i=[0:(n-1)]
        nphaseprime(i+1) = decision(real(uz(i+1)),imag(uz(i+1)));
    end
    mprime = str2num(reshape(dec2bin(nphaseprime)',2*Nsymb,1));
    l_teb(value) = teb(m,mprime);
end

figure,
plot((1:50)/50,l_teb);
ylim([-1 1]*2*A);
xlabel('TEB');
ylabel('sigma');

if(imageaff)
    [N,M,d] = size(img);
    [imgprime] = MessageToImage(mprime,N,M,d);
    figure,
    image(imgprime);
    title('image reçu');
else
    figure,
    plot(mprime);
    ylim([-0.5 1.5]);
    title('message binaire reçu');
end