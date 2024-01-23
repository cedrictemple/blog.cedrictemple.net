---
layout: post
title: "Bases sur la virtualisation"
date: 2024-02-01 08:10:00
description: Bases sur la virtualisation
category: 'Formation VirtualBox'
introduction: ''
collection: formation-virtualbox
permalink: /formations/VirtualBox/bases-sur-la-virtualisation/
toc: true
tags:
- Formations
- VirtualBox
- administration système
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Introduction
Si vous ne l'avez pas déjà fait, je vous invite très fortement à consulter le premier article sur [notre formation VirtualBox](/formations/VirtualBox/introduction-a-son-utilisation-pour-un-etudiant-ou-un-professionnel-de-linformatique/). Nous rentrons maintenant dans le vif du sujet sur cette formation en présentant succinctement ce qu'est la virtualisation.

## Définition de la virtualisation
La virtualisation est un outil logiciel permettant de simuler un serveur matériel sur un système d'exploitation préalablement installé. L'objectif est de lancer un système d’exploitation qu'on appelle _"système invité"_ sur un autre système d’exploitation, nommé _"système hôte"_.

## Exemple pratique

![Schéma sur la virtualisation représentant les différentes couches techniques (matériel, système d'exploitation/système hôte, logiciel de virtualisation, machines virtuelles](/static/img/base-virtualisation.jpg "Schéma sur la virtualisation")

Prenons un exemple pour simplifier et éclairer le propos. J'ai un ordinateur portable. Sur mon ordinateur portable, je suis sous GNU/Linux car j’apprécie beaucoup GNU/Linux, je travaille toujours dessus. C’est mon système d’utilisation courant. Dans mon ordinateur portable, il y a des composants matériels (CPU, RAM, disque dur, interface réseau). Et ces composants sont gérés par un système d'exploitation GNU/Linux, une distribution GNU/Linux KDE Neon pour être précis. Grâce à la virtualisation, je peux installer un deuxième système d'exploitation comme par exemple Windows ! Ou une autre distribution GNU/Linux. Voire un système BSD.

La virtualisation, c’est ça : pouvoir lancer un deuxième système d’exploitation au-dessus d’un système d’exploitation préalablement installé. Qu'est ce que cela signifie concrètement ? Lorsque je démarre mon ordinateur portable, parce que j'ai installé Kde Neon dessus, c'est ce _"système hôte"_ qui démarre. Puis, après, j'ai installé un logiciel de virtualisation, dans mon cas VirtualBox, qui me permet d'installer un autre _"système invité"_ comme Windows ou un autre Linux.

**Remarque** : le système d’exploitation invité est aussi appelé _"machine virtuelle"_.

Il est à noter que l’on peut lancer plusieurs systèmes invités en même temps, donc plusieurs machines virtuelles en même temps. Cela nécessite plus de ressources matérielles car chaque machine virtuelle, chaque _système invité_ nécessitera une partie de la mémoire, une partie du disque dur, une partie du temps CPUs pour s'exécuter.

## NE PAS confondre avec le dual boot
Il ne faut pas confondre _virtualisation_ et _dual boot_ (ou _double boot_). Le dual boot permet d’installer 2 systèmes d’exploitation sur une machine. MAIS les 2 systèmes d’exploitation ne peuvent pas être utilisés en même temps. Soit j’utilise le premier, soit le deuxième mais pas les 2 en même temps. Alors que pour la virtualisation, je peux lancer plusieurs systèmes d’exploitation en même temps : le système hôte et plusieurs systèmes invités/le système hôte et plusieurs machines virtuelles. Tous ces systèmes d'exploitation s'exécutent en même temps. Si j'ai un gros serveur physique, disposant de beaucoup de mémoire vive, de beaucoup de CPUs, de beaucoup d'espace disque, je pourrais lancer par exemple 50 machines virtuelles en même temps. On aurait alors 5**1** systèmes d'exploitation qui fonctionneraient en même temps : les 50 machines virtuelles et le système hôte.

## Logiciel de virtualisation ou émulateur
Pour lancer un 2e système d’exploitation, il vous faut un _outil de virtualisation_. Cet outil est nommé généralement _outil de virtualisation_ mais dans il peut aussi être nommé _émulateur_. On parle d’émulateur car le logiciel de virtualisation émule un système matériel pour le système d’exploitation invité. C’est à dire qu’il fait croire au système d’exploitation invité qu’il se lance sur un matériel même si ce n’est pas le cas.
C’est pour cela qu’on utilise le terme “machine virtuelle” : la machine n’existe pas physiquement mais virtuellement.

## Isolation
Lorsqu’on lance un 2e système d’exploitation, le logiciel de virtualisation permet d’**isoler** le système invité du système hôte. Prenons un cas pratique. J’ai sur ma machine 16Go de RAM, 4 coeurs de CPU et 1To de disque. Je vais créer une machine virtuelle mais je vais limiter ses ressources. En effet, je ne veux pas que, par exemple, ma machine virtuelle utilise toute la mémoire vive, je vais donc la contraindre à 4Go de RAM. Je vais la contraindre à 1 utiliser un seul coeur de CPU et uniquement 15Go sur le disque physique. Pour cela, je vais indiquer au logiciel de virtualisation (à l’émulateur) de limiter les ressources de ma machine virtuelle. L’outil de virtualisation me permet de limiter les ressources de ma machine virtuelle.

L'isolation est aussi liée à la sécurité : les systèmes invités ne peuvent pas écrire leurs données n'importe où sur le disque, ils ne peuvent pas accéder aux zones mémoires des autres machines virtuelles, ni du système hôte, ils ne peuvent pas voir ou arrêter les processus d'un autre système (invité comme hôte), ils ne peuvent pas récupérer le trafic réseau des autres systèmes. L'isolation du logiciel de virtualisation interdit, par défaut, toute communication entre les systèmes invités. Bien entendu, pour des raisons spécifiques, on peut vouloir qu'au contraire deux systèmes invités communiquent ensemble, il faut alors configurer l'outil de virtualisation pour cela.

## Virtualisation du réseau
La virtualisation du réseau permet de créer des réseaux dits _réseaux virtuels_ : ces réseaux n'ont pas d'existence physique mais une existence logicielle. C'est à dire que l'on peut créer un réseau, généralement dans le logiciel de virtualisation, pour que nos machines virtuelles puissent soit se contacter, soit au contraire être isolées les unes des autres. Ces réseaux virtuels n'ont pas d'existence en dehors de l'outil de virtualisation et du système invité : il n'y a pas de câble, les autres ordinateurs portables connectés sur le même switch que le mien sont incapables de les connaître.

VirtualBox nous permet de créer des réseaux virtuels. Nous verrons pourquoi en créer et comment les utiliser.

## Virtualisation du stockage
On parle également de _virtualisation du stockage_. Ce sujet, bien que très intéressant, ne fait pas partie du périmètre de cette formation. En effet, la virtualisation du stockage est utilisée dans le cadre de la virtualisation de serveurs, pas dans le cadre de la virtualisation du poste de travail.





Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
