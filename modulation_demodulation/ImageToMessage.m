
function [message] = ImageToMessage(img)

%
% Transformation d'une image couleur .jpg en un signal binaire
% chaque pixel est codé sur 8 bit
%
% entree : - img : matrice des pixels de l'image (format uint8)
%
% sorties : - message : la sequence binaire
%

[N,M,d] = size(img);
nbit = 8;

% conversion en signal
imgsignal = reshape(img,N*M*d,1);

% conversion en binaire
jo = dec2bin(imgsignal,nbit);
jo = reshape(jo,nbit*N*M*d,1);
message = str2num(jo);

