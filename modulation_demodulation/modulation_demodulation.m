m = [1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1]


nus = 1000;   % Hz
fp = 200;    % Hz
Db = 200;    % bits/s
A = 1;

Ts = 1/nus;
iim = 1i;

% Mapping QPSK (2 bits/symbole)
Nsymb = numel(m)/2;
msymbole = reshape(m,2,Nsymb);
nphase = bin2dec(num2str(msymbole'))';% 00->0, 01->1, 10->2, 11->3
ux = A*exp(iim*(2*pi*nphase/4 + pi/4));% points QPSK

% suréchantillonnage
Rs = Db/2;
nrepet = round(nus/Rs);             
u_ups = repelem(ux, nrepet); % donne la forme rectangulaire
Ntot = numel(u_ups);
t = (0:Ntot-1)*Ts;

x = real(u_ups).*cos(2*pi*fp*t) - imag(u_ups).*sin(2*pi*fp*t);

% Canal sans bruit

sigma2 = 20/50;
z = x+sqrt(sigma2)*randn(1,length(x)); % BRUIT !!!

% Démodulation IQ via signal analytique + mélange
uznus = hilbert(z).*exp(-iim*2*pi*fp*t);  % enveloppe complexe échantillonnée à nus

% Prélèvement au centre de chaque symbole
k  = (nrepet/2) : nrepet : Ntot;          % suppose nrepet pair ; sinon, floor(...)
uz = uznus(k);

function [d] = distance(x1, y1, x2, y2)
    d = (x1 - x2)^2 + (y1 - y2)^2;
end

function [min] = decision(x1,y1) % renvoie en sortie 0,1,2,3 selon le pt le plus proche
    L = [distance(x1, y1, 0.7071, 0.7071), distance(x1,y1, -0.7071, 0.7071), distance(x1,y1, -0.7071, -0.7071), distance(x1,y1, 0.7071, -0.7071)];
    min = 0; % ici, distance aux 4 pts du QPSK (circulaire)
    for n=[0,1,2,3]
        if (L(min+1)>L(n+1))
            min = n;
        end
    end
end

n = length(uz);
nphaseprime = zeros(n,1);
for i=[0:(n-1)]
    nphaseprime(i+1) = decision(real(uz(i+1)),imag(uz(i+1)));
end

mprime = str2num(reshape(dec2bin(nphaseprime)',2*Nsymb,1))'