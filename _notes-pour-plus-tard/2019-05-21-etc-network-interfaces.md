---
layout: post
title: "/etc/network/interfaces"
date: 2019-05-21 15:46:00
description: /etc/network/interfaces
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/etc-network-interfaces/
toc: true
tags:
- notes pour plus tard
- IPv6
- IPv4
- administration système
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Notes sur /etc/network/interfaces
### Configuration de base
``` 
auto eth0
iface eth0 inet static
      address 172.16.42.3
      netmask 255.255.255.0
      gateway 172.16.42.1

iface eth0 inet6 static
      address fd13:afe9:de12:42::3
      netmask 64
      gateway fd13:afe9:de12:42::1
```


### Changement de configuration non pris en compte
Si le changement de configuration n'est pas pris en compte, c'est parce qu'il faut recharger la configuration de systemd avant de redémarrer le réseau : 
``` bash
systemctl daemon-reload
systemctl restart networking.service
```

### Configuration un peu plus avancée
``` 
# remarque : tous les scripts ne sont pas nécessaires
auto eth0
iface eth0 inet static
      pre-up /usr/local/network/pre-up-ipv4.sh
      pre-down /usr/local/network/pre-down-ipv4.sh
      post-up /usr/local/network/post-up-ipv4.sh
      post-down /usr/local/network/post-down-ipv4.sh
      address 172.16.42.3
      netmask 255.255.255.0
      gateway 172.16.42.1
      mtu 1500

iface eth0 inet6 static
      pre-up /usr/local/network/pre-up-ipv6.sh
      pre-down /usr/local/network/pre-down-ipv6.sh
      post-up /usr/local/network/post-up-ipv6.sh
      post-down /usr/local/network/post-down-ipv6.sh
      address fd13:afe9:de12:42::3
      netmask 64
      gateway fd13:afe9:de12:42::1
```

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
