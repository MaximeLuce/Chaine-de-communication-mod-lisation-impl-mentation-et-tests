from unidecode import unidecode

# Alphabet autorisé
alphabetAutorise = [' ', 'a','b','c','d','e','f','g','h','i','j','k','l','m',
                    'n','o','p','q','r','s','t','u','v','w','x','y','z',
                    '?', '!', ',', '.']

def compter_frequence_caracteres(chemin_fichier):
    frequences = {}
    try:
        with open(chemin_fichier, 'r', encoding='utf-8') as fichier:
            contenu = fichier.read()
            
            # On applique unidecode à tout le texte
            contenu = unidecode(contenu)
            contenu = contenu.lower().rstrip('\n')

            for caractere in contenu:
                if caractere in alphabetAutorise:
                    frequences[caractere] = frequences.get(caractere, 0) + 1
    except FileNotFoundError:
        print(f"Erreur : le fichier '{chemin_fichier}' n'a pas été trouvé.")
    except Exception as e:
        print(f"Une erreur est survenue : {e}")
    return frequences

def diviser_valeurs(dictionnaire):
    total = sum(dictionnaire.values())
    return {cle: round(valeur / total, 5) for cle, valeur in dictionnaire.items()}

# Traitement
l3 = compter_frequence_caracteres("1.txt")
l3 = diviser_valeurs(l3)
l3 = dict(sorted(l3.items()))

# Création d'une sortie lisible
lignes = [f"{cle}: {valeur}" for cle, valeur in l3.items()]
with open('fichier.txt', 'w') as f:
    f.write("[\n")
    f.write("\n".join(lignes))
    f.write("\n]")
