---
layout: post
title: "Cas d'utilisation de la virtualisation sur le poste utilisateur"
date: 2024-03-01 08:10:00
description: "Cas d'utilisation de la virtualisation sur le poste utilisateur"
category: 'Formation VirtualBox'
introduction: ''
collection: formation-virtualbox
permalink: /formations/VirtualBox/cas-d-utilisation-de-la-virtualisation-sur-le-poste-utilisateur/
toc: true
tags:
- Formations
- VirtualBox
- administration système
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Introduction
Si vous ne l'avez pas déjà fait, je vous invite très fortement à consulter le premier article sur [notre formation VirtualBox](/formations/VirtualBox/introduction-a-son-utilisation-pour-un-etudiant-ou-un-professionnel-de-linformatique/) et celui sur [l'introduction à la supervision](/formations/VirtualBox/bases-sur-la-virtualisation/). Dans ce nouvel article, nous aborderons les raisons qui poussent à l'utilisation de la virtualisation sur un poste utilisateur.

## Virtualisation sur le poste utilisateur vs. virtualisation sur un serveur
La virtualisation sur un serveur est la virtualisation la plus courante : un serveur dispose de beaucoup de ressources physiques et le service informatique d'une entreprise va vouloir rentabiliser ces ressources. La virtulisation permet cela : les administrateurs du SI vont créer les machines virtuelles et leur allouer les ressources pour maximiser la rentabilité sans dégrader trop négativement les performances. L'avantage de la virtualisation, en dehors de l'optimisation de l'utilisation des ressources, est la centralisation de la gestion de cette virtualisation par une équipe dédiée. Avec le temps, l'équipe monte en compétences ; avec la maturité, elle fait évoluer l'environnement de virtualisation pour la faire correspondre le plus possible aux besoins de la structure.

Le désavantage de cela est qu'il est généralement nécessaire que les administrateurs interviennent pour la création, la suppression, le démarrage et l'arrêt des machines virtuelles. Si l'on doit passer par un outil de _ticketting_, on perd en dynamisme et en souplesse. Même si l'on peut déléguer des droits à certains groupes d'utilisateurs, cette gestion des droits reste complexe et un peu limité. De même, les serveurs de virtualisation de test ou de préproduction ouverts à de nombreux utilisateurs, ils sont généralement saturés car beaucoup de machines virtuelles sont créées mais peu sont supprimées. La sauvegarde n'est pas faite et les _snapshots_ dégradent les performances des autres utilisateurs. Les utilisateurs sont alors frustrés de ne pas pouvoir intervenir comme ils le souhaiteraient, de perdre du temps, de ne pas pouvoir agir.

La virtualisation sur le poste utilisateur permet à l'utilisateur de répondre à ces problèmes : il peut intervenir autant qu'il le souhaite sur ses machines virtuelles sans demander aux administrateurs systèmes. Il peut créer autant de machines virtuelles que sa machine le lui permet. Il peut les supprimer rapidement. Il peut les allumer et les éteindre comme il le souhaite. D'ailleurs, l'utilisateur sera plus enclin à éteindre ses machines virtuelles sur son poste car s'il en allume trop, la dégradation des performances de son poste va le gêner beaucoup plus que sur un serveur.

Le risque d'autoriser, pour une entreprise, la virtualisation sur le poste utilisateur est un risque sécuritaire : en permettant d'installer une machine virtuelle sur un poste, on permet à l'utilisateur de se débarraser de certaines barrières de sécurité. Pas de toutes, mais d'une partie au moins. Dans le cas d'une attaque APT ou d'une négligence de la part de l'utilisateur, les dégâts peuvent être plus importants. C'est un risque qu'il faut connaître et qu'il faut adresser par les mesures adéquates (sensibilisation à la sécurité, surveillance constante du réseau, amélioration des barrières intermédiaires, ...).

### Virtualisation sur le poste de travail vs. virtualisation du poste de travail
Il ne faut pas confondre les deux notions, qui sont vraiment différentes :
* virtualisation sur le poste de travail : l'utilisateur du poste de travail peut créer des machines virtuelles sur son propre poste, il peut les lancer et les supprimer
* virtualisation du poste de travail : là, c'est le poste de travail de l'utilisateur qui est une machine virtuelle. L'utilisateur accède à son poste de travail au travers d'un accès réseau, un navigateur web ou une application dédiée. Le poste qui se trouve devant lui ne stocke aucune donnée, toutes les données sont stockées sur un serveur.

### Points forts et points faibles de la virtualisation sur le poste utilisateur
Les points forts de la virtualisation sur le poste utilisateur sont :

1. l'autonomisation des utilisateurs et la libération de temps pour l'équipe d'administration du SI : les utilisateurs peuvent créer leurs machines virtuelles quand et comme ils le souhaitent, ils peuvent les effacer, les réinstaller, les mettre à jour, changer la version de l'OS, faire des tests poussés au risque de les "casser" sans se dire _"si je me loupe et que je dois réinstaller, je devrais faire appel à l'équipe d'administrateurs"_
2. réduire les investissements matériels en serveur : il n'est pas nécessaire d'acheter des serveurs pour que nos utilisateurs puissent faire leurs tests, vu qu'ils peuvent le faire directement sur leur machine
3. ne pas avoir à gérer la saturation des serveurs de tests : dans le cas où on dispose de serveurs de virtualisation de tests, les utilisateurs ont tendance à les sur-utiliser ([loi des gaz](https://fr.wikipedia.org/wiki/Loi_de_Parkinson#G%C3%A9n%C3%A9ralisation_de_la_loi_des_gaz)), ils créent autant de machines virtuelles que possible, ils leur attribuent plus de ressources que nécessaire, ils ne les éteignent pas et ils ne les suppriment pas. Il faut alors mettre en place des règles de gestion, les formuler, les documenter, les expliquer, contrpôler qu'elles sont suivies (et constater qu'elles ne le sont pas), les rappeler et forcer les utilisateurs à les respecter, jusqu'à aboutir à des processus de suppression ou d'extinction automatisés et arbitraires. Dans certains cas, des serveurs de test deviennent des serveurs de _"quasi production mais qu'on ne veut pas vraiment mettre en production mais qu'on utilise comme en production parce que... flemme !"_. Lorsque ceux-ci sont supprimés, on aboutit à, sinon une catastrophe, au moins une perte de temps et, donc, d'argent.

Les points faibles de la virtualisation sur le poste utilisateur :
1. déjà abordé auparavant, le possible contournement des règles de sécurité : un utilisateur négligent voire mal intentionné pourrait installer une machine virtuelle afin de contourner des règles de sécurité l'empêchant de faire une action dangereuse pour la sécurité du système d'information.
2. l'augmentation du budget matériel pour les postes utilisateurs : les postes utilisateurs devant exécuter un outil de virtualisation doivent être plus puissants et doivent disposer de plus de mémoire vive et d'espace disque. Cependant, ce surcoût est compensé par la diminution du budget côté serveurs.
3. la non maîtrise des machines virtuelles par les administrateurs du SI.

### Cas d'utilisation de la virtualisation du poste utilisateur
Les cas d'utilisation de la virtualisation du poste utilisateur sont :
* pour l'étudiant :
  * faire des travaux pratiques sur un véritable environnement cible
  * faire des tests poussés, sans risquer de casser son environnement de travail principal
  * en gérant correctement la sauvegarde et les snapshots, à prendre beaucoup de risques pour faire ses tests, sans avoir peur de perdre beaucoup trop de temps à réinstaller une machine
  * en utilisant correctement les images ou les sauvegardes (voire la ligne de commande), à accélérer l'installation d'une machine virtuelle type
  * à être libre de choisir son environnent de travail principal (le système hôte), comme il le souhaite (Windows, Mac OS, Linux) et de pouvoir disposer d'un environnement dédié à chaque cours (certains cours nécessitent une version précise de Linux, d'autres sont sur un BSD, d'autres sont sur Windows)
* pour le professeur :
  * à demander une version spécifique de l'OS sur lequel les étudiants doivent travailler : le cours devient alors plus simple à produire, les TPs sont plus faciles à écrire, à suivre par les étudiants et à corriger par le professeur
  * à demander la fourniture de l'image de la machine virtuelle, pour corriger ou voir ce qui a été fait par l'étudiant, vérifier qu'il n'a pas copié sur un autre
* pour le professionnel :
  * complèter son environnement de travail. Exemple : pour créer votre _reporting_, vous êtes habitué à certains outils, à une base de données spécifique, ... Faire une machine virtuelle pour votre cas d'usage peut vous faciliter la vie
  * créer ses propres machines virtuelles, selon ses pré-requis
  * reproduire des environnements clients : version d'OS, nombre de machines virtuelles, version d'application
  * faire plein de tests sans risquer de casser quelque chose utilisé par quelqu'un d'autre


Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
