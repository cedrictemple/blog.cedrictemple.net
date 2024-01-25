---
layout: post
title: "Configuration avancée de SNMP sur Linux : SNMPv3"
date: 2013-12-22 12:26:40
image: /assets/img/snmpd.png
description: Comprendre (un peu) comment fonctionne cette foutue version 3 de SNMP et la configurer
category: 'SNMP'
tags:
- SNMP
- administration système
twitter_text: Configuration avancée de SNMP sur Linux, mise en place de la version 3
introduction: Comprendre (un peu) comment fonctionne cette foutue version 3 de SNMP et la configurer
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

Il existe plusieurs versions du protocole SNMP dont les principales sont :

* SNMPv1
* SNMPv2c
* SNMPv3

Les versions v1 et v2c sont les versions les plus utilisées et les plus répandues. Cependant, ces deux versions ont toutes les deux les mêmes problèmes:

* les trames circulent en clair sur le réseau. Aucun chiffrement des trames n’est en place. Tout attaquant qui réussit à écouter le réseau à un endroit stratégique (pas sur le réseau bureautique en général) peut récupérer la communauté SNMP. La communauté SNMP ne suffit pas forcément : l’agent peut être configuré pour ne répondre qu’à des requêtes provenant de certaines adresses IP. De plus, un parefeu peut être mis en place et configuré pour n’autoriser les requêtes SNMP qu’aux serveurs de supervision. Mais le spoofing d’adresse IP est toujours possible.
* il n’y a pas de notion d’« utilisateur authentifié ». La communauté SNMP est généralement connue de tous les administrateurs systèmes et réseaux. Il est possible de scinder les équipements selon leur type et d’affecter une communauté SNMP différente selon le type de l’équipement (exemple : tous les serveurs Linux ont une communauté, celle-ci est différente des équipements réseaux) mais ce n’est pas pratique.

Généralement, lors d’un déploiement de SNMPv1 et SNMPv2c, aucune technique de sécurisation de ces protocoles n’est réalisée car aucun mécanisme ne le permet réellement. Alors, la sécurisation en périphérie du protocole doit être réalisée (filtrage à différents niveaux, mécanisme anti-spoofing, …).

Le protocole SNMPv3 permet de répondre à ces deux enjeux:

* les trames peuvent être chiffrées grâce à différents protocoles algorithmes (*).
* des utilisateurs peuvent être créés, chacun disposant d’un identifiant et d’un mot de passe personnel.

La sécurité de SNMPv3 est bien supérieure à celle de SNMPv1 et SNMPv2c. A contrario, sa mise en place est moins aisée. Nous allons voir les étapes pour configurer l’agent Net-SNMP sur Linux, tant sur Debian et CentOS/RedHat.

Nous repartons du fichier de configuration initial à savoir:

    rocommunity macommunaute
    rwcommunity macommunauteRW 192.168.0.1
    syscontact cedrictemple@cedrictemple.info
    syslocation Europe/France/Paris/6 rue Beaubourg
    load 16 8 4
    includeAllDisks 10%

La première chose est d’arrêter SNMP:

    /etc/init.d/snmpd stop

Avez vous bien arrêter le service SNMP? Oui? Sûr? C’est important pour la suite! Ensuite, ajouter un utilisateur dans le fichier /etc/snmp/snmpd.conf:

    rouser ctemple

Cet utilisateur va par la suite pouvoir s’authentifier. Pour cela, il faut ajouter une information dans un fichier spécifique. Ce fichier spécifique va être lu par le service SNMP, interprété puis modifié afin de ne pas conserver la clé et le mot de passe en clair. Attention, si vous n’avez pas arrêté le service SNMP, ce fichier va être écrasé : toutes les modifications faites seront perdues. Il est donc nécessaire d’arrêter le service SNMP avant d’éditer ce fichier. Ce fichier est particulier car il contient des informations à ne pas modifier. Il faut donc ajouter une ligne comme suit dans le fichier /var/net-snmp/snmpd.conf pour CentOS/RedHat et dans le fichier /var/lib/snmp/snmpd.conf pour Debian :

    createUser ctemple SHA MonMot2Passe!! AES !!MaPhrase2PasseAES

Un utilisateur va avoir les caractéristiques suivantes:

* un identifiant : ctemple
* un algorithme de hachage du mot de passe : SHA (MD5 est disponible)
* un mot de passe : MonMot2Passe!!
* un algorithme de chiffrement des trames ; AES (DES est disponible)
* une clé de chiffrement des trames : !!MaPhrase2PasseAES

Cette ligne doit être ajoutée dans le fichier comme indiqué ci-dessous:

    #
    # net-snmp (or ucd-snmp) persistent data file.
    #
    ############################################################################
    # STOP STOP STOP STOP STOP STOP STOP STOP STOP
    #
    #          **** DO NOT EDIT THIS FILE ****
    #
    # STOP STOP STOP STOP STOP STOP STOP STOP STOP
    ############################################################################
    #
    # DO NOT STORE CONFIGURATION ENTRIES HERE.
    # Please save normal configuration tokens for snmpd in SNMPCONFPATH/snmpd.conf.
    # Only "createUser" tokens should be placed here by snmpd administrators.
    # (Did I mention: do not edit this file?)
    #
    createUser ctemple SHA MonMot2Passe!! AES !!MaPhrase2PasseAES
    setserialno 766133377
    _mteTTable  0x736e6d70642e636f6e66 "dskTable" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "extTable" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "fileTable" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "laTable" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "memory" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "process table" 0x .0.0 0x 0x 600 0x 0x 0
    _mteTTable  0x736e6d70642e636f6e66 "snmperrs" 0x .0.0 0x 0x 600 0x 0x 0
    ##############################################################
    #
    # snmpNotifyFilterTable persistent data
    #
    ##############################################################
    ##############################################################
    #
    # ifXTable persistent data
    #
    ifXTable .1 14:0 18:0x $
    ifXTable .2 14:0 18:0x $
    ##############################################################
    engineBoots 1
    oldEngineID 0x80001f88802738b6189b55865200000000

Une fois ceci fait, il faut démarrer le service snmp:

    /etc/init.d/snmpd stop

Maintenant, on peut regarder le contenu du fichier /var/net-snmp/snmpd.conf pour CentOS/RedHat ou /var/lib/snmp/snmpd.conf pour Debian (note : seule la ligne qui nous intéresse est reprise ici) :

    ...
    usmUser 1 3 0x80001f88802738b6189b55865200000000 0x6374656d706c6500 0x6374656d706c6500 NULL .1.3.6.1.6.3.10.1.1.3 0xad9448213617c761438de6e81e0495931f690973 .1.3.6.1.6.3.10.1.2.4 0xd364fad3241bfcb2c2bbbe3736ab85d6 ""
    ...

Le fichier a automatiquement été modifié pour éviter qu’une personne non autorisée puisse lire les deux mots de passe. Pour tester la configuration, il suffit de passer les options SNMPv3 en ligne de commande :

    snmpwalk -v 3 -u ctemple -a SHA -A 'MonMot2Passe!!' -x AES -X '!!MaPhrase2PasseAE' -l authPriv localhost

Attention : les mots de passe contiennent des caractères spéciaux qui peuvent être interprétés par le SHELL. Il faut donc les encadrer par des simple quotes.

Et voilà! SNMPv3 est configuré sur votre serveur. Pour parfaire la configuration, penser à désactiver SNMPv1 et SNMPv2c en supprimant/commentant les lignes concernées dans le fichier /etc/snmp/snmpd.conf:

    #rocommunity macommunaute
    #rwcommunity macommunauteRW 192.168.0.1
    syscontact cedrictemple@cedrictemple.info
    syslocation Europe/France/Paris/6 rue Beaubourg
    load 16 8 4
    includeAllDisks 10%
    rouser ctemple

Et à redémarrer le service SNMP:

    /etc/init.d/snmpd restart

(*) Merci à Raphaël « Surcouf » Bordet pour son retour 🙂

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
