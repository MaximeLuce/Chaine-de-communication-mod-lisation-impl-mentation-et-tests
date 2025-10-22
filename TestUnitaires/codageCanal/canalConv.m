function y = codageCanalConv(u)
    u = logical(u(:)');
    K = 3;
    m = K-1;
    u = [u, false(1,m)]; 
    s = false(1,K);

    N = numel(u);
    Y = false(N, 2);  

    for t = 1:N
        s = [u(t), s(1:end-1)];
  %par registre
        y1 = xor(xor(s(1), s(2)), s(3));
        % par 1-3
        y2 = xor(s(1), s(3));
        Y(t, :) = [y1, y2];
    end

    y = reshape(Y', 1, []);
end



function [u_hat, u_hat_nottail] = decodageCanalConv(y)
% [u_hat, u_hat_nottail] = viterbiDecode_K3_zerotail(y)
%  - y : vecteur binaire (ligne/colonne) longueur 2*T (paires de bits)
%        flux codé par convEncode_K3(..., true) avec tail de m=K-1=2 zéros
%  - u_hat : séquence binaire estimée (T bits, y compris les 2 bits de tail)
%  - u_hat_nottail : séquence binaire estimée SANS les bits de tail (longueur T-2)
%
% Code (2,1,3) avec générateurs G1=111, G2=101 comme tu as fait.
% États (mémoire m=2) : 00,01,10,11  <=> 0,1,2,3
% Convention d’état : state = [u(t-1) u(t-2)] (bit le plus récent à gauche).
%
% Hypothèses :
%   - zero-tail => état initial = 00 et état final = 00 connus
%   - hard decision (bits 0/1)
%
% Sorties :
%   - u_hat : inclut les 2 bits de tail (pratiques pour debuggage)
%   - u_hat_nottail : supprime les deux derniers bits (payload estimé)

    % --- Préparation ---
    y = logical(y(:)');                   % ligne logique
    if mod(numel(y),2) ~= 0
        error('La longueur de y doit être paire (paires de sorties).');
    end
    T = numel(y)/2;                       % nombre de symboles d'entrée encodés
    m = 2;                                % mémoire (K-1)
    nStates = 2^m;                        % 4 états : 00,01,10,11

    % Paires reçues
    r = reshape(y, 2, T).';               % T x 2

    % --- Treillis / tables de transition ---
    % État courant s = [p q] = [u(t-1) u(t-2)], encodage -> idx = p*2+q (0..3)
    % Pour une entrée b in {0,1}:
    %   next state s' = [b, p]  => idx' = b*2 + p
    %   sorties :
    %       y1 = b XOR p XOR q
    %       y2 = b XOR q
    %
    % On précompute sorties attendues et états suivants pour chaque (state, b).
    nextState = zeros(nStates,2);         % [:,1] pour b=0, [:,2] pour b=1
    outBits   = false(nStates,2,2);       % (state, b+1, [y1 y2])

    for s = 0:nStates-1
        p = bitget(s,2);  % u(t-1)
        q = bitget(s,1);  % u(t-2)
        for b = 0:1
            ns = b*2 + p;         % next state index
            y1 = xor(xor(b,p), q);
            y2 = xor(b, q);
            nextState(s+1, b+1) = ns + 1;            % 1-based
            outBits(s+1, b+1, :) = [y1, y2];         % attendu
        end
    end

    % --- Viterbi : initialisation ---
    INF = 1e9;
    pathMetric = INF * ones(T+1, nStates);       % métrique cumulée
    pathMetric(1, 1) = 0;                        % état initial = 00 (indice 1)
    prevState  = zeros(T, nStates, 'uint8');     % backpointers: état précédent choisi
    prevInput  = false(T, nStates);              % bit d'entrée choisi

    % --- Récursion ---
    for t = 1:T
        rx = squeeze(r(t,:));  % 1x2
        for s = 1:nStates
            pm_s = pathMetric(t, s);
            if pm_s >= INF/2, continue; end  % état inaccessible

            % Essayer b=0 et b=1
            for b = 0:1
                ns = nextState(s, b+1);
                y_exp = squeeze(outBits(s, b+1, :)).';   % 1x2
                % distance de Hamming avec la paire reçue
                bm = sum(xor(rx, y_exp));
                cand = pm_s + bm;

                if cand < pathMetric(t+1, ns)
                    pathMetric(t+1, ns) = cand;
                    prevState(t, ns) = uint8(s);
                    prevInput(t, ns) = logical(b);
                end
            end
        end
    end

    % --- Terminaison (zero-tail) ---
    % Avec tail, on sait que l'état final est 00 -> index 1
    finalState = 1;

    % --- Traceback ---
    u_hat = false(1, T);
    s = finalState;
    for t = T:-1:1
        u_hat(t) = prevInput(t, s);
        s = prevState(t, s);
        if s == 0
            % si jamais (théoriquement impossible si le treillis est complet),
            % on protège pour éviter une erreur d'index
            s = 1;
        end
    end

    % u_hat inclut les 2 bits de tail -> on les retire pour la version payload
    if T < m
        error('La séquence est trop courte pour contenir le tail attendu.');
    end
    u_hat_nottail = u_hat(1 : T - m);
end


u = [1 0 1 1 0 0 1 0 1 1 0 0 0 1 0 1]
y = codageCanalConv(u);
[Z1,z2] = decodageCanalConv(y);
z2