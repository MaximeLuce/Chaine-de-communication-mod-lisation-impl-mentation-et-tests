function y = codageCanalConv(u)
% Code convolutif (n,k,K) = (2,1,3) avec G1=111, G2=101
% A chaque bit d'entrée 2 bits de sortie : [y1 y2] (voir G pr détails)
    u = logical(u(:)'); % remise en forme
    K = 3;
    m = K-1;

    u = [u, false(1,m)];   % vidage de l'état

    % Registre à décalage actuel
    s = false(1,K);

    N = numel(u);
    Y = false(N, 2);        % 2 sorties par bit (taux 1/2)

    for t = 1:N
        % insérer le nouveau bit en tête
        s = [u(t), s(1:end-1)];

        % Parité totale sur le registre (codée via xor)
        y1 = xor(xor(s(1), s(2)), s(3));

        % Parité uniquement sur le 1er et le 3e terme
        y2 = xor(s(1), s(3));

        Y(t, :) = [y1, y2];
    end

    % Aplatir en vecteur ligne binaire pour renvi final
    y = reshape(Y.', 1, []);
end
