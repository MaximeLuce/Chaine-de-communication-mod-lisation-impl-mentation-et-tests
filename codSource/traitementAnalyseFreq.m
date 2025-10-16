function [lettres, valeurs] = traitementAnalyseFreq(fichier)
    fid = fopen(fichier, 'r');
    data = textscan(fid, '%s %f', 'Delimiter', ';');
    fclose(fid);
    
    lettres = data{1};
    valeurs = data{2};
    
    valeurs(1) = 1-sum(valeurs(2:end));
end