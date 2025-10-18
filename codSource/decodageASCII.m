function [messageDecode] = decodageASCII(messageEncode)
    % on part de la matrice et on redécoupe en bloc de 4
    l = length(messageEncode);
    q = (l-mod(l,4))/4;
    messageEncode = reshape(char(messageEncode + '0'), q, 4).';

    % Vérifier qu'on a que du ASCII
    if any(any(messageEncode > '1') | any(messageEncode < '0'))
        error('Le message encodé contient des valeurs non binaires.');
    end
    n = size(messageEncode, 1);
    messageDecode = char(bin2dec(messageEncode)');
end