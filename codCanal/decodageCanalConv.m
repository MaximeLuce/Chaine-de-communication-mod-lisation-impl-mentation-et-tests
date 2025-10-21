function messageDecode = decodageCanalConvRobuste(messageCode, trellis, K)
    % DECODAGECANALCONVROBUSTE
    % Décodage Viterbi du code convolutif robuste
    % Compatible avec toutes les versions de MATLAB

    % Longueur de traceback (en général 5xK)
    tblen = 5 * K;

    % Décodage Viterbi (mode "term" = retour à l'état zéro)
    messageDecode = vitdec(messageCode, trellis, tblen, 'term', 'hard');

    % Suppression des bits de flush
    messageDecode = messageDecode(1:end - (K - 1));
end
