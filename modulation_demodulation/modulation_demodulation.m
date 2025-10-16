m = [1 1 1 0 0 0 0 1]

nus = 1000;    % frequence d'echantillonnage (Hz)
fp = 200;      % frequence porteuse (Hz)
Db = 200;      % débit binaire (baud=1/sec)
A = 1;         % amplitude du signal

Ts = 1/nus;    % periode d'echantillonnage (sec)
iim = sqrt(-1);

Nsymb = Nbit/2; % nombre de symboles dans le message
msymbole = reshape(m,2,Nsymb); % sequence de symbole (matrice 2*Nsymb)

nphase = bin2dec(num2str(msymbole'))'; % transposition de {00,01,10,11} vers {0,1,2,3}
ux = A*exp(iim*2*pi*nphase/4+iim*pi/4)

% creation du signal réel x(t) à émettre : modulation IQ
N = length(ux);
t = [0:N-1]*Ts;
x = real(ux).*cos(2*pi*fp*t)-imag(ux).*sin(2*pi*fp*t)

% reste à comprendre la partie décodage

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