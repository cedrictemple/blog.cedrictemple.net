---
layout: post
title: "Configuration avancée de SNMP sur Linux : redémarrer un service à distance en utilisant le protocole SNMP"
date: 2013-12-22 12:26:40
image: /assets/img/snmpd.png
description: Pouvoir redémarrer un service à distance avec SNMP for fun !
category: 'snmp'
tags:
- snmp
- administration système
twitter_text: Configuration avancée de SNMP sur Linux redémarrer un service à distance en utilisant le protocole SNMP
introduction: Pouvoir redémarrer un service à distance, avec un protocole ouvert.
---

Le démon SNMP fourni par Net-SNMP vous permet de redémarrer des services à distance en utilisant le protocole SNMP. Nous allons voir comment le configurer pour:

* connaître l’état d’un service
* obtenir un détail de statut
* redémarrer le service concerné.

Le terme « service » est utilisé mais il est, en réalité, mal employé. Sur Linux, un service peut lancer plusieurs processus. C’est le cas du service postfix par exemple ou MySQL qui lance un script shell mysqld_safe et un processus mysqld. Avec Net-SNMP, nous allons pouvoir visualiser le nombre de processus correspondant à un nom donné. En fonction de cela, nous allons redémarrer un service donné.

Pourquoi permettre de redémarrer un service à l’aide du protocole SNMP? Il est généralement préférable de réaliser cette action en se connectant en SSH sur le serveur et en redémarrant directement le service concerné. Cela apporte une plus grande souplesse et un meilleur contrôle : on obtient le code de retour mais aussi un affichage textuel qui fournit de plus amples détails permettant de comprendre le code de retour. En SNMP, avec Net-SNMP, seul le code de retour sera fourni. Pourquoi alors utiliser SNMP? En réalité, ce n’est pas mis en place. Pas avec l’aide du protocole SNMP. Sauf dans un cas précis : lorsque les administrateurs ne donnent aucun « accès direct » (comprendre : pas de compte Unix) aux serveurs pour toute personne extérieure. L’équipe supervision est parfois extérieure à l’équipe des administrateurs. Ce qui a des avantages comme des inconvénients (tiens… il faudrait que j’écrive un article sur ce sujet…..). Dès lors, il est possible de s’entendre avec l’équipe d’administrateurs pour redémarrer certains services clairement identifiés, en utilisant le protocole SNMP. La configuration de ces services doit être réalisée sur les serveurs : elle peut être totalement contrôlée par l’équipe d’administration. L’équipe d’administration est donc rassurée sur les actions réalisées par l’équipe de supervision car c’est elle qui les contrôle totalement. Maintenant, nous allons voir comment configurer le démon Net-SNMP pour lui faire redémarrer un service à l’aide du protocole SNMP.

Nous reprenons le fichier de configuration de Net-SNMP précédent:

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

Nous pouvons ajouter une ligne indiquant quel est le processus qui sera automatiquement supervisé par Net-SNMP:

    proc apache2 100 2

Cette ligne indique qu’il doit y avoir au moins deux processus nommé apache2 et pas plus de 100. Si tel est le cas, une trap SNMP sera envoyée automatiquement à notre récepteur précédemment configuré. Après avoir redémarré le service snmpd, les informations sur le statut sont disponibles dans la MIB Net-SNMP (branche « enterprises–>ucdavis » pour être précis) et accessibles avec un snmptable en interrogeant l’OID .1.3.6.1.4.1.2021.2 :

    cedric@monserveur:$ snmptable -v 3 -u ctemple -a SHA -A 'MonMot2Passe!!' -x AES -X '!!MaPhrase2PasseAE' -l authPriv localhost 1.3.6.1.4.1.2021.2
    SNMP table: UCD-SNMP-MIB::prTable

    prIndex prNames prMin prMax prCount prErrorFlag prErrMessage prErrFix prErrFixCmd
       1 apache2     2   100       4     noError               noError

Le tableau présenté indique:

* l’index du processus supervisé (valeur : 1)
* le nom du processus supervisé : apache2
* le nombre minimum de processus devant être présent : 2
* le nombre maximum de processus devant être présent : 100
* le nombre minimum de processus présents actuellement : 4
* un drapeau d’erreur : noError (pas d’erreur donc!)
* un message d’erreur : pas d’erreur donc le message est vide
* un drapeau de correction d’erreur : noError (pas d’erreur donc!)
* la commande lancée pour corriger l’erreur : aucune commande configurée

Après avoir arrêté Apache, voici le résultat de la commande:

    SNMP table: UCD-SNMP-MIB::prTable

    prIndex prNames prMin prMax prCount prErrorFlag                    prErrMessage prErrFix prErrFixCmd
       1 apache2     2   100       0       error Too few apache2 running (# = 0)  noError

Là, nous pouvons observer que le nombre de processus mesuré est de 0, qu’il y a un drapeau d’erreur (« error« ) et un message d’erreur (« Too few apache2 running (# = 0)« ). Maintenant, voyons comment faire en sorte de redémarrer le service Apache à distance. Tout d’abord, nous devons ajouter une ligne dans le fichier /etc/snmp/snmpd.conf qui va corriger le problème :

    procfix apache2 /etc/init.d/apache2 restart

Nous avons une ligne « procfix » avec deux arguments:

* le nom du processus qui est supervisé. Attention : ce nom doit être exactement identique à la ligne « proc » précédente.
* la commande de correction de l’erreur. Dans notre cas, nous avons fait très simple : nous redémarrons tout simplement le service apache2.

Voyons dorénavant le résultat de l'appel à snmptable après avoir redémarré le service snmpd :

    SNMP table: UCD-SNMP-MIB::prTable

    prIndex prNames prMin prMax prCount prErrorFlag                    prErrMessage prErrFix                 prErrFixCmd
       1 apache2     2   100       0       error Too few apache2 running (# = 0)  noError /etc/init.d/apache2 restart

Nous pouvons voir que prErrFixCmd contient la commande configurée, que nous pourrons utiliser pour redémarrer apache. Pour donner l’ordre à snmpd d’exécuter cette commande, il faut utiliser la commande snmpset. La commande snmpset permet de mettre à jour un OID. Le démon snmpd de Net-SNMP fournit pour chaque ligne procfix (correctement configurée) un OID à mettre à jour : il s’agit de prErrFix. prErrFix est un drapeau dont la valeur est toujours 0 mais que l’on peut passer à 1 à l’aide d’une commande snmpset. Lorsque cette valeur est passé à 1, la commande configurée est exécutée.

Dans SNMPb, il est possible de faire un snmpset. Pour cela, il faut se rendre dans la MIB dédiée, OID .1.3.6.1.4.1.2021.2.1.102 puis faire un clic droit et cliquer sur « Set… ».


SNMPb vous indique alors la liste des index disponibles. Dans notre cas, nous n’avons qu’un seul valeur : 1. Nous pouvons donc choisir 1.

Une fois ceci fait, une nouvelle fenêtre apparaît nous permettant de saisir la valeur qui sera envoyée. Là encore, SNMPb nous facilite le travail et nous indique l'on peut choisir la valeur 0 pour "noError" et la valeur 1 pour "runFix". Nous choisissons donc la valeur 1 et nous validons. Voici le résultat après avoir de nouveau relancer la commande snmptable:

    SNMP table: UCD-SNMP-MIB::prTable
    prIndex prNames prMin prMax prCount prErrorFlag                    prErrMessage prErrFix                 prErrFixCmd
       1 apache2     2   100       0       error Too few apache2 running (# = 0)   runFix /etc/init.d/apache2 restart

Nous pouvons constater que la valeur de prErrFix est passée à runFix. Mais il ne se passe rien, malgré plusieurs minutes d’attente. La raison est simple : le service Net-SNMP est exécuté en tant qu’utilisateur Unix « snmp ». Cet utilisateur n’a pas le droit de lancer cette commande. Il faut donc lui donner les droits. Une première méthode (sale méthode… préférer plutôt la configuration de sudo) est de configurer le démon Net-SNMP pour qu’il prenne l’identifiant root (pour être exact : pour qu’il conserve les droits root lorsqu’il souhaite abandonner ses droits). Pour cela, il suffit d’ajouter la ligne suivante au fichier /etc/snmp/snmpd.conf:

    agentUser root

Une fois l’agent Net-SNMP redémarré, la commande snmpset peut être relancée à l’aide de SNMPb. Dès lors, le service apache2 est immédiatement relancé:

    SNMP table: UCD-SNMP-MIB::prTable

    prIndex prNames prMin prMax prCount prErrorFlag prErrMessage prErrFix                 prErrFixCmd
       1 apache2     2   100       4     noError               noError /etc/init.d/apache2 restart

Il est aussi possible de se passer de SNMPb et de faire cela en ligne de commande grâce à snmpset : cela est très utile pour le faire dans un script. La commande est la suivante:

    snmpset -v 3 -u ctemple -a SHA -A 'MonMot2Passe!!' -x AES -X '!!MaPhrase2PasseAE' -l authPriv  localhost 1.3.6.1.4.1.2021.2.1.102.1 i 1

Celle-ci est un peu longue, je vais la raccourcir pour mieux expliquer le sujet:

    snmpset [informations snmpv3]  localhost 1.3.6.1.4.1.2021.2.1.102.1 i 1

En fait, la commande snmpset prend, en dehors des arguments standards pour m’identifier en SNMPv3, les arguments suivants :

* l’adresse IP ou le nom de domaine de l’équipement
* l’OID qui sera mis à jour. Attention : cet OId doit contenir l’index. Cet index est positionné en toute fin de l’OID. L’OID de base est : 1.3.6.1.4.1.2021.2.1.102, auquel je dois ajouter l’index, qui est « 1 ».
* i correspond au type de données que j’envoie. Dans notre cas, le type de données attendu est un « Integer32 » qui est représenté par « i ».
* la valeur envoyée. Dans notre cas, runFix est à la valeur 1.

Le fichier /etc/snmp/snmpd.conf complet est maintenant:

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
    agentUser root
    proc apache2 100 2
    procfix apache2 /etc/init.d/apache2 restart

