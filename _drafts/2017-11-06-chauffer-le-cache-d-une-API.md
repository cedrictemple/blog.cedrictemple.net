---
layout: post
title: "Chauffer le cache d'une API"
date: 2017-11-06 07:48:00
description: Chauffer le cache d'une API afin d'éviter des lenteurs
image: /assets/img/...
category: 'automatisation du SI'
twitter_text: Chauffer le cache d'une API afin d'éviter des lenteurs
introduction: Pré-calculons les résultats !
tags:
- automatisation du SI
- API
---

# Quand l'API coince
Nous disposons d'une API web et plus de 60 publications en ligne utilisant cette API. Lorsqu'un visiteur se rend sur l'une de ses publications, des requêtes sont faites à l'API. Certaines de ces requêtes sur certaines de ses publications sont... comment pourrait-on dire cela poliment ? Excessivement lentes : 14 secondes juste pour récupérer les données. Reste ensuite à calculer le rendu graphique... Même si les utilisateurs sont des *"professionnels"* (par opposition au *"grand public"* ), même si cela concerne certaines requêtes seulement, même sur seulement 2 publications sur les 60, cela reste beaucoup beaucoup beaucoup trop lent.

Un constat : les données ne sont pas spécifiques à l'utilisateur. Les données sont différentes selon la requête (logique !) mais elles sont identiques quel que soit l'utilisateur qui la fait. Ces données changent peu souvent ou de manière contrôlée : l' *admin. sys.* sait **exactement** quand elles seront différentes. Ce qui veut dire qu'on peut mettre en place un cache de ces données et purger le cache lors d'une mise à jour de ces données. Le fonctionnement du cache est le suivant :
1. l'API calcule le résultat d'une requête pour le premier utilisateur demandant spécifiquement celle-ci : le calcul prend 14 secondes ; 
2. les résultats de cette requête sont conservés dans un cache ; 
3. lorsqu'un autre utilisateur fait exactement la même requête, le résultat est récupéré dans le cache et lui est fourni immédiatement (quelques milli-secondes suffisent).

Dès lors, seul le premier utilisateur est touché par la lenteur de ces requêtes. Le fait qu'il y ait beaucoup d'utilisateurs fait converger rapidement vers 1 la probabilité d'avoir le résultat d'une requête stockée dans le cache...

Enfin, en théorie ! En pratique, on se rend compte que ce n'est pas le cas. Dès qu'une requête dépasse 4 secondes, un utilisateur se plaint ( *"c'est lent ! "* ) et ne revient que si vous lui avez indiqué que le problème est réglé.

Une solution s'impose alors, *"chauffer le cache"* : interroger l'API pour que le cache soit rempli **avant** que les utilisateurs ne se rendent sur les publications concernées. Là, encore une fois, l'important n'est pas le code ni le langage ni l'outil utilisé mais... **la méthode** .

# Identification des données à mettre en cache
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

# Automatisons (encore et toujours)
Une fois la configuration définie, testée et validée sur une plate-forme de pré-production, il faut la déployer en production. Là, selon le nombre de cas, il peut être intéressant d'industrialiser. Dans notre cas, nous avons +60 publications à maintenir, nous en ajoutons régulièrement et il y a des exceptions sur certaines publications. Nous ne pouvons donc pas faire une configuration globale.

# Régler les problèmes intermédiaires

# Régler la source des problèmes


PAS de # TITRE 1 car il est déjà récupéré par title dans YML
## Titre 2
### Titre 3
#### Titre 4

`code en ligne dans le texte`

    code de type listing (tabulation ou 4 espaces)

Images : 
![titre alt](https://placehold.it/800x400 "Large example image")
![titre alt](https://placehold.it/400x200 "Medium example image")
![titre alt](https://placehold.it/200x200 "Small example image")
    

- **bold text**
- *italicize text*
> Citation

[Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).

* liste non ordonnée
* liste non ordonnée

1. liste ordonnée
2. liste ordonnée
3. liste ordonnée



