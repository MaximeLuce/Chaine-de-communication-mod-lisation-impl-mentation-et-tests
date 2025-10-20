function [Y] = demodulationQPSK_soft(y, nus, fp, Db, A)
  
    Ts = 1/nus;
    iim = 1i;
    t = (0:length(y)-1)*Ts;
    Rs = Db/2;
    nrepet = round(nus/Rs);
    Ntot = floor(numel(y)/nrepet)*nrepet;
    Nsymb = Ntot / nrepet;

    % demod
    uznus = hilbert(y) .* exp(-iim*2*pi*fp*t);  % signal complexe à fréquence base

    % on regroupe par symb
    uz_block = reshape(uznus(1:Ntot), nrepet, Nsymb);

    % DECISION SOUPLE : on intégère sur Re et Im
    I_vals = sum(real(uz_block), 1);
    Q_vals = sum(imag(uz_block), 1);

    % decision
    nphaseprime = zeros(1, Nsymb);
    for i = 1:Nsymb
        nphaseprime(i) = decisionQPSK(I_vals(i), Q_vals(i));
    end

    % on convertit les symb en bits
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
