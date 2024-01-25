---
layout: post
title: "SNMPB : faire des requêtes SNMP avec un outil graphique"
date: 2013-04-06 12:26:40
image: /assets/img/snmpb.png
description: SNMPB faire des requêtes SNMP avec un outil graphique
category: 'SNMP'
tags:
- administration système
- SNMP
twitter_text: SNMPB faire des requêtes SNMP avec un outil graphique
introduction: La ligne de commande, c'est bien, mais SNMP est plus simple avec un outil graphique !
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

Dans cette vidéo je vais vous présenter un outil graphique pour réaliser des requêtes SNMP. Le nom de cet outil est SNMPb. B comme bébé.

{::nomarkdown}<iframe width="560" height="315" src="https://www.youtube.com/embed/gCh95fN36xI" frameborder="0" allowfullscreen></iframe>{:/nomarkdown}

Les points forts de SNMPb sont nombreux. Tout d’abord c’est un logiciel Libre. Il est aussi gratuit. L’équipe de SNMPb fournit des versions pré-compilées pour Windows et des versions RPM et Debian pour Linux. Il supporte à la fois le protocole SNMP dans ses version 1, 2c et 3. Il permet de réaliser des requêtes SNMP GET/WALK/SET/TABLE. Il affiche la description des OIDs, peut importer des MIBs efficacement et effectuer des recherches dans des OIDs.

Tout d’abord, nous allons voir où le récupérer, puis l’installer et enfin son utilisation.
# Téléchargement de SNMPb

SNMPB est disponible sur le site web de [SourceForge](https://sourceforge.net/projects/snmpb). Pour le trouver, il suffit de faire une recherche avec le mot clé « SNMPb ».

Ensuite, on peut cliquer sur « download » et choisir la version souhaitée. L’installation ne requiert a priori pas de dépendance particulière. Je l’ai personnellement installé sur Ubuntu et sur Mandriva sans avoir de message d’erreur. De mon côté, je l’ai déjà installé sur mon poste et nous allons voir comment l’utiliser.
Utilisation de SNMPb

SNMPb répartit les fonctionnalités principales en différents onglets. Le premier onglet permet d’interroger un agent SNMP. La première partie correspond à l’agent qui sera interrogé. Ensuite, nous avons l’arbre des MIBs. On peut dérouler cette MIB en cliquant sur les différents OID. En faisant un click droit sur un OID, on accède aux actions telles que le WALK ou le GET. En cliquant sur un OID, la vue du bas donne des informations sur celui-ci : le nom, l’oid complet, le type et surtout la description. Je vous invite à toujours bien lire la description afin de bien interpréter la valeur de l’OID. Je rencontre beaucoup erreurs faites par des personnes qui ne lisent pas attentivement la description. C’est très très important. En faisant un click droit puis l’opération désirée, on obtient le résultat dans la vue de droite.
Paramétrage de l’hôte à interroger

Pour paramétrer l’agent à interroger, on clique sur le bouton … On rentre les paramètres par globaux: nom de l’équipement, adresse IP ou nom DNS, port SNMP, les versions SNMP gérées. Ensuite, en cliquant sur la gauche, on peut configurer la communauté SNMP. Il faut noter que pour configurer une version de SNMP, il faut avoir cocher la case dans les paramètres globaux.
Paramétrage des modules

Une fois l’agent SNMP à interroger correctement configuré, il est nécessaire d’indiquer à SNMPb quelles sont les MIBs à charger. SNMPb inclut quelques MIBs par défaut. Toutes ne sont pas chargées et toutes les MIBs existantes ne sont pas référencées. Moi, j’ai pour habitude de stocker toutes mes MIBs dans un seul répertoire composé de sous répertoire. Il faut indiquer à SNMPB quels sous répertoires il doit analyser afin d’y trouver les MIBs. Cela se fait dans le menu Options–>Preferences. Puis il faut cliquer sur Modules.

Je vous invite aussi à ajouter les MIBs fournies par le système Linux. Une fois ceci fait, vous pouvez valider. Ensuite, il faut se rendre dans l’onglet « Modules » et sélectionner quelles sont les MIBs à charger en les faisant passer de la vue de gauche à la vue de droite. Dans le doute, vous pouvez cliquer sur une MIB pour obtenir des informations détaillées sur celle-ci.
Requêtes simples avec SNMPb

Une fois l’agent configuré et les MIBs chargées, il est possible de dérouler l’arbre des MIBs et de faire des requêtes sur des OIDs. Pour cela, il vous suffit de cliquer sur chaque noeud jusqu’à l’OID souhaité. Pour interroger un OID, il vous suffit de faire un click droit sur celui-ci et de choisir l’opération GET ou WALK.

Encore une fois, je vous invite à bien lire la description de l’OID. Par exemple, pour celui-ci, la description nous informe de deux choses:
1. la valeur récupérée est en centième de secondes
2. l’OID correspond à l’uptime de l’agent SNMP et non l’uptime de l’équipement interrogé

Un autre exemple : les partitions. L’OID hrStorageSize correspond à la taille d’une partition mais celle-ci est exprimée en nombre de cluster. Pour avoir la taille d’un cluster de partition, il suffit de récupérer l’OID hrStorageAllocationUnits. ATTENTION donc à bien lire la description afin de ne pas faire des erreurs d’interprétation.
SNMPTable avec SNMPb

Dans la première vidéo, je vous ai présenté le concept de « tableau SNMP ». SNMPb utilise ce concept pour vous présenter les informations récupérées de manière plus efficace. Prenons un exemple, différent de la vidéo précédente. Le taux d’occupation d’une partition est lié à plusieurs OIDs différents (hrstoragesize, hrstorageallocationunit et hrStorageUsed). SNMPb permet d’afficher tous les OIDs sous la forme de tableau. C’est à dire qu’en une seule requête, vous avez tous les résultats présentés sous forme de tableau. Dès lors, il est beaucoup plus simple pour un humain d’interpréter les chiffres. Pour faire ceci, il vous suffit de faire un click droit sur l’OID de haut niveau et de choisir « table View ». Dans le cas des partitions, on visualise alors très simplement le nom de la partition, la taille des cluster, le nombre total de cluster de la partition et le nombre de clusters occupés.

Je vous invite donc à l’utiliser très fréquemment lorsque vous disposez de valeurs sous forme de tableau, ce qui est la majorité des éléments.
Conseils sur SNMPb

Quelques conseils sur l’utilisation d’un outil SNMP graphique. Ces conseils ne sont pas liés qu’à SNMPb et peuvent s’appliquer à tout outil. Premier conseil : il est important de ne pas faire de WALK à la racine de l’arbre des MIBs. En effet, vous risquez de saturer l’agent SNMP et le réseau.

SNMPb permet de faire des recherches. Je vous invite à utiliser cette fonctionnalité pour chercher un OID en fonction d’un mot clé.

Attention à bien lire la description de l’OID.

Vous devez comprendre parfaitement la définition de l’OID pour éviter toute erreur. Vous devez être attentif notamment à la description, l’unité, la référence à d’autres OIDs, les limites (32/64 bits) des valeurs.

Si une MIB n’est pas disponible sur votre système vous pouvez la télécharger sur le site du constructeur ou sur un repository de MIBs. Nous allons détailler cela au travers d’un exemple. Rendez vous sur le site snmplink.

1. Cliquer sur Mib Repositories.
1. Choisir un repository de MIB.
1. Choisir une MIB, télécharger, la placer dans un répertoire, configurer SNMPb pour lire ce répertoire et enfin, charger les modules.

Éviter de charger trop de modules en même temps. Vous risquez de ralentir inutilement SNMPb.

Voilà, c’est tout pour cette vidéo. N’hésitez pas à participer. Pour cela, vous pouvez ajouter des commentaires à cet article. Si vous avez des questions, je vous invite à les poser. Si vous avez des précisions à apporter, ce sera avec joie. Si vous avez des suggestions, des propositions d’article, j’essaierai aussi de les prendre en compte selon mes moyens bien entendus.

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
