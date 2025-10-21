function [rho_cc, messageCode, trellis, K] = codageCanalConv(message)
    % CODAGECANALCONVROBUSTE
    % Codage convolutif robuste (taux 1/3, contrainte K=9)
    % Adapté aux canaux très bruités (Eb/N0 ~ 0 dB)
    % Retourne également le treillis pour le décodage

    % Paramètres du code convolutif
    K = 9; 
    polynomes = [753 561 671];   % Polynômes octaux performants pour K=9
    trellis = poly2trellis(K, polynomes);

    % Calcul du taux de codage
    rho_cc = 1/3;

    % Mise en forme du message en ligne
    message = message(:).';

    % Ajout de bits de terminaison (flush)
    % -> Retour à l'état zéro pour le décodage
    messageFlush = [message zeros(1, K-1)];

    % Codage convolutif
    messageCode = convenc(messageFlush, trellis);
end
