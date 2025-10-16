function [Y] = demodulationQPSK(y)
    nus = 1000;   % Hz
    fp = 200;    % Hz
    Db = 200;    % bits/s
    A = 1;

    
    
    Ts = 1/nus;    
    iim = 1i;
    t = (0:length(y)-1)*Ts;
    
    % Démodulation IQ via signal analytique + mélange
    uznus = hilbert(y).*exp(-iim*2*pi*fp*t);  % enveloppe complexe échantillonnée à nus
    
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
end