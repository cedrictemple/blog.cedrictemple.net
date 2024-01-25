---
layout: post
title: "/etc/resolv.conf"
date: 2019-12-25 09:46:00
description: /etc/resolv.conf
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/etc-resolv-conf/
toc: true
tags:
- notes pour plus tard
- /etc/resolv.conf
- DNS
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Notes sur /etc/resolv.conf
``` 
# nom de domaine local
# correspond au FQDN de tous les hots du réseau local (dans le domaine correspondant)
domain local.nomentreprise.fr

# nom(s) de domaine automatiquement ajoutés à des noms courts 
# lors d'une requête DNS
# si l'on recherche nommachine alors le DNS va tester
# nommachine.local.nomentreprise.fr
# nommachine.dynamic.nomentreprise.fr
# nommachine.vpn.nomentreprise.fr
search local.nomentreprise.fr dynamic.nomentreprise.fr vpn.nomentreprise.fr

# serveurs DNS à interroger
# si le premier ne répond pas, les suivants sont interrogés
nameserver fd13:1a24:3eda:1::53:1
nameserver fd13:1a24:3eda:1::53:2
nameserver 192.168.53.1 
```

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
