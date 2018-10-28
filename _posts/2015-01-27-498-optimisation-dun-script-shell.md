---
layout: post
title: "Optimisation d’un script SHELL"
date: 2015-01-27 12:26:40
image: /assets/img/optimisation.png
description: Optimisation d’un script SHELL
category: 'SHELL'
tags:
- administration système
- SHELL
twitter_text: Optimisation d’un script SHELL
introduction: Il faut toujours repasser derrière les apprentis !
---

> [image disponible sur WikiCommons](https://commons.wikimedia.org/wiki/File:Second%2Bstage%2Bacceleration%2Bprogram-5(1).png) par [Jeriahkosch](https://commons.wikimedia.org/wiki/User:Jeriahkosch) sous licence [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en)

Nous avons un script shell. Celui-ci fonctionne en deux étapes. La première étape dure une nuit. La deuxième étape dure elle aussi toute une nuit. Cependant, ce processus doit être exécuté pour 60 serveurs. La durée totale théorique est donc de 120 jours!

La première étape peut être parallélisée, sur les 60 serveurs en même temps. La première étape peut donc avoir une durée d’une nuit si on lance le processus sur les 60 serveurs en parallèle. La deuxième étape ne peut être parallélisée car elle doit être exécutée sur un seul et unique serveur et elle génère 60 résultats différents (un par serveur source, dépendant du résultat de l’étape 1 exécutée sur chacun des serveurs sources). La 2e étape a donc une durée incompressible de 60 nuits.

Il faut donc au moins 61 nuits (1 + 60) pour exécuter l’intégralité du processus. Trop long. Trop complexe. Trop peu sûr (on a du relancer le processus plusieurs fois suite à des erreurs). Comment optimiser cela?

Edit : précisions apportées suite au commentaire de « bob morane », merci à lui!

## Le script

Les principes de base du script sont les suivants :

* récupérer des noms d’image dans une base de données
* générer une liste de ses images
* regarder sur le système de fichier s’il y a :
  * une image de taille X1 pour ce nom d’image
  * une image de taille X2 pour ce nom d’image
  * une image de taille X3 pour ce nom d’image
  * une image de taille X4 pour ce nom d’image
  * une image de taille X5 pour ce nom d’image
  * vérifier pour chaque taille si l’image existe en .JPG ou en .jpg
* générer une liste des images manquantes
* cette liste est ensuite récupérée par un humain
* elle est copiée sur un serveur
* les images de cette liste (d’images manquantes) sont ajoutées dans un tar.gz. Comme on ne sait pas s’il manque une image en .JPG ou une image en .jpg, il est nécessaire de * vérifier quel est le bon nom de l’image manquante.

Deux personnes sont passées sur ce script. Deux jeunes, débutants. Ce script a été une arlésienne pendant plusieurs mois :

* impossible d’avoir quelque chose de fonctionnel
* des formats ayant été oubliés, il a fallu recommencer les traitements (2 nuits à chaque fois)
* une erreur bête dans le script ayant été faite, il a encore fallu recommencer les traitements
* la correction de cette erreur bête n’a été faite qu’à un seul endroit au lieu de deux, il a encore fallu recommencer les traitements.

Je leur ai parlé d’optimisation. Cela semblait impossible : ça avait l’air d’une complexité sans nom. Ne pouvait-on pas refaire ce script en quelque chose de plus rapide que le bash? Non. Ne pouvait on pas utiliser des structures de données plus performantes telles les tables de hachage? Non. Ne pouvait-on pas revoir l’ordre des étapes pour optimiser le processus? Non. Peut-on passer par un find, stocker le résultat dans un fichier texte et faire des recherches dans le résultat? Non!

Après une énième erreur, j’ai fini par m’y attaquer directement. J’ai donc ouvert ce script moi-même, pour regarder le code (je vous invite à regarder « Code is law« ). Ouch! Heureusement que j’étais seul sinon les insultes auraient plu comme jamais! Ce script était une horreur infecte, sans nom, rempli d’erreurs et d’erreurs potentielles, d’approximations, de ralentissements, … :

* enchaînement de sed là où on pouvait n’en faire qu’un seul
* à chaque étape d’une boucle, une variable était re-calculée. Cette variable était composée de deux parties : une partie toujours identique et une partie différente, en fonction de l’itération de la boucle. Le calcul de cette première partie incluait des appels à sed/awk/grep/… Il était possible de faire le calcul avant de rentrer dans la boucle mais ça n’avait pas été fait.
* à chaque itération de la boucle, une vingtaine d’opérations de lecture sont faites sur le système de fichier.
* en cas d’erreur, il faut relancer l’intégralité du script.
* …

Pendant l’exécution de ce script, le serveur est fortement ralenti, les utilisateurs se plaignent. Il faut trouver une autre voie.

## Revenir au but premier

Lorsqu’on est le nez dans le guidon et complètement dépassé, il est nécessaire de s’arrêter. S’arrêter complètement. Presque tout jeter à la poubelle, pour revenir au « but premier« . Le « but premier » est l’objectif que l’on doit atteindre. Lorsqu’on a un script à réaliser, le but premier est « quel est l’objectif à atteindre pour ce script? ». Il ne faut pas confondre « quel est l’objectif à atteindre? » avec « quel est le but du script? ». Ceci sont deux choses différentes :

* l’un se concentre sur l’objectif, le résultat final, le fonctionnel.
* l’autre se concentre sur la réalisation de cet objectif : la partie technique, les tâches intermédiaires. Or parfois, étant parti sur une mauvaise idée, on reste bloqué dans la réalisation de cette mauvaise idée. On reste dans des considérations techniques, parfaitement inutile car une autre voie existe.

Il faut donc repartir sur l’objectif premier et se demander « qu’est ce que l’on voulait faire déjà?« . Il y a d’autres situations sur lesquels on peut bloquer et pour lesquels on doit prendre une décision. Il faut alors là aussi revenir au but premier, qui peut être totalement différent :

* quel est le but réel de ce projet? dans le cas d’un problème technique bloquant, ne pouvant être résolu rapidement. Parfois, le but du projet ne nécessite pas que ce problème soit résolu dès à présent, dans la phase actuelle. Le projet peut être re-planifié, en excluant cette fonction bloquante, le temps que le problème technique soit résolu. Si le projet peut avancer sans cette fonction, pourquoi se priver? Une fois que le problème technique est résolu, il faut ré-intégrer la fonction dans le projet. Ce genre de réflexion est difficile à accepter car elle implique un échec, temporaire, mais un échec. Il ne faut pas se focaliser sur ce pseudo-échec mais sur l’atteinte de l’objectif global.
* quel est le but de la structure? Là, c’est encore pire : de nombreux projets rencontrent de nombreux problèmes, certains sont bloquants, d’autres ont des impacts non négligeables sur les autres entités de la structure. Bref, toute la structure est impactée. Ces problèmes sont liés à différentes sous-entités et, pour elles, son problème est très important et très urgent. Il faut prioriser les sujets, mais comment? En se basant sur l’objectif premier de la structure. En se concentrant sur le global et non sur les sous-entités ou les personnes. Et éduquer les personnes de ces sous-entités pour leur faire accepter que leurs problèmes ne sont pas prioritaires et qu’ils auront plus de travail encore. Pas simple…

Le but premier est premier dans le sens où il est le plus important et il est aussi le but original, celui que nous souhaitions atteindre avant que « tout se passe mal » et que « ça parte complètement en couilles » comme disent les anciens jeunes.

Revenons à notre sujet : que souhaitions nous faire exactement?

## Notre but premier

Notre but premier est le suivant : vérifier que toutes les images déclarées dans une application sont bien présentes sur tous les serveurs et pourront êtres affichées à l’utilisateur, lorsqu’il le demande.

OK, on y voir déjà plus clair. Une nouvelle analyse s’impose. Voici les caractéristiques :

* l’application et les données sont identiques partout, sur tous les serveurs! La base de données étant identique partout, elle contient donc les mêmes images. Il n’est pas nécessaire de recalculer sur chaque serveur la liste des images devant être présente!
* les images peuvent disposer de l’extension .JPG ou .jpg.
* les images doivent être présentes dans les formats X1, X2, X3, X4 et X5.
* il faut identifier les images manquantes et les renvoyer.
* si on écrase les images? C’est à dire si l’on renvoie des images déjà présentes? Ce n’est pas grave : elles seront identiques alors…
* Et si on renvoyait tout? C’est à dire qu’on n’exécute pas le script et que l’on considère qu’il faut renvoyer l’intégralité des images? Non, beaucoup trop lourd, pas assez d’espace sur les serveurs cibles et connexion internet limitée pour la majorité des serveurs (quelques MBits/s).

## Optimisons

Une première optimisation est déjà faite : on construit un fichier contenant la liste des images devant être présentes une et une seule fois.

Effectuer 20 opérations d’accès disque pour chaque itération de boucle est trop coûteux. Pourquoi ne pas inverser? Un find est fait sur le serveur cible, il liste tous les fichiers présents, on stocke ça dans un fichier et ensuite on fait des recherches dans ce fichier. Combien de temps prends le find? Après un test : quelques minutes seulement! De plus, s’il y a une erreur dans le script, on pourra réaliser ce résultat intermédiaire, sans le refaire! Banco!

Ensuite, il faut éviter les fork dans les scripts bash : ceci est très très très coûteux. Demander à Nagios! Il faut donc éviter au maximum les appels aux commandes externes : sed/awk/grep/cut/ls/… On peut utiliser les builtins commands (les commandes internes à bash qui ré-implémentent en partie sed/cut/grep/… et sont plus rapides à utiliser) mais nous ne sommes pas très à l’aise avec celles-ci. Développons dans un autre langage qu’un langage interprété. Prenons un langage d’administrateur, relativement simple (si bien utilisé) et plus performant. Qui vote pour Java? Bon, Java est éliminé d’emblée. Bizarre! Quelqu’un a parlé de Ruby mais il a été abattu de suite, sans sommation. 😉 Reste les vrais langages : Perl et Python. La moitié (moi) préfère Perl, l’autre moitié (les deux autres) préfère Python (oui, je compte pour deux 😉 ). Difficile de se départager.

Pour optimiser les recherches, rien de mieux qu’une table de hachage : on stocke l’intégralité du fichier résultat du find dans une table de hachage et on fait des recherches en utilisant les clés. Moi j’ai déjà utilisé des tables de hachage en Perl : très très rapide. Et vous, en Python? Jamais? Bon, reste à vérifier que le chargement du fichier et sa mise en table de hachage n’est pas trop long et ne fait pas exploser la mémoire. Je vérifie, par un script très léger, qui ne fait que charger le fichier d’exemple et le transformer en table de hachage. Zut, j’ai du me tromper dans le code : ça s’est terminé beaucoup trop rapidement. Où me suis-je trompé? … Bizarre… Heu… non… pas d’erreur. En fait, c’est hyper-supra-giga-ultra-méga-rapide. On part donc sur Perl et les tables de hachage.

Reste la génération du tar.gz devant contenir les images manquantes. Plutôt que de faire un tar.gz contenant les images manquantes d’un seul serveur, pourquoi ne pas faire un tar.gz contenant toutes les images? L’idée est discutée et adoptée en considérant l’option suivante : collecter tous les résultats et les analyser pour identifier des « pattern ». Nous identifions :

* sur beaucoup de serveurs, il manque peu d’images (quelques centaines au total)
* sur quelques serveurs, il manque beaucoup d’images et ce sont toujours les mêmes images qui sont manquantes.

On a donc fait deux paquets .tar.gz : un agrégeant toutes les images manquantes sur de nombreux serveurs ; l’autre agrégeant le très grand nombre d’images manquantes.

Une dernière optimisation a été faite pour faire un fichier contenant la liste des images manquantes le plus propre et le plus efficace possible, afin d’améliorer la construction des tar.gz.

D’autres optimisations sont faites, elles sont mineures mais ont encore permis d’améliorer le résultat.
# Résultat

Auparavant :

* 10 heures pour identifier les images manquantes sur 1 serveur : à faire 60 fois
* entre 10 heures et 24 heures pour générer une archive contenant les images manquantes : à faire 60 fois.

Dorénavant :

* 10 minutes (oui, 10 minutes!) pour identifier les images manquantes. Ces actions peuvent être faites en parallèle sur tous les serveurs. Elle peut aussi être refait à la demande!!! En effet, l’impact est beaucoup plus léger qu’auparavant.
* deux fois 6 heures pour générer une archive contenant les images manquantes.

## Conclusion

« t’as essayé de prendre du recul? » Vous avez déjà entendu cela d’un « petit chef » sans savoir ce qu’il voulait dire? Moi oui. « Prends du recul » n’est pas très parlant, n’aide pas forcément. Lorsqu’on est dans ce genre de situation, bloqué, il est très compliqué de prendre du recul. En général, il faut revenir au but premier et demander de l’aide à un oeil extérieur : une personne qui n’a pas travaillé sur le sujet mais qui pourrait avoir une autre approche. Cela peut vous aider à trouver une nouvelle voie.
