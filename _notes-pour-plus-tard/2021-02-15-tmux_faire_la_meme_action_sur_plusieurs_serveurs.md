---
layout: post
title: "tmux, faire la même action sur plusieurs serveurs"
date: 2021-02-15 07:50:00
description: tmux
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/tmux-faire-la-meme-action-sur-plusieurs-serveurs/
toc: true
tags:
- notes pour plus tard
- tmux
---

## Présentation de tmux
Tmux est présenté dans un article dédié : [tmux, points à retenir](/notes-pour-plus-tard/tmux-points-a-retenir/)

## Tmux et les panes
Tmux permet de définir des fenêtres (*"window"* dans la terminologie Tmux) et des panneaux (*"pane"* dans la terminologie Tmux). Les fenêtres contiennent un ou plusieurs panneau(x). Il est possible de créer une fenêtre avec un seul panneau et une autre fenêtre avec plusieurs panneaux. On peut alors se déplacer de fenêtre en fenêtre et de panneaux en panneaux à l'intérieur d'une fenêtre.

La différence entre un panneau et une fenêtre tient à la visibilité : lorsque vous êtes sur une fenêtre, vous ne voyez pas les autres fenêtres. Par contre, vous voyez tous les panneaux de cette fenêtre.

Il y a un cas d'usage que j'aime beaucoup : faire une action (ou une série d'actions) sur plusieurs serveurs en même temps.


## Faire une série d'actions sur différents serveurs
Oui, bien sûr, c'est mieux d'utiliser Ansible, Puppet, CFEngine, Rudder, ... Vous avez raison, c'est toujours mieux : c'est plus propre, c'est efficace, c'est plus maintenable, blablabla. Mais je ne parle pas de ces cas-là, où il serait mieux de faire une action qui doit être pérenne, grâce à un outil dédié, complexe à utiliser, avec un fichier de configuration YAML, dans un module dédié, ayant une arboresence spécifique, un nom spécifique, des fichiers spécifiques, sur un repo GIT dédié, ... Non, je parle de faire un *one-shot*.

Par exemple :
* se connecter à 4 serveurs
* ouvrir le même fichier de configuration sur ces 4 serveurs et regarder visuellement s'il y a une différence
* installer le même paquet sur ces 4 serveurs
* lancer le même programme au même moment et suivre le déroulement

L'idée est vraiment de synchroniser les actions : lorsque je tape une commande, elle est envoyée en simultanée aux 4 serveurs. De même, je peux voir en direct l'exécution sur les 4 serveurs.

## Déroulement
Le déroulement est simple :
1. lancer tmux
2. se connecter en SSH au 1er serveur
3. séparer l'écran en deux (horizontalement d'abord pour l'exemple) en créant un 2e panneau
4. aller sur le nouveau panneau
5. se connecter en SSH au 2e serveur
6. séparer l'écran en deux (verticalement maintenant) en créant un 3e panneau
5. aller sur le nouveau panneau et se connecter en SSH au 3e serveur
7. revenir sur le tout premier panneau
8. séparer l'écran en deux (verticalement maintenant) en créant un 4e panneau
9. aller sur le nouveau panneau et se connecter en SSH au 4e serveur
10. synchroniser les entrées : toute commande taper dans un des quatre panneaux sera automatiquement envoyées sur les 3 autres
11. regarder les résultats des actions
12. continuer son travail
13. lorsque cela est nécessaire, on désynchronise les panneaux pour exécuter une commande sur le seul panneau concerné
14. on peut resynchroniser ou désynchroniser les panneaux dès qu'on le veut

Le *"truc"* en plus : à chaque fois que l'on synchronise les panneaux, je conseille d'effacer tous les écrans (commande `clear`) afin de repartir d'un écran identique partout.

## Commandes/suite de touches
Attention, j'ai organisé les combinaisons de touches différemment de la configuration par défaut. Cela me permet d'être plus efficace mais c'est une configuration qui m'appartient (dans le sens *"qui me convient personnellement"*). Il est possible que vous trouviez d'autres combinaisons de touches sur d'autres sites.

* `C-a v` : séparer la fenêtre **v**erticalement (on aura donc deux panneaux, un à gauche et un à droite)
* `C-a h` : séparer la fenêtre **h**orizontalement (on aura donc deux panneaux, un en haut et un en bas)
* `C-a flèches du clavier` : pour se déplacer vers le panneau du haut, du bas, de gauche ou de droite
* `C-a : set-window-option synchronize-panes on` : pour synchroniser les entrées : lorsque je tape des commandes, elles sont tapées dans tous les panneaux de ma fenêtre
* `C-a : set-window-option synchronize-panes off` : pour désynchroniser les entrées et revenir à l'état normal.

