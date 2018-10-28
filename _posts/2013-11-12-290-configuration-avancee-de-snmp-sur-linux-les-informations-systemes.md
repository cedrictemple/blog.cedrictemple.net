---
layout: post
title: "Configuration avancée de SNMP sur Linux : les informations systèmes"
date: 2013-12-22 12:26:40
image: /assets/img/snmpd.png
description: Configurer SNMPd pour définir les informations systèmes
category: 'snmp'
tags:
- snmp
- administration système
twitter_text: Configuration avancée de SNMP sur Linux, définir les informations systèmes
introduction: définir les informations systèmes
---

Nous avons vu dans un article précédent comment configurer l’agent Net-SNMP afin qu’il réponde à nos requêtes. Nous allons voir maintenant comment configurer cet agent Net-SNMP pour qu’il supervise le serveur de lui-même.

Nous partons du fichier de configuration précédent à savoir:

    rocommunity macommunaute
    rwcommunity macommunauteRW 192.168.0.1
    syscontact cedrictemple@cedrictemple.info
    syslocation Europe/France/Paris/6 rue Beaubourg

## Avant toute chose

Toute la configuration se fait dans le fichier /etc/snmp/snmpd.conf.

Tout modification faite dans ce fichier n’est propagée dans l’agent qu’au redémarrage de celui-ci. Pensez à redémarrer l’agent à chaque modification:

    /etc/init.d/snmpd restart

## Supervision de la load

Le premier indicateur que nous allons configurer est la load. Vous pouvez retrouver sur Wikipedia la définition de la load. Attention : la load n’est pas uniquement liée aux CPU (vous pouvez avoir une load de 180 avec un CPU très très peu utilisé). Je vous expliquerai comment un jour prochain ;-). Comment configurer la supervision de la load:

    load loadAveragemax1minutes loadAveragemax5minutes loadAveragemax15minutes

Exemple sur un serveur avec 4 coeurs :

    load 16 8 4

Si la load avegarde sur 15 minutes est supérieure à 4 alors :

* j’aurai une information d’erreur dans la MIB SNMP
* j’aurai une trap SNMP qui sera envoyée au serveur de supervision (configuration que nous mettrons en place plus tard)

Après sauvegarde du fichier et redémarrage de l’agent SNMP, je peux effectuer les requêtes:

    [root@localhost ~]# snmptable -v 2c -c macommunaute 127.0.0.1 1.3.6.1.4.1.2021.10
    SNMP table: UCD-SNMP-MIB::laTable

    laIndex laNames laLoad laConfig laLoadInt laLoadFloat laErrorFlag laErrMessage
         1  Load-1   1.76    16.00       176    1.760000           0             
         2  Load-5   1.72     8.00       171    1.720000           0             
         3  Load-15  0.92     4.00        92    0.920000           0

Si vous ne connaissez pas snmptable, je vous invite à regarder ma vidéo sur SNMPb. Dans le résultat ci-dessus, on voit :

* dans la colonne « laConfig » (la == load average) la configuration mise en place
* la colonne « laLoadInt » donne la valeur de la load multipliée par 100
* la valeur « réelle » de la load est dans  les colonnes « laLoad » et « laLoadFloat »
* Enfin, les deux dernières colonnes indiquent si l’une des valeurs mesurées de la load dépasse la valeur seuil correspondante configurée (laErrorFlog == 0 si la valeur n’est pas dépassée et laErrorFlag == 1 si la valeur est dépassée) et le message d’erreur correspondant (« laErrorMessage »).

J’ai artificiellement fait monter la load de ma machine virtuelle pour que la valeur de la load configurée soit dépassée. Voici le résultat:

    [root@localhost ~]# snmptable -v 2c -c macommunaute 127.0.0.1 1.3.6.1.4.1.2021.10
    SNMP table: UCD-SNMP-MIB::laTable

    laIndex laNames laLoad laConfig laLoadInt laLoadFloat laErrorFlag                          laErrMessage
        1  Load-1  21.81    16.00      2180   21.809999           1 1 min Load Average too high (= 21.81)
        2  Load-5   8.27     8.00       826    8.270000           1  5 min Load Average too high (= 8.27)
        3 Load-15   3.42     4.00       341    3.420000           0

Ici, on voit que la load average sur 1 minute et la load average sur 5 minutes dépassent toutes deux leurs valeurs seuils. On a donc pour chacune d’elle le « laErrorFlag » qui passe à 1 et le « laErrMessage » qui donne le détail de l’erreur. Ces deux OIDs peuvent être utilisés par une sonde de supervision, par exemple une sonde Nagios heu.. Shinken… heu… Icinga… heu Centreon-Engine… heu… Naemon. Bref!
## Supervision des partitions

Pour superviser les partitions, il vous suffit d’ajouter une directive de la forme:

    disk /nom/partition espaceLibre

Dès lors, la partition « /nom/partition » doit avoir au moins « espaceLibre » kilo octets de disponible. Sinon, une erreur est présente dans la MIB. Si vous ajoutez le sigle ‘%’ en fin de ligne, la partition doit disposer d’au moins « espaceLibre » % d’espace libre. Voici un exemple de configuration:

    disk / 10%
    disk /boot 15000

Dans la configuration ci-dessus, la partition / doit disposer d’au moins 10% d’espace libre et la partition /boot doit disposer d’au moins 15000 Ko d’espace libre. Si vous souhaitez configurer le même espace libre pour toutes les partitions, il vous suffit de faire:

    includeAllDisks 10%

Voici un exemple de requête SNMP:

    [root@localhost ~]# snmptable -v 2c -c macommunaute 127.0.0.1 1.3.6.1.4.1.2021.9
    SNMP table: UCD-SNMP-MIB::dskTable
    
    dskIndex                  dskPath                       dskDevice dskMinimum dskMinPercent dskTotal dskAvail dskUsed dskPercent dskPercentNode dskTotalLow dskTotalHigh    dskAvailLow dskAvailHigh dskUsedLow dskUsedHigh dskErrorFlag dskErrorMsg
            1                        / /dev/mapper/VolGroup00-LogVol00         -1            10  6284792  4548256 1412136         24              3     6284792            0     4548256            0    1412136           0            0            
        2                    /proc                            proc         -1            10        0        0       0          0            100           0            0           0            0          0           0            0            
            3                     /sys                           sysfs         -1            10        0        0       0          0            100           0            0           0            0          0           0            0            
            4                 /dev/pts                          devpts         -1            10        0        0       0          0            100           0            0           0            0          0           0            0            
            5                    /boot                       /dev/hda1         -1            10   101086    83428   12439         13              0      101086            0       83428            0      12439           0            0            
            6                 /dev/shm                           tmpfs         -1            10   436048   436048       0          0              0      436048            0      436048            0          0           0            0            
            7 /proc/sys/fs/binfmt_misc                            none         -1            10        0        0       0          0            100           0            0           0            0          0           0            0

Dans le résultat ci-dessus, les colonnes sont les suivantes:

* dskPath : le nom du point de montage
* dskDevice : le nom de la partition
* dskMinimum : espace libre (en Ko) minimum configuré, si la valeur mesurée est inférieur, une erreur sera générée. Dans notre cas, -1 est affiché car nous n’avons pas configuré de valeur minimale en Ko mais en pourcentage
* dskMinPercent : pourcentage d’espace libre minimum configuré, si la valeur mesurée est inférieur, une erreur sera générée
* dskTotal : la taille de la partition (en ko)
* dskAvailable : l’espace libre disponible (en ko)
* dskUSed : l’espace occupé (en ko)
* dskPercent : l’espace occupé (en %)
* dskPercentNode : le pourcentage d’inodes occupé
* dskErrorFlag : passe à 1 si la partition dépasse sa valeur seuil, 0 sinon
* dskErrorMessage : détail du message d’erreur si la partition dépasse sa valeur seuil

## Supervision de processus

La supervision de processus se fait par la directive de configuration suivante:

    proc nomProcessus maxPresent minPresent

Voici un exemple pour Apache:

    proc httpd 100 2

Dans la configuration ci-dessus, nous avons fait en sorte que l’agent SNMP supervise qu’il y ai au moins 2 processus httpd et pas plus de 100. S’il y a plus de 100 processus httpd ou moins de 2, une erreur sera présente dans la MIB. Voici un exemple:

    [root@localhost ~]# snmptable -v 2c -c macommunaute 127.0.0.1 1.3.6.1.4.1.2021.2
    SNMP table: UCD-SNMP-MIB::prTable
    
    prIndex prNames prMin prMax prCount prErrorFlag                  prErrMessage prErrFix prErrFixCmd
        1   httpd     2   100       0           1 Too few httpd running (# = 0)        0

 

Dans le résultat ci-dessus, on peut voir :

* le nom des processus supervisés (dans notre cas, un seul : httpd. Il est tout à fait possible de superviser plusieurs processus en ajoutant plusieurs lignes)
* les valeurs seuils min et max configurées
* le nombre de processus mesuré (« prCount » = 0)
* le flag d’erreur (« prErrorFlag » = 1)
* le message d’erreur (« pErrMessage »)

## Supervision de la taille d’un fichier

L’agent SNMP peut aussi superviser la taille d’un fichier. Si la taille dépasse une valeur seuil, une erreur est disponible dans la MIB. La configuration est la suivante:

    file /var/log/syslog  153600

Dès lors, on peut vérifier par une requête SNMP la taille de chaque fichier:

    [root@localhost log]# snmptable -v 2c -c macommunaute 127.0.0.1 1.3.6.1.4.1.2021.15
    SNMP table: UCD-SNMP-MIB::fileTable
    
    fileIndex        fileName  fileSize   fileMax fileErrorFlag                                        fileErrorMsg
            1 /var/log/syslog 157473 kB 153600 kB          true /var/log/syslog: size exceeds 153600kb (= 157473kb)

Les colonnes sont les suivantes:

* le nom du fichier (« filename »)
* sa taille (« fileSize »)
* la taille maximale autorisée (« fileMax »)
* si le fichier dépasse la taille maximale autorisée (« fileErrorFlag » = true (et non 1!!!))
* le détail de l’erreur (« fileErrorMsg »)
