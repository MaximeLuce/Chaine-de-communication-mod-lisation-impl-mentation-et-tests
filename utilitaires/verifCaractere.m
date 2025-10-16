function messageFiltre = verifCaractere(message)
%VERIFCARACTERE Vérifie et nettoie les caractères d'une chaîne.
%   messageFiltre = verifCaractere(message) convertit le texte en minuscules,
%   enlève les accents et ne conserve que les lettres, chiffres et espaces.

    % Convertir en char si c'est un string
    if isstring(message)
        message = char(message);
    end

    % Enlever les accents et mettre en minuscules
    message = lower(removediacritics(message));

    % Alphabet autorisé (lettres, chiffres et espace)
    alphabetAutorise = [' ', 'a':'z', '0':'9'];

    % Initialiser le message filtré comme une chaîne vide
    messageFiltre = '';

    % Boucle sur chaque caractère du message
    for i = 1:length(message)
        if ismember(message(i), alphabetAutorise)
            messageFiltre = [messageFiltre message(i)];
        end
    end
end


%% Fonction locale : removediacritics
function clean_s = removediacritics(s)
%REMOVEDIACRITICS Supprime les accents et caractères spéciaux d'une chaîne.

    % Majuscules
    s = regexprep(s,'(?:Á|À|Â|Ã|Ä|Å)','A');
    s = regexprep(s,'(?:Æ)','AE');
    s = regexprep(s,'(?:ß)','ss');
    s = regexprep(s,'(?:Ç)','C');
    s = regexprep(s,'(?:Ð)','D');
    s = regexprep(s,'(?:É|È|Ê|Ë)','E');
    s = regexprep(s,'(?:Í|Ì|Î|Ï)','I');
    s = regexprep(s,'(?:Ñ)','N');
    s = regexprep(s,'(?:Ó|Ò|Ô|Ö|Õ|Ø)','O');
    s = regexprep(s,'(?:Œ)','OE');
    s = regexprep(s,'(?:Ú|Ù|Û|Ü)','U');
    s = regexprep(s,'(?:Ý|Ÿ)','Y');

    % Minuscules
    s = regexprep(s,'(?:á|à|â|ä|ã|å)','a');
    s = regexprep(s,'(?:æ)','ae');
    s = regexprep(s,'(?:ç)','c');
    s = regexprep(s,'(?:ð)','d');
    s = regexprep(s,'(?:é|è|ê|ë)','e');
    s = regexprep(s,'(?:í|ì|î|ï)','i');
    s = regexprep(s,'(?:ñ)','n');
    s = regexprep(s,'(?:ó|ò|ô|ö|õ|ø)','o');
    s = regexprep(s,'(?:œ)','oe');
    s = regexprep(s,'(?:ú|ù|ü|û)','u');
    s = regexprep(s,'(?:ý|ÿ)','y');

    clean_s = s;
end
