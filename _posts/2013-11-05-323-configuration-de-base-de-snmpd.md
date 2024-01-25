---
layout: post
title: "Configuration de base de SNMPd sur GNU/Linux"
date: 2013-11-05 12:26:40
image: /assets/img/snmpd.png
description: Disposer d'une configuration minimale de SNMP
category: 'SNMP'
tags:
- SNMP
- administration système
twitter_text: Configuration de base de SNMPd sur GNU/Linux
introduction: Disposer d'une configuration minimale de SNMP
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

Comment configurer le démon SNMPd de Net-SNMP afin qu’il réponde à nos requêtes? Nous verrons dans un second temps sa configuration avancée qui nous permettra d’envoyer des requêtes SNMP en cas de panne ou de redémarrer des services à distance. Mais voyons tout d’abord son utilisation basique. En effet, il est important de savoir que le fichier de configuration de SNMPd peut être très complexe. Sa configuration par défaut l’est d’ailleurs. Si vous regardez le fichier de configuration fourni par votre distribution Linux préférée, vous verrez qu’il est possible de définir des accessgroup, des views et autres subtilités. Je vous invite à partir d’un fichier vide. Ses fonctionnalités (view, accessgroup, …) sont assez peu utilisées en pratique. Elles sont relativement complexes à mettre en oeuvre pour un apport négligeable : peu de monde à besoin de filtrer les accès aux différents OIDs. En général, c’est du « tout ou rien » : soit vous avez accès à tous les OIDs, soit vous n’avez accès à rien. Il est peu probable que des personnes différentes ou des groupes de personnes différentes utilisent SNMP : c’est en effet le domaine des administrateurs des équipements. La seule subtilité, que nous allons voir d’ailleurs, correspond au filtrage sur l’accès en lecture ou en écriture.

Tout d’abord, il faut se rendre dans le répertoire de configuration de SNMP:

    cd /etc/snmp
    mv snmpd.cond snmpd.conf.ori
    vim snmpd.conf

Une fois le fichier d’origine sauvegardé, vous pouvez partir d’un fichier vide. La première ligne de ce fichier va vous permettre de saisir la communauté accessible en lecture seule:

    rocommunity macommunaute

Dès lors, vous pourrez interroger votre agent SNMPd avec la communauté « macommunaute ». Vous pouvez augmenter la sécurité en ajoutant la source autorisée à vous interroger:

    rocommunity macommunaute 192.168.0.1

Dès lors, seule l’adresse IP 192.168.0.1 sera autorisée à vous interroger avec la communauté correspondante. Cela ajoute (un peu) de sécurité en autorisant seulement le serveur de supervision à récupérer les informations.

Vous pouvez ajouter une communauté accessible en lecture et écriture en utilisant rwcommunity en lieu et place de rocommunity. Attention, vous ne devez pas utiliser la même communauté pour les lignes rocomunity et rwcommunity (c’est en effet un non sens : une communauté ne peut pas être à la fois en read-only et en read/write). En général, on met une communauté en Read-Only et une communauté différente en Read/Write.

Ensuite, il vous faut mettre les informations administratives. Ces informations n’ont pas vraiment une grande utilité mais je les utilise personnellement pour renseigner l’adresse à laquelle contacter les administrateurs et la localisation de mes équipements. Je prends une politique de nommage afin de découper la localisation en différentes parties afin de les réutiliser dans différentes cartes. Exemple:

    syscontact admin@masociete.com
    syslocation Europe/France/Paris/6 rue Beaubourg/Salle 3/Baie 4

Le fichier de configuration final :

    rocommunity macommunaute
    rocommunity macommunauteRW 192.168.0.1
    syscontact admin@masociete.com
    syslocation Europe/France/Paris/6 rue Beaubourg/Salle 3/Baie 4

Une fois ceci fait, vous pouvez redémarrer l’agent SNMP et faire quelques tests pour vérifier qu’il fonctionne correctement :

    /etc/snmp/snmpd restart
    snmpwalk -v 2c -c macommunaute <ip>


Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
