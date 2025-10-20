%% CODAGE DU CANAL H(5,2)

% Fonction appliquant le codage canal H(5,2) sur le message entré. Découpe
% le message selon des morceaux de longueur k et code les blocs avant de
% les assembler à nouveau
%
% Entrées : message => matrice quelconque binaire contenant le message
%
% Sorties : messageRobuste => matrice ligne binaire contenant le msg robuste
%           doublon => vaut 1 si le nb de bits du msg est impair. Dans ce
%           cas, le codage canal ajoute un bit (ici 0) pour compléter le
%           couple et le coder de la même façon

function [rho_cc,messageRobuste, doublon] = codageCanalH_5_2(message)
    G = [1 0 1 0 1; 0 1 0 1 1];         % Matrice génératrice

    % S'assure que 'message' est un vecteur ligne binaire
    message = message(:).'; 
    lMessage = numel(message);

    [k, n] = size(G);                   % Récupération de k et n. k=2 & n=5

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


% Fonction intervenant dans codageCanal servant à coder les bits d'entrée
%
% Entrées : bits => matrice ligne contenant les bits à coder. Sera remis en
%           forme via reshape puis remis sous format ligne 
%           G => matrice génératrice
%
% Sorties : code => matrice ligne contenant bits codé via la génératrice G

function code = codage(bits, G)
    [k, n] = size(G);                   % k = nb de bits par bloc
    blocs = reshape(bits, k, [])';      % découpe en blocs de k bits
    code = mod(blocs * G, 2)';          % multiplication binaire via mod
    code = code(:)';                    % remise en forme ligne de code
end

