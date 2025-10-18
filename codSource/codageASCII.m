function [messageEncode] = codageASCII(message)
    % Vérifier qu'on a que du ASCII
    if any(message > 127)
        error('Le message contient des caractères non ASCII.');
    end
    messageEncode = dec2bin(message);

    messageEncode = reshape(messageEncode.', 1, []);
    messageEncode = messageEncode - '0';
end



