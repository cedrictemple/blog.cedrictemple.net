---
layout: post
title: "Valider les évolutions d'une API JSON"
date: 2015-02-12 12:26:40
image: /assets/img/format_json.jpg
description: Une méthode pour valider les évolutions d'une API JSON
category: 'administration système'
tags:
- administration système
- JSON
- API
twitter_text: Une méthode pour valider les évolutions d'une API JSON
introduction: Il est nécessaire de s'assurer que la nouvelle version d'une API JSON ne va pas casser les logiciels l'utilisant. Voici une méthode.
---

Vous exposez des données au format JSON au travers d’une API. Cette API est utilisée par d’autres personnes extérieures à votre structure. Vous êtes responsables des informations fournies à ces personnes extérieures, vous devez les assister lors de leur première utilisation en répondant à leurs questions mais aussi lors des mises à jour. Bien entendu, la documentation de l’API a été demandée aux développeurs de cette API! Évidemment, cette documentation semble avoir été faite! Assurément, la liste des différences entre l’ancienne version et la nouvelle version est détaillée! Incontestablement, cette liste de différences est complète, claire et exhaustive! Il n’y a donc aucun problème! Jamais! D’ailleurs, aucune modification n’est faite dans l’API entre les versions mineures. D’autre part, le projet n’est jamais en retard et la livraison est faite systématiquement 2 semaines avant la mise en production afin de vous donner le temps de tout vérifier. Durant cette phase de vérification, vous n’êtes jamais perturbé par d’autres tâches annexes. Vous n’avez jamais constaté un bug imposant une nouvelle livraison, afin changement de cette API, dans une partie non prévue. Si vous ne connaissez pas ce monde de bisounours (si vous le connaissez, dites-moi afin que j’y émigre sans délai), il vous faut valider et vérifier chaque point. Ce qui peut être long lorsque ces modifications sont au nombre de 285. Comment automatiser un peu la vérification et avoir une liste synthétique des différences? Comment être plus efficace pour vérifier une API fournissant des données au format JSON? C’est ce que nous allons voir ici.

## La réponse des développeurs

Lorsque l’on soumet ce type de problématique à des développeurs, ils vous une solution proche de celle-ci :

> Il nous suffit de définir l’API dans un méta-langage pseudo-déclaratif. La documentation de cette API est incluse dans cette déclaration. À chaque changement, il est obligatoire de modifier cette définition ainsi que la documentation associée. Par la suite, nous allons développer un moteur qui prend en entrée cette déclaration et crée la liste des objets/fonctions/procédures/… dans notre langage cible de développement. La documentation est mise à jour durant cette phase.

Si vous êtes comme moi, dès le début vous êtes saisi d’un tic corporel. J’ai synthétisé les échanges mais en général, ce type de demande aboutit à d’intenses discussions, très longues, durant lesquelles l’intégralité des feuilles sur le paperboard aura été griffonnée, des mots savants auront été utilisés comme « réflexivité du langage », « auto-génération de code », « validation multi-parts », « pseudo-langage méta-déclaratif ou méta-langage pseudo-déclaratif ??? non, faudrait vérifier cette partie, c’est vraiment important pour choisir le bon outil d’auto-génération de code ». Moi, mon tic corporel est de saisir mon sourcil de réflexion. J’ai un petit côté Emmanuel Chain que je ne renie pas et que j’ai décidé d’utiliser comme une force. Saisir ce sourcil de réflexion me permet de me concentrer. Ou peut-être est-ce le contraire : je me saisis de ce sourcil de réflexion car je me concentre très fortement. Bref! Faites attention, vous pourriez aussi entendre les mots « novateur », « génial! », « révolutionnaire! », « grand avenir » ou « hyper vendeur ».

Une fois cette discussion bien avancée, lorsque tout le monde a perdu son énergie créative, vous pouvez poser une question : « mais pour le suivi des mises à jour de l’API… je n’ai pas bien compris… c’est fait comment exactement? ». Là, les regards changent. Certains perdent l’étincelle hyper-créatrice dans leur yeux, saisis par les premières difficultés. D’autres regards se baissent sur leurs feuilles. D’autres, encore, regardent pendant plusieurs minutes le dernier schéma griffonné sur le paperboard en espérant y trouver l’inspiration divine. D’autres enfin vous dévisagent en se demandant pourquoi vous cassez tous leurs rêves d’innovation, de gloire et de succès. Si vous ajoutez : « non… parce que c’est quand même le but premier quoi… » alors vous devenez une cible pour toutes les prochaines réunions. Enfin, après cet inévitable blanc de quelques minutes, blanc durant lequel vous entendrez les plantes respirer, les arbres pousser et la poussière tomber sur la moquette, vous pourrez achever la discussion par un : « et… comment vous allez gérer le fait que les fonctions étaient déjà écrites dans la version 1.1.1 et qu’une simple mise à jour de la documentation pour la version 1.1.2 (par exemple) ne doit pas écraser le code inclus dans ses fonctions? »

## La réponse de l’administrateur

La réponse de l’administrateur repose sur des… outils d’administrateurs : Perl (ou Python si vous êtes du côté obscur de la Force), bash, diff et l’outil en ligne de commande Trentm/json. J’eusse aimé (oui, oui, oui… j’utilise le conditionnel passé deuxième forme si je veux) vous montrer le code. C’était mon objectif initial. Cependant, j’ai tellement honte de celui-ci que cela m’est impossible. Je vais donc vous présenter ce qui est fait.

Les principes généraux sont les suivants :
1. créer un répertoire par numéro de version. Exemples :
   * v1.0/
   * v1.1/
   * v1.2/
   * v2.0/
   * …
2. on lance un script qui fournit un résultat au format texte (détaillé ci-après). Le texte est stocké dans le répertoire correspondant au numéro de version.
3. le script est lancé avec en argument le endpoint de l’API (oui, j’utilise des termes de développeur si je veux). S’il y a plusieurs endpoints, appeler le script sur chacun d’eux et stocker le résultat dans un fichier. Conserver un nom de fichier suffisamment simple et suffisamment significatif pour identifier de manière unique le endpoint. Conserver les noms de fichier identique entre les numéros de version, pour des endpoints identiques.
4. un parcours arborescent est fait pour chaque endpoint : pour chaque niveau : 
5. afficher la clé et uniquement la clé. La clé est affichée de la façon suivante :
> clé1erNiveau . clé2eNiveau . clé3eNiveau .
   * ici les espaces sont ajoutés pour faciliter la lecture, mais ils ne doivent pas être affichés dans le script.
6. si la valeur associée à la clé est un tableau, itérer sur chaque objet du tableau. Dites merci à la personne qui a inventé la récursivité.
7. si la valeur associée à la clé est un objet (table de hachage), itérer sur chaque partie de l’objet. Dites encore merci à la personne qui a inventé la récursivité.
8. si la valeur associée à la clé est un scalaire, ne pas afficher cette valeur : cette valeur pouvant être modifiée selon la date à laquelle on fait la requête, il n’est pas nécessaire de la stocker. Elle nous perturberait dans le futur.

La première partie est terminée. Vous avez un premier résultat. Conserver-le. Vous avez donc :
* un répertoire pour la version v1.0 de l’API avec à l’intérieur
  * un fichier par endpoint contenant la liste de toutes les clés
* un répertoire pour la version v1.1 de l’API avec à l’intérieur
  * un fichier par endpoint contenant la liste de toutes les clés

Il vous suffit de sortir l’outil magique diff qui va vous permettre de comparer chaque fichier de chaque répertoire. Magique! Il vous reste à identifier les différences et les documenter dans le changelog. Cette étape est forcément manuelle. En réalité, elle pourrait être automatisée du début (appel du script sur chaque endpoint) à la fin (diff récursif) mais je souhaite le faire à la main pour le moment. Cela me permet de travailler fichier par fichier, de le faire étape par étape (au fur et à mesure de la semaine), d’analyser finement les différences et d’expliquer concrètement dans la documentation ces différences.

Le plus complexe est le script qui génère le fichier. Il est très très très moche chez moi :

  * le script s’appelle test.pl
  * il n’y a aucun commentaire
  * les variables se nomment $toto, $scalaire, @tableau, %hash
  * la fonction récursive se nomme… fonction
  * les performances sont … heu… « à chier ». Vraiment : plusieurs secondes pour un tout petit fichier JSON.

J’en ai vraiment honte. Il est nécessaire que je le nettoie avant d’en faire quelque chose. Mais, pour le moment, il fait le boulot.

