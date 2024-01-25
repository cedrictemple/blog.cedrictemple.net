---
layout: post
title: "Configuration avancée de SNMP sur Linux : envoi de trap SNMP"
date: 2013-12-22 12:26:40
image: /assets/img/snmpd.png
description: Configurer SNMPd pour recevoir des traps SNMP
category: 'SNMP'
tags:
- SNMP
- administration système
twitter_text: Configuration avancée de SNMP sur Linux, réception de trap SNMP
introduction: Recevoir les traps SNMP
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

Le protocole SNMP n’est pas dédié à fournir une réponse à des requêtes SNMP. Le protocole permet aussi d’envoyer, sans avoir été sollicité, des informations à un récepteur. Ce mécanisme est connu sous le nom d’envoi de trap SNMP. Nous allons voir comment configurer l’envoi de trap SNMP à l’aide de Net-SNMP vers un récepteur donné.

## Pourquoi envoyer des traps SNMP?

Le démon SNMPd s’auto-supervise. Comme nous l’avons vu dans un article précédent, il peut détecter des états anormaux de l’équipement. Lorsqu’un comportement est anormal, il peut envoyer des traps SNMP. Légitimement, on peut se demander pourquoi est il important de mettre en place des traps SNMP alors qu’un outil de supervision dédié est présent et réalise des tests récurrents. Les outils de supervision fonctionnent, généralement, sur le principe suivant: interrogation récurrente de l’équipement (par exemple « interrogation toutes les 5 minutes ») pour obtenir des informations données. L’intervalle de test est généralement amplement suffisant (qui peut dire qu’il peut répondre en moins d’une minute à toutes les pannes rencontrées? Vous? Sûr? Même lorsque vous êtes à la machine à café, à draguer la nouvelle stagiaire du service comptable qui ressemble beaucoup, par sa vivacité d’esprit mammaire et son intelligence croupiale, à la dernière starlette de la télé-réalité? (tiens?!? que devient la première starlette de la télé-réalité? Des nouvelles? Qui s’était déjà?!?)… Bref…). Cependant, il est possible d’améliorer la supervision sans avoir à saturer le serveur de supervision en demandant aux équipements supervisés d’envoyer des informations lorsqu’ils détectent une panne. Là est l’intérêt des traps SNMP : envoyer des « alertes » dès qu’une panne apparaît, sans avoir à saturer le serveur de supervision. De plus, certaines informations sont plus simples à récupérer par des traps SNMP que par des requêtes. Généralement, les traps SNMP sont plus faciles à analyser qu’un indicateur agrégé devant correspondre à plusieurs requêtes SNMP dans plusieurs MIBs différentes.

Nous partons du fichier de configuration et de l’utilisateur SNMPv3 précédents (contenu du fichier /etc/snmp/snmpd.conf) :

    syscontact cedrictemple@cedrictemple.info
    syslocation Europe/France/Paris/6 rue Beaubourg
    load 16 8 4
    includeAllDisks 10%
    rouser ctemple

Tout d’abord, il faut ajouter une ligne permettant d’indiquer quel récepteur recevra les traps SNMP et quelle communauté est utilisée:

    informsink <ip> <communaute>

Par exemple, la ligne suivante permet de déclarer que l’équipement 192.168.1.1 recevra nos traps SNMP avec la communauté SNMP « secrete« :

    informsink 192.168.1.1 secrete

Ensuite, il faut déclarer si l’on souhaite envoyer des traps SNMP lorsqu’une requête SNMP reçue par cet équipement échoue pour cause d’erreur d’authentification. Pour cela, il faut ajouter la directive suivante:

    authtrapenable 1

Si vous ne souhaitez pas recevoir de traps SNMP lors d’une erreur d’authentification, il faut remplacer 1 (enabled) par 2 (disabled) :

    authtrapenable 2

Remarque : par le passé, je désactivais systématiquement l’envoi de traps SNMP lors d’une erreur d’authentification. La raison en était simple : nous faisions changer les communautés SNMP sur tous les équipements. De ce fait, les outils de supervision précédemment mis en place et « oubliés » (oui, ça arrive : des vieux Nagios 1.3/Cacti/MRTG/… traînent toujours sur beaucoup de systèmes d’information et supervisent dans le vide pour rien) . Nous recevions alors beaucoup de traps SNMP inutiles dans la supervision « officielle ». En désactivant la fonctionnalité, le nombre d’alertes diminue. Depuis, je me suis rendu compte qu’il est préférable… de supprimer l’ancien outil de supervision devenu inutile 🙂

Le démon Net-SNMP requiert un utilisateur SNMPv3 pour s’auto-superviser. Il faut donc déclarer cet utilisateur. Nous avions créé un utilisateur nommé ctemple dans l’article précédent, nous pouvons donc le réutiliser:

    agentSecName ctemple

Ensuite, nous allons déclarer la supervision par défaut. Celle-ci est déjà suffisante et permet de superviser : la load, la swap, les partitions, l’absence de processus, la taille des fichiers. Ceci se fait en ajoutant la directive :

    defaultMonitors yes

Enfin, nous allons faire en sorte que lorsqu’une interface réseau est déconnectée ou reconnectée, des traps SNMP soient envoyées.

    linkUpDownNotifications yes

Une fois toutes les directives ajoutées, le fichier devient:

    syscontact cedrictemple@cedrictemple.info
    syslocation Europe/France/Paris/6 rue Beaubourg
    load 16 8 4
    includeAllDisks 10%
    rouser ctemple
    informsink 192.168.1.1 secrete
    authtrapenable 1
    agentSecName ctemple
    defaultMonitors yes
    linkUpDownNotifications yes

Il est alors possible de redémarrer le service SNMP:

    /etc/init.d/snmpd restart

Des trap SNMP seront alors automatiquement envoyées par le service SNMP de Net-SNMP lorsque des dépassements de seuil auront lieu. Pour tester, vous pouvez simplement faire une requête SNMP avec la mauvaise communauté SNMP:

    snmpwalk -v 2c -c badcommunnity IP

Vous recevrez alors des traps SNMP sur le récepteur de trap SNMP:

    tail -f /var/log/messages
    2013-11-21T21:36:50.829966+01:00 localhost snmptrapd[1921]: 2013-11-21 21:36:50 localhost.localdomain [UDP: [127.0.0.1]:60228]:#012DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (11405) 0:01:54.05#011SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-MIB::authenticationFailure#011SNMPv2-MIB::snmpTrapEnterprise.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
    2013-11-21T21:36:51.830362+01:00 localhost snmpd[2985]: Connection from UDP: [127.0.0.1]:42847
    2013-11-21T21:36:51.832737+01:00 localhost snmptrapd[1921]: 2013-11-21 21:36:51 localhost.localdomain [UDP: [127.0.0.1]:60228]:#012DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (11506) 0:01:55.06#011SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-MIB::authenticationFailure#011SNMPv2-MIB::snmpTrapEnterprise.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
    2013-11-21T21:36:52.831201+01:00 localhost snmpd[2985]: Connection from UDP: [127.0.0.1]:42847
    2013-11-21T21:36:52.833210+01:00 localhost snmptrapd[1921]: 2013-11-21 21:36:52 localhost.localdomain [UDP: [127.0.0.1]:60228]:#012DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (11606) 0:01:56.06#011SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-MIB::authenticationFailure#011SNMPv2-MIB::snmpTrapEnterprise.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10

Remarque : sur Debian, lors du redémarrage de l’agent SNMP, vous pourrez avoir des erreurs dans le fichier de log /var/log/syslog :

    Nov 27 09:05:41 debian snmpd[22637]: payload OID: prNames
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: Unknown payload OID: prNames
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: Unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: payload OID: prErrMessage
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: Unknown payload OID: prErrMessage
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: Unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: trigger OID: prErrorFlag
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: unknown monitor OID
    Nov 27 09:05:41 debian snmpd[22637]: payload OID: memErrorName
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: Unknown payload OID: memErrorName
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: Unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: payload OID: memSwapErrorMsg
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: unknown payload OID
    Nov 27 09:05:41 debian snmpd[22637]: Unknown payload OID: memSwapErrorMsg
    Nov 27 09:05:41 debian snmpd[22637]: /etc/snmp/snmpd.conf: line 13: Error: Unknown payload OID

Cela est lié à l’absence des MIBs de base car celles-ci ne peuvent pas être incluses dans Debian du fait de leur licence qui n’est pas compatible avec celle de Debian. Pour résoudre ce problème, il vous faut les télécharger. Heureusement, un paquet existe pour cela mais il n’est disponible que dans le dépôt non-free. Il faut modifier le fichier /etc/apt/sources.list pour ajouter non-free en fin de ligne:

    deb http://mirrors.ircam.fr/pub/debian/ squeeze main non-free
    deb http://security.debian.org/ squeeze/updates main non-free
    deb http://mirrors.ircam.fr/pub/debian/ squeeze-updates main non-free

Une fois ceci fait, on peut installer le paquet snmp-mibs-downloader:

    apt-get update
    apt-get install snmp-mibs-downloader

Editer le fichier /etc/default/snmpd et modifier la ligne concernée pour aboutir au résultat suivant:

    export MIBS=UCD-SNMP-MIB

Redémarrer le service Net-SNMP:

    /etc/init.d/snmpd restart

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
