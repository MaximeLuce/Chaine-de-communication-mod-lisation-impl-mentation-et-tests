function [messageRobuste, doublon] = codageCanalH_7_2(message)
    G = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1; 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1];

    % S'assure que 'message' est un vecteur ligne binaire
    message = message(:).';
    lMessage = numel(message);

    [k, n] = size(G);

    % Padding si la longueur n'est pas multiple de k
    r = mod(lMessage, k);
    pad = mod(k - r, k);      % nb de zéros ajoutés (0 si déjà multiple)
    if pad > 0
        message = [message, zeros(1, pad)];
    end

    % Codage bloc (sur GF(2))
    messageRobuste = codage(message, G);
    doublon = r;
end

function code = codage(bits, G)
    [k, n] = size(G); % k = nb bits d'entrée
    blocs = reshape(bits, k, [])'; % découpe en blocs de k bits
    code = mod(blocs * G, 2)'; % multiplication binaire
    code = code(:)';
end