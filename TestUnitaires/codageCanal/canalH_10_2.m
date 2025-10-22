
function [rho_cc,messageRobuste, doublon] = codageCanalH_10_2(message)
    G = [1 0 1 0 1 0 1 0 1 0; 0 1 0 1 0 1 0 1 0 1];         % Matrice génératrice

    % S'assure que 'message' est un vecteur ligne binaire
    message = message(:).'; 
    lMessage = numel(message);

    [k, n] = size(G);                   % Récupération de k et n. k=2 & n=10

    % Padding si la longueur n'est pas multiple de k
    r = mod(lMessage, k);
    pad = mod(k - r, k);                % nb de zéros ajoutés (0 si déjà multiple)

    if pad > 0                          % Ajout des zéros
        message = [message, zeros(1, pad)];
    end

    % Codage bloc (sur GF(2))
    messageRobuste = codage(message, G);
    doublon = r;
    rho_cc = k/n;
end


function code = codage(bits, G)
    [k, ~] = size(G);                   % k = nb de bits par bloc
    blocs = reshape(bits, k, [])';      % découpe en blocs de k bits
    code = mod(blocs * G, 2)';          % multiplication binaire via mod
    code = code(:)';                    % remise en forme ligne de code
end


function [messageDecode] = decodageCanalH_10_2(messageCode, doublon)
    G = [1 0 1 0 1 0 1 0 1 0; 0 1 0 1 0 1 0 1 0 1];     % Matrice génératrice

    messageCode = messageCode(:).';

    [~, n] = size(G);
    l = numel(messageCode);
    nbBlocs = floor(l/n);

    M = reshape(messageCode, n, [])'; % Remise en forme du msg pour correction
    Mcorr = zeros(nbBlocs,n);
    messageDecode = [];

    for i=1:nbBlocs
        Mcorr(i,:) = correction(M(i,:));
        messageDecode = [messageDecode Mcorr(i,1) Mcorr(i,2)];
        % Récupération des deux premiers termes (I2 dans G), qui
        % correspondent aux deux bits envoyés en entrée. A modifier si G
        % est changée
    end

    if doublon == 1
        messageDecode = messageDecode(1:end-1); % Supprime le dernier bit
        % en cas de longueur envoyée impaire
    end
end


function [d] = distance(x,y)

    assert(numel(x)==numel(y))
    d = 0;

    for i=1:numel(x)            % boucle sur les éléments
        d = d + abs(x(i) - y(i));
    end

end

function [corrige] = correction(element)

    l_possibles = [0 0 0 0 0 0 0 0 0 0; 
                   0 1 0 1 0 1 0 1 0 1; 
                   1 0 1 0 1 0 1 0 1 0; 
                   1 1 1 1 1 1 1 1 1 1];      % dépend de G

    corrige = [0 0 0 0 0 0 0 0 0 0];          % initialisé par le premier terme
    d_min = 10;                               % initialisé à la distance max possible

    for i=1:4                                 % boucle d'étude et de correction
        dist = distance(l_possibles(i,:),element);

        if dist < d_min
            d_min = dist;
            corrige = l_possibles(i,:);
        end
    end

end

msg = [0 1 0 1 0 1 0 1]
[rho_cc,msg_code,doublon] = codageCanalH_10_2(msg);
msg_code
msg_recu = decodageCanalH_10_2(msg_code,doublon)