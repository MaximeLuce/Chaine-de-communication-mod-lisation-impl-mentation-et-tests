function [messageDecode] = decodageASCII(messageEncode)
    if any(messageEncode ~= 0 & messageEncode ~= 1)
        error('Le message encodé contient des valeurs non binaires.');
    end

    l = length(messageEncode);
    l_tronc = l - mod(l,8);          % Multiple de 8 bits
    messageEncode = messageEncode(1:l_tronc);

    % Regrouper en blocs de 8 bits
    messageEncode = reshape(char(messageEncode + '0'), 8, []).';
    
    % Conversion binaire → texte
    messageDecode = char(bin2dec(messageEncode))';
end
