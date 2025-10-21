function [messageEncode] = codageASCII(message)
    % Vérifier qu'on a que du ASCII
    if any(message > 127)
        error('Le message contient des caractères non ASCII.');
    end

    % Conversion ASCII → binaire sur 8 bits
    messageEncode = dec2bin(message, 8);

    % Mise à plat (transforme la matrice en un vecteur ligne)
    messageEncode = reshape(messageEncode.', 1, []);
    messageEncode = messageEncode - '0';
end
