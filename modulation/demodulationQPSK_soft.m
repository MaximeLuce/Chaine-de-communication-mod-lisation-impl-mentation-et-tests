function [Y] = demodulationQPSK_soft(y)
    nus = 10000; % Hz
    fp = 200;    % Hz
    Db = 200;    % bits/s
    A = 1;
    Ts = 1/nus;
    iim = 1i;
    t = (0:length(y)-1)*Ts;
    Rs = Db/2;
    nrepet = round(nus/Rs);
    Ntot = floor(numel(y)/nrepet)*nrepet;
    Nsymb = Ntot / nrepet;

    % --- Démodulation IQ ---
    uznus = hilbert(y) .* exp(-iim*2*pi*fp*t);  % signal complexe à fréquence base

    % --- Regroupement par symbole ---
    uz_block = reshape(uznus(1:Ntot), nrepet, Nsymb);

    % --- Intégration sur chaque symbole ---
    % Partie réelle (I) et imaginaire (Q)
    I_vals = sum(real(uz_block), 1);
    Q_vals = sum(imag(uz_block), 1);

    % --- Décision ---
    nphaseprime = zeros(1, Nsymb);
    for i = 1:Nsymb
        nphaseprime(i) = decisionQPSK(I_vals(i), Q_vals(i));
    end

    % --- Conversion symboles -> bits ---
    Y = str2num(reshape(dec2bin(nphaseprime,2)', 2*Nsymb, 1))';
end

function [d] = distance(x1, y1, x2, y2)
    d = sqrt((x1 - x2)^2 + (y1 - y2)^2);
end

function [min_idx] = decisionQPSK(x1, y1)
    % Points QPSK normalisés
    pts = [ 0.7071+0.7071i,  -0.7071+0.7071i,  -0.7071-0.7071i,  0.7071-0.7071i ];
    L = abs(x1 + 1i*y1 - pts);
    [~, min_idx] = min(L);
    min_idx = min_idx - 1; % pour avoir 0,1,2,3
end
