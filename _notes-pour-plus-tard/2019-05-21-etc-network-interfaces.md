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
---

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
