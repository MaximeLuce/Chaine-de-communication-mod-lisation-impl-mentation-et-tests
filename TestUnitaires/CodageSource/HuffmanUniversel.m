clear all; close all;


%%
m=['hello ca va'];

disp('Message original:');
disp(m);

% TRAITEMENT
disp('Message filtré:');
messageFiltre = verifCaractere(m);
disp(messageFiltre);

% on recupere le traitement issu de python
[lettres, valeurs] = traitementAnalyseFreq('fichier.txt');

% Affichage sous forme de table
%T = table(lettres, valeurs)

% On calcule l'entropie et le débit de la source
H_S = entropieTexte(messageFiltre);
disp('H(S) = H(P_S) =');
disp(H_S);

%D_S = calculDS(messageFiltre);
D_S = 100;
disp('D(S) =');
disp(D_S);

Ht_S = H_S * D_S;
disp('Débit d information Ht(S) = ');
disp(Ht_S);

%% CODAGE DE SOURCE

% on code avec Huffman
[MessageEncode, dictionnaire, probas] = huffmanUniverselCod(messageFiltre, lettres, valeurs);
disp("Message codé");

l_k = fromDicoToListL_k(dictionnaire);
L = longueurMoyenne(l_k, probas)

L_min = H_S/log2(2)

%L = longueurMoyenneEmpirique(messageFiltre, dictionnaire, probas);
%L = 3.75; % cas pour message ="test"

eta = L_min/L

H_U = H_S/L;
disp('H(U) =');
disp(H_U);

D_U = L*D_S;
disp('D(U) =');
disp(D_U);

Ht_U = H_U * D_U;
disp('Débit d information Ht(U) = ');
disp(Ht_U);

%% DECODAGE DE SOURCE
[MessageDecode, dictionnaire, probas] = huffmanUniverselDecod(MessageEncode, lettres, valeurs);
%table(MessageEncode, MessageDecode);
disp("Message décodé :")
disp(MessageDecode)