addpath codCanal\;

addpath utilitaires\;

Ntest = 1000;
resultat = zeros(Ntest,1);

Pe = 0.04;

for i = 1:Ntest
    MessageSource = randi([0 1], 1, 1000);
    [w,MessageCode,doublon] = codageCanalH_29_2(MessageSource);
    MessageRecu = applicationCBS(MessageCode, Pe);
    MessageDecode = decodageCanalH_29_2(MessageRecu,doublon);
    nb_erreurs = 0;
    for j = 1 : numel(MessageDecode)
        if MessageDecode(j)~= MessageSource(j)
            nb_erreurs = nb_erreurs + 1;
        end
    end
    resultat(i) = nb_erreurs/length(MessageDecode);
end

moyenne_pourcentage = sum(resultat)/Ntest
