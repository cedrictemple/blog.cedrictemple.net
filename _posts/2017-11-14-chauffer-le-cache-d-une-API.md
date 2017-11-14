---
layout: post
title: "Chauffer le cache d'une API : une méthode"
date: 2017-11-06 07:48:00
description: Chauffer le cache d'une API afin d'éviter des lenteurs (une méthode)
image: /assets/img/format_json.jpg
category: 'automatisation du SI'
twitter_text: Chauffer le cache d'une API afin d'éviter des lenteurs (une méthode)
introduction: Pré-calculons les résultats !
tags:
- automatisation du SI
- API
---

## Quand l'API coince
Nous disposons d'une API web et plus de 60 publications en ligne utilisant cette API. Lorsqu'un visiteur se rend sur l'une de ses publications, des requêtes sont faites à l'API. Certaines de ces requêtes sur certaines de ses publications sont... comment pourrait-on dire cela poliment ? Excessivement lentes : 14 secondes juste pour récupérer les données. Reste ensuite à calculer le rendu graphique... Même si les utilisateurs sont des *"professionnels"* (par opposition au *"grand public"* ), même si cela concerne certaines requêtes seulement, même sur seulement 2 publications sur les 60, cela reste beaucoup beaucoup beaucoup trop lent.

Un constat : les données ne sont pas spécifiques à l'utilisateur. Les données sont différentes selon la requête (logique !) mais elles sont identiques quel que soit l'utilisateur qui la fait. Ces données changent peu souvent ou de manière contrôlée : l' *admin. sys.* sait **exactement** quand elles seront différentes. Ce qui veut dire qu'on peut mettre en place un cache de ces données et purger le cache lors d'une mise à jour de ces données. Le fonctionnement du cache est le suivant :
1. l'API calcule le résultat d'une requête pour le premier utilisateur demandant spécifiquement celle-ci : le calcul prend 14 secondes ; 
2. les résultats de cette requête sont conservés dans un cache ; 
3. lorsqu'un autre utilisateur fait exactement la même requête, le résultat est récupéré dans le cache et lui est fourni immédiatement (quelques milli-secondes suffisent).

Dès lors, seul le premier utilisateur est touché par la lenteur de ces requêtes. Le fait qu'il y ait beaucoup d'utilisateurs fait converger rapidement vers 1 la probabilité d'avoir le résultat d'une requête stockée dans le cache...

Enfin, en théorie ! En pratique, on se rend compte que ce n'est pas le cas. Dès qu'une requête dépasse 4 secondes, un utilisateur se plaint ( *"c'est lent ! "* ) et ne revient que si vous lui avez indiqué que le problème est réglé.

Une solution s'impose alors, *"chauffer le cache"* : interroger l'API pour que le cache soit rempli **avant** que les utilisateurs ne se rendent sur les publications concernées. Là, encore une fois, l'important n'est pas le code ni le langage ni l'outil utilisé mais... **la méthode** .

## Identification des données à mettre en cache
Tout d'abord, il est très important de faire une analyse de notre API :
* quelles sont les requêtes ?
* comment sont-elles structurées ?
* quelles sont celles qui doivent être mises en cache ? Pourquoi ?
  * quelles sont celles qui ne sont pas spécifiques à un utilisateur ?
  * quelles sont celles qui sont très régulièrement utilisées ?
  * quelles sont celles qui bloquent l'utilisateur ?
  * y-a-t'il des règles globales qui simplifient la configuration (exemple : /user/.* ne doit pas être mis en cache mais /data/.* doit être mis en cache) ?
* doit-on permettre au navigateur de *bypasser* le cache ? En fonction de quoi (CTRL+F5 ou un paramètre dans la requête ou un cookie d'authentification ou ... ) ?
* quelle durée de mise en cache ?
* quand effacer le cache ? Par conséquence, quand chauffer le cache ?
* quel est l'impact sur les utilisateurs lorsque le cache est effacé ?
* quel est l'impact sur les utilisateurs lorsque le cache est chauffé ?
* quelle sera la taille du cache une fois qu'il sera rempli ?

Avec les réponses à ces questions, on peut identifier une configuration efficace et pertinente du cache.

## Régler les problèmes intermédiaires
Après avoir mis en place la configuration, on se rend compte de problèmes. On a beau avoir chauffé le cache, l'application reste très lente même sur les données théoriquement mise en cache. Aprè-s analyse on constate deux types de problème :
* les données ne sont pas mises en cache
* les données en cache ne sont pas utilisées, la requête est systématiquement transmise à l'API

Deux types de problème donc, mais qui ont la même source : les *headers HTTP* sont mal définis par le serveur d'API. Celui-ci indique, par l'intermédiaires de *header*, de ne pas mettre en cache les données, que celles-ci sont spécifiques à un utilisateur, que les données ne doivent pas être mises en cache plus de 3 heures, ... Après réflexion, on se rend compte que rien n'a été fait dans les règles et qu'il faut tout revoirsur le serveur d'API. Ce qui va prendre du temps. Or, la présentation-ultra-importante-de-la-vie-de-l-entreprise est prévue la semaine prochaine et les développeurs sont déjà en retard sur beaucoup trop de points.

La solution mise en place est extrème : le cache ignore complètement les *headers HTTP* définis par l'API pour gérer le cache. Le cache supprime ces *headers* et les ré-écrit à la volée.

## Automatisons (encore et toujours)
Une fois la configuration définie, testée et validée sur une plate-forme de pré-production, il faut la déployer en production. Là, selon le nombre de sites web, il peut être intéressant d'industrialiser. Dans notre cas, nous avons +60 publications à maintenir, nous en ajoutons régulièrement et il y a des exceptions sur certaines publications. Nous ne pouvons donc pas faire une configuration globale facilement maintenable et lisible. Nous sommes partis sur une approche différente :
* chaque publication est disponible dans l'API
* nous avons le moyen de détecter les exceptions et de générer la configuration correspondante
* la configuration est simple à générer
* nous savons détecter automatiquement les changements/mises à jour nécessitant une mise à jour de la configuration du cache

Nous avons donc mis en place un processus qui détecte quand il doit se lancer, utilise un modèle de configuration, traite les exceptions et génère la configuration adéquate. Donc tout se fait automatiquement, sans action humaine.

Enfin et évidemment (même si c'est toujours bien de le préciser), le script qui chauffe le cache est utilisé dans une tâche Jenkins et est lancé tous les jours. Nous ciblons les publications le nécessitant. Nous parallélisons selon l'environnement (PROD et STAGING) mais nous sérialisons pour les publications. Si nous avons 4 publications pour lesquelles le cache est chauffé, alors le script est lancé 2 fois en parallèle et 8 fois au total.

## Régler la source des problèmes
Ce n'est pas idéal : nous avons contourné des problèmes sans les régler définitivement. Ce n'est pas grave, au contraire : c'est notre travail de trouver des solutions inventives. Cependant, il ne faut pas oublier de régler définivement ces problèmes :
1. faire modifier l'API pour que celle-ci définisse les bons *headers* HTTP au bon moment
2. régler les problèmes de performance en optimisant l'indexation d'ElasticSearch et les requêtes effectuées par l'API et monter un cluster ElasticSearch efficace

Cela se fera tranquillement, dans les prochaines versions de l'API, en définissant les priorités. Avoir mis en place un cache des données permet de gagner du temps pour mettre en place les bonnes actions qui règleront définivement les problèmes.


