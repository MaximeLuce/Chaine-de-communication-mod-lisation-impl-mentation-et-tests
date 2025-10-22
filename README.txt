===========CHAINE DE TRANSMISSION DE L'INFORMATION===========

Ce dossier contient l'ensemble des fichiers et codes utilisés dans un projet visant à recoder de zéro une chaîne de transmission de l'information
passant par un canal réel de bruit fixé. L'ensemble des codes réalisés, sauf justification explicite "IA" en haut de fichier, ont été codés à la main.

Les codes ont été réalisés par Adrien FRACHET (adrien.frachet@etu.ec-lyon.fr) et Maxime LUCE (maxime.luce@etu.ec-lyon.fr).

Un tri a été effectué sur les dossiers, qui se répartissent en deux types : Les dossiers propres et les dossiers de rangement.
 => Les dossiers propres sont mis en place et commentés de manière lisible pour permettre au lecteur de comprendre le code/les fichiers qui s'y trouve/nt.
    On notera que les dossiers propres et les fichiers qu'ils contiennent sont mis en place de sorte à assurer des appels depuis d'autres fichiers.

 => Les dossiers de rangement contiennent des fichiers non rangés, pour la plupart non commentés, qui ont servi à l'acquisition de données utilisées 
    lors de la présentation orale du projet ou qui ont servi de fichiers de tests durant le codage.

La liberté a été prise d'écrire "H" dans le nom des fichiers même lorsqu'il ne s'agissait pas d'un codage canal de Hamming pour simplifier le changement des fonctions.




Les fichiers directement accessibles dans le dossier que vous venez d'extraire sont les fichiers de test de la chaîne d'information complète.
Le nom du fichier est écrit de la manière suivante : "main[codage source]_[codage canal/nom du canal]". Ils sont tous modulables et codés de sorte à ce que les blocs importants de la chaîne de transmission (codage de source, codage canal, probabilité d'erreur, modulation/démodulation) puissent être changés en une ligne.



Les fichiers correspondant au choix de la chaîne finale sont :

 - "mainLZW_CBS", contenant un codage de source LZW, un codage canal C(15,2) et un CBS de probabilité d'erreur de 0.14.
 - "mainLZW_mod_demod", contenant un LZW, un codage canal C(29,2) et un canal BABG via un QPSK gaussien (comme expliqué à l'oral, respectant les contraintes 		de l'énoncé)


Le reste des fichiers est réparti de la manière suivante :
 - analyseFrequentielleLivres : dossier de rangement, contient les fichiers qui ont servi à l'acquisition des fréquences d'apparition des lettres.
                                Est utilisé notamment pour caractériser la source simple et la source de Markov, de la littérature et de nos relevés.

 - BackUp : Dossier de rangement contenant certaines backups du code. Utiles en cas de problèmes lors des commits Matlab

 - adrienVrac : Dossier de rangement, contient des codes en vrac que j'ai utilisé au cours du projet

 - CBS : dossier propre, contient le code du canal CBS idéal

 - codCanal : dossier propre, contient l'ensemble des fichiers ayant un rapport avec le codage canal. 

 - codSource : dossier propre, contient les fichiers sur lesquels sont codés les codages de source

 - config : dossier propre, contient les variables importantes du problème afin de n'avoir à les changer qu'à un endroit. Contient également la source 					simple

 - illustrations : dossier propre, contient le fichier permettant le tracé des figures durant la présentation

 - modulation : dossier propre, contient les fichiers où sont codés les modulations/démodulations considérées.

 - résultats : dossier propre, contient les figures utilisées dans la présentation et un code permettant d'obtenir les fréquences d'erreurs sur 1000 					messages de 1000 bits

 - Sujet : dossier propre, le nom parle de lui-même

 - testUnitaires : Dossier propre, contient des tests linéaires hors canal complet pour les tests durant la présentation

 - utilitaires : Dossier propre, contient les fonctions permettant d'accéder aux données théoriques importantes


Bonne lecture ! N'hésitez pas à nous contacter en cas de questions 

Adrien FRACHET (adrien.frachet@etu.ec-lyon.fr)
Maxime LUCE (maxime.luce@etu.ec-lyon.fr)
