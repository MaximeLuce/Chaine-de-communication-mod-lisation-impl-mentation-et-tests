from unidecode import unidecode

alphabetAutorise = [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

def compter_frequence_caracteres(chemin_fichier, frequences):
    try:
        with open(chemin_fichier, 'r', encoding='utf-8') as fichier:
            contenu = fichier.read()

            contenu = contenu.rstrip('\n')
            contenu = contenu.lower()
            contenu = unidecode(contenu)


            for caractere in contenu:
                if caractere in alphabetAutorise:
                    if caractere in frequences:
                        frequences[caractere] += 1
                    else:
                        frequences[caractere] = 1
    except FileNotFoundError:
        print(f"Erreur : le fichier '{chemin_fichier}' n'a pas été trouvé.")
    except Exception as e:
        print(f"Une erreur est survenue : {e}")

    return frequences

l = compter_frequence_caracteres("rougeetnoir.txt",{})
l2 = compter_frequence_caracteres("crimeetchatiments.txt",l)
l4 = compter_frequence_caracteres("perdu.txt",l2)
l3 = compter_frequence_caracteres("1984.txt",l4)
texte = str(l3)

n = sum(l3.values())

def diviser_valeurs(dictionnaire):
    return {cle: round(valeur / n,5) for cle, valeur in dictionnaire.items()}

l3 = diviser_valeurs(l3)
l3 = dict(sorted(l3.items()))
texte = str(l3)
t2 = "["
for elt in texte:
    if elt==":":
        t2 = t2 + " "
    elif elt==",":
        t2+= "\n"
    elif elt == "'":
        elt+=""
    else:
        if not(elt==" ") and not(elt== "{") and not(elt== "}"):
            t2=t2+elt
t2+="]"
with open('fichier.txt', 'w') as f:
    f.write(str(t2))