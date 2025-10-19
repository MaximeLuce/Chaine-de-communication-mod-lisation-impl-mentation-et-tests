function [D_S] = calculDS(message)
    n = length(message);
    if n > 100
        warning("Il y a plus de symboles dans le message que la source ne peut en envoyer en une seconde");
        D_S = 100;
    else
        D_S = n;
    end
end