---
layout: post
title: "SystemD / systemctl : gestion des services sur GNU/Linux"
date: 2020-02-25 19:50:00
description: systemd/systemctl
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/systemd-systemctl-gestion-des-services-sur-GNU-Linux/
toc: true
tags:
- notes pour plus tard
- systemd
- systemctl
- services
---

## Notes sur le fichier SystemD / systemctl
### Arrêt/Démarrage de services
Les commandes de base sont :
``` bash
systemctl start nom.service
systemctl stop nom.service
systemctl status nom.service
```
Voir des détails sur le démarrage ou l'arrêt d'un service :
``` bash
# Voir tous les messages
journalctl -x
# Se limiter aux 60 dernières lignes
journalctl -x -n 60
# Voir les détails pour un service particulier, se limiter aux 60 dernières lignes
journalctl -x -n 60 -u ssh.service
# Attention : le nom du processus (sshd) affiché par la commande journalctl ne correspond pas au nom du service (ssh)
# Ajouter une limite sur la date
journalctl -x -n 60 -u ssh.service --since=2020-02-25 
# Remarque : là, on affiche les 60 *premières* lignes depuis le 25/02/2020 à minuit
# Ajouter une limite sur la date et l'heure
journalctl -x -u ssh.service --since="2020-02-25 00:15:00"
journalctl -x -u ssh.service --since="2020-02-25 00:15:00" --until="2020-02-25 00:45:00"
```

### Modèle de fichier de configuration de démarrage d'un service
```
#
# modele de fichier de configuration systemd unit
#
# Ici, nom doit etre remplace par le nom de votre service
# Le fichier doit etre place dans le repertoire /lib/systemd/system/
# Exemple : /lib/systemd/system/nom.service
#
[Unit]
Description=nom
# On demarre apres ces services
After=syslog.target network.target
[Service]
Type=simple
WorkingDirectory=/usr/share/nom/

# Si besoin de variables d'environnement (fichier texte avec des lignes "NOM_VARIABLE=VALEUR"
EnvironmentFile=/usr/share/nom/config/env.conf

# on peut indiquer une variable d'environnement sinon :
Environment=DAEMON=1

# Processus a demarrer
ExecStart=/usr/sbin/nomservice --parametre_du_service ...
# Autre exemple
# ExecStart=/bin/bash -lc '/usr/share/nom/script/init.sh --daemon'

# Action en cas de reload
ExecReload=/usr/bin/kill -TSTP $MAINPID

User=root
Group=root
UMask=0002

# if we crash, restart
RestartSec=1
Restart=on-failure

# output envoye dans des fichiers (attention : faut un logrotate)
StandardOutput=append:/usr/share/navigart3/navigart-backend/log/sidekiq.log
StandardError=append:/usr/share/navigart3/navigart-backend/log/sidekiq-err.log
# sinon :
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nom

[Install]
WantedBy=multi-user.target
```

Après avoir ajoute rce fichier, il faut activer le service et recharger la configuration :
``` bash
systemctl daemon-reload
# rappel : "nom" doit etre remplace par le nom de votre service
systemctl enable nom.service
systemctl start nom.service
```


### Voir les services
``` bash
systemctl list-units
# pour voir tous les services, même ceux désactivés
systemctl list-units --all
# rechercher un pattern (ici certbot.*)
systemctl list-units --all 'certbot.*'
```

### Date/Heure
``` bash
# voir les infos sur la date/heure du système :
# date/heure locale, date/heure UTC, ...
# timezone, NTP activé/synchronisé, ...
timedatectl status
# voir les timezones disponibles 
timedatectl list-timezones
# configurer la timezone
timedatectl set-timezone Europe/Paris
```

Pour activer la synchronisation NTP :
* modifier le fichier /etc/systemd/timesyncd.conf pour modifier les serveurs de temps de référence (penser à décommenter la ligne !!!)
* activer la prise en compte de la configuration :
``` bash
timedatectl set-ntp true
```
