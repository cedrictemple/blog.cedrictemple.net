---
layout: post
title: "LVM, Logical Volume Manager"
date: 2021-10-10 09:10:00
description: lvm
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/LVM-Logical-Volume-Manager/
toc: true
tags:
- notes pour plus tard
- LVM
- Logical Volume Manager
- administration système
---

## Introduction
Cette page recense tout mon pense-bête sur Logical Volume Manager (LVM). LVM est un logiciel permettant de gérer les disques d'un serveur Linux. Il vous permet, en autres choses, de :
* d'agréger plusieurs disques pour faire un seul espace de stockage
* d'étendre, sans redémarrer votre serveur, un espace de stockage
* de faire du *RAID* logiciel
* de faire des sauvegardes d'espace de stockage par des *snapshots*


## Identifier les disques et les partitions
Pour identifier les disques et les partitions, utiliser la commande lsblk :
```bash
   root@serveurtest:~# lsblk 
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0    8G  0 disk 
├─sda1   8:1    0    7G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1022M  0 part [SWAP]
sdb      8:16   0   10G  0 disk 
sr0     11:0    1 1024M  0 rom
```

Si on souhaite exclure un certain type de "matériel", on regarde dans /proc/devices le *MAJOR number* puis on l'exclut avec --exclude *MJOR number* :
```bash
root@serveurtest:~# cat /proc/devices 
Character devices:
  1 mem
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  5 ttyprintk
  6 lp
  7 vcs
 10 misc
 13 input
 21 sg
 29 fb
 89 i2c
 99 ppdev
108 ppp
116 alsa
128 ptm
136 pts
180 usb
189 usb_device
226 drm
247 aux
248 hidraw
249 bsg
250 watchdog
251 rtc
252 dimmctl
253 ndctl
254 tpm

Block devices:
259 blkext
  7 loop
  8 sd
  9 md
 11 sr
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
252 device-mapper
253 virtblk
254 mdp
root@serveurtest:~# lsblk --exclude 7
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0    8G  0 disk 
├─sda1   8:1    0    7G  0 part /
├─sda2   8:2    0    1K  0 part 
└─sda5   8:5    0 1022M  0 part [SWAP]
sdb      8:16   0   10G  0 disk 
sr0     11:0    1 1024M  0 rom
```

## Déclaration d'un disque dur comme périphérique LVM
LVM repose sur des disques physiques ou des partitions dédiées. Généralement, sur un serveur, on crée un disque physique pour le système, que l'on découpe en plusieurs partitions systèmes ( */boot*, */*, */var/log*, ...) et on ajoute un disque dédié aux données ou aux applications. Ici, nous prenons l'exemple où un système est installé, on a ajouté un disque physique et l'on va créer du LVM dessus. Notre disque physique a été détecté par le système comme */dev/sdb* (voir commande précédente). Nous allons déclarer le disque physique sdb comme disque LVM. Un disque physique (ou une partition d'un disque physique) alloué à LVM est nommé *physical volume* (ou PV). Les commandes pour gérer les PV commencent toutes par pv. La commande qui nous intéresse ici est *pvcreate* :
```bash
root@serveurtest:~# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created
```

Admettons que vous vous trompiez et que vous choisissiez un disque physique déjà utilisé par le système pour autre chose :
```bash
root@serveurtest:~# pvcreate /dev/sda
  Device /dev/sda not found (or ignored by filtering).
```

Comme vous le voyez ici, LVM n'a pas réalisé votre action car elle n'était pas cohérente. En effet, ajouter un disque physique comme disque LVM alors que celui-ci est déjà utilisé, si vous réussissez, va alors supprimer toutes les données présentes sur ce disque. Cela n'est pas une bonne chose. LVM détecte automatiquement ce cas de figure et ne vous autorise pas à le faire.

**Remarque** : l'action *déclarer un disque dur comme périphérique LVM* n'est que le marquage de ce disque. L'opération est très rapide.

## Création d'un groupe de volumes
Un groupe de volume (ou VG pour *volume group*) va permettre de regrouper des disques physiques pour qu'ils aient un but commun. Là, nous allons créer un groupe de volumes (*volume group*) ne disposant d'un seul disque. Ce n'est pas pertinent pour le moment mais nous verrons par la suite l'intérêt de cette étape. Toutes les commandes permettant de gérer les *volume group* commencent par vg. Celle qui nous intéresse est *vgcreate* :
```bash
root@serveurtest:~# vgcreate monApplication /dev/sdb
  Volume group "monApplication" successfully created
```

Encore une fois, cette opération est très rapide.

**Remarque** : on peut faire les deux opérations précédentes en une seule commande, afin d'accélérer le processus. Exemple, dans le cas où je n'ai pas fait la commande pvcreate :
```bash
root@serveurtest:~# vgcreate monApplication /dev/sdb
  Physical volume "/dev/sdb" successfully created
  Volume group "monApplication" successfully created
```
On voit bien que LVM réalise lui-même les deux étapes.

## Vérifications
Vérifions ce que nous avons fait ! Tout d'abord, les disques physique :
```bash
root@serveurtest:~# pvdisplay 
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               monApplication
  PV Size               10,00 GiB / not usable 4,00 MiB
  Allocatable           yes 
  PE Size               4,00 MiB
  Total PE              2559
  Free PE               2559
  Allocated PE          0
  PV UUID               YTYMCz-UKch-BCed-2IJw-zTK0-7SGf-NBp2u8
```
Nous avons un disque physique déclaré dans LVM : /dev/sdb (*PV Name*). Celui-ci fait 10Go (*PV Size*). Il est déjà dans un volume logique (*VG Name*). Cependant, on voit qu'il n'y a aucune donnée sur ce disque car il a 2559 *Physical Extents* (*Total PE*, un PE étant un bloc du disque physique) dont 2559 sont libres (*Free PE*). On voit bien qu'il y a 0 *physical Extents* alloués (*Allocated PE*).

On peut également disposer d'informations sur les *volume group* :
```bash
root@serveurtest:~# vgdisplay 
  --- Volume group ---
  VG Name               monApplication
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               10,00 GiB
  PE Size               4,00 MiB
  Total PE              2559
  Alloc PE / Size       0 / 0   
  Free  PE / Size       2559 / 10,00 GiB
  VG UUID               0boPnN-JtJt-xrjN-mDUj-D3AW-Wgww-NVAV9B
```
On voit qu'il y a :
* un *volume group* dont le nom (*vg name*) est *monApplication*
* ce *volume group* est accessible en lecture/écriture (*VG Access*) et il peut être étendu (*VG Status*)
* actuellement aucun *logical volume* attaché à ce VG (*Cur LV*)
* un *physical volume* utilisé (*Cur PV*) et actif (*Act PV*)
* la taille du VG (*VG size*)
* aucune utilisation de ce VG (*Alloc PVE / Size*) car tous les PE sont libres (*Free PE / Size*)


## Création d'un espace de stockage logique sur un groupe de volumes
Nous allons maintenant créer un espace de stockage logique sur notre groupe de volume. Un volume logique est vu par comme "un disque dur" : c'est sur le volume logique que l'on crée un système de fichiers permettant de stocker des données. Un volume logique est nommé *logical volume* ou LV. Toutes les commandes permettant de gérer les *logical volume* commencent par lv. La commande qui nous intéresse est ici lvcreate. Pour notre exemple, nous allons créer un *logical volume* de 5Go.
```bash
root@serveurtest:~# lvcreate -n MA-datas -L 5G monApplication 
  Logical volume "MA-datas" created.
```
J'affiche le résultat :
```bash
root@serveurtest:~# pvdisplay 
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               monApplication
  PV Size               10,00 GiB / not usable 4,00 MiB
  Allocatable           yes 
  PE Size               4,00 MiB
  Total PE              2559
  Free PE               1279
  Allocated PE          1280
  PV UUID               YTYMCz-UKch-BCed-2IJw-zTK0-7SGf-NBp2u8
   
root@serveurtest:~# vgdisplay 
  --- Volume group ---
  VG Name               monApplication
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               10,00 GiB
  PE Size               4,00 MiB
  Total PE              2559
  Alloc PE / Size       1280 / 5,00 GiB
  Free  PE / Size       1279 / 5,00 GiB
  VG UUID               lKoibH-Yp3y-TmCJ-c3yI-Q7IH-VgvA-0qnXUt
   
root@serveurtest:~# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/monApplication/MA-datas
  LV Name                MA-datas
  VG Name                monApplication
  LV UUID                CiW7F7-5cAF-6i14-XAdc-iqCj-tP2K-BVg1I4
  LV Write Access        read/write
  LV Creation host, time serveurtest, 2021-10-10 12:22:17 +0200
  LV Status              available
  # open                 0
  LV Size                5,00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
```
Là, on voit que le résultat des commandes *pvdisplay* et *vgdisplay* ont changé : les *physical Extents* utilisés sont indiqués. On utilise la moitié du *physical volume* et du *volume group*. On voit que l'on a créé un *logical volume* nommé *MA-datas* (*LV Name*) de 5Go (*LV Size*), qui fait parti du *volume group* *monApplication* (*VG Name*) et accessible par le chemin /dev/monApplication/MA-datas (*LV Path*) en lecture et en écriture (*LV Write Access*).

On peut donc créer une partition dessus et la monter directement :
```bash
root@serveurtest:~# mkfs.ext4 /dev/monApplication/MA-datas
mke2fs 1.42.13 (17-May-2015)
En train de créer un système de fichiers avec 1310720 4k blocs et 327680 i-noeuds.
UUID de système de fichiers=395990a8-7b44-4b8a-8d65-b6bb0744dd19
Superblocs de secours stockés sur les blocs : 
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocation des tables de groupe : complété                        
Écriture des tables d'i-noeuds : complété                        
Création du journal (32768 blocs) : complété
Écriture des superblocs et de l'information de comptabilité du système de
fichiers : complété

root@serveurtest:~# mkdir -p /srv/monApplication/datas
root@serveurtest:~# mount /dev/monApplication/MA-datas /srv/monApplication/datas
```
Je peux l'ajouter dans le /etc/fstab pour me faciliter la vie :
```
/dev/monApplication/MA-datas /srv/monApplication/datas ext4 defaults 0 0
```

## Extension du LV
Mon application est déployée, elle est en production, les utilisateurs sont ravis, la partition se remplit !
```bash
root@serveurtest:~# df -h /srv/monApplication/datas
Sys. de fichiers                     Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/monApplication-MA--datas   4,8G    4,1G  534M  89% /srv/monApplication/datas
```

Il faut augmenter la taille de celle-ci, sans couper le service. Simple : il reste encore 5Go d'espace dans mon *volume group* ! Je peux donc :
1. étendre mon *logical volume*
2. étendre ma partition

Ces actions se font sans couper le service. Aucun redémarrage n'est nécessaire. Tout se fait en live, sans que les utilisateurs ne le perçoivent ! J'avais un disque dur de 10Go, j'avais alloué 5Go à mon *logical volume*, je peux encore lui allouer les 5Go restants :
```bash
root@serveurtest:~# lvextend --size +5G /dev/mapper/monApplication-MA--datas
  Insufficient free space: 1280 extents needed, but only 1279 available
```

Arf ! Ça ne fonctionne pas ! Pourtant, j'ai bien dit que je voulais 5Go de plus, grâce au sigle "+" que j'ai placé devant 5G ! En effet, si je ne mets pas le +, il va définir la taille à 5G, ce qui est déjà la taille du LV. Je peux faire le test sans le plus :
```bash
root@serveurtest:~# lvextend --test --size 5G /dev/mapper/monApplication-MA--datas
  TEST MODE: Metadata will NOT be updated and volumes will not be (de)activated.
  New size (1280 extents) matches existing size (1280 extents)
  Run 'lvextend --help' for more information.
```

Quel était le message précis ?
1. *Insufficient free space* : ha bon ?!? Pourtant, il me restait bien 5Go de libres !
2. *1280 extents needed* : oui, pour faire 5Go, LVM a besoin de 1280 *physical extents*. Comme tout à l'heure !!!
3. *but only 1279 available* : ha ! Il en manque un. Tout simplement, un *physical extent* est utilisé par LVM. On va lui donner le chiffre d'extents précis que l'on veut en plus et on va le faire en test pour s'assurer qu'en cas d'erreur, rien ne se passe :
```bash
root@serveurtest:~# lvextend --test --extents +1279 /dev/mapper/monApplication-MA--datas
  TEST MODE: Metadata will NOT be updated and volumes will not be (de)activated.
  Size of logical volume monApplication/MA-datas changed from 5,00 GiB (1280 extents) to 10,00 GiB (2559 extents).
  Logical volume MA-datas successfully resized.
```

**ATTENTION** : ici, on est passé de --size à --extents ! Ces deux paramètres ne prennent pas les mêmes unités.

Ha, là, ça passe ! Excellent, je peux le faire vraiment cette fois-ci :
```bash
root@serveurtest:~# lvextend --extents +1279 /dev/mapper/monApplication-MA--datas
  Size of logical volume monApplication/MA-datas changed from 5,00 GiB (1280 extents) to 10,00 GiB (2559 extents).
  Logical volume MA-datas successfully resized.
```

Et je vérifie :
```bash
root@serveurtest:~# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/monApplication/MA-datas
  LV Name                MA-datas
  VG Name                monApplication
  LV UUID                CiW7F7-5cAF-6i14-XAdc-iqCj-tP2K-BVg1I4
  LV Write Access        read/write
  LV Creation host, time serveurtest, 2021-10-10 12:22:17 +0200
  LV Status              available
  # open                 1
  LV Size                10,00 GiB
  Current LE             2559
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
   
root@serveurtest:~# df -h /srv/monApplication/datas
Sys. de fichiers                     Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/monApplication-MA--datas   4,8G    4,1G  534M  89% /srv/monApplication/datas
```

Mon LV est bien étendu à 10Go mais mon système de fichiers restent à la taille initiale. En effet, ces deux éléments sont différents car on pourrait vouloir réserver de l'espace libre du VG pour un LV mais ne l'activer que plus tard. Ou alors, c'est parce que l'on a plusieurs partitions sur ce *logical volume*

Je dois maintenant redimensionner mon système de fichiers :
```bash
root@serveurtest:~# df -h /srv/monApplication/datas
Sys. de fichiers                     Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/monApplication-MA--datas   4,8G    4,1G  534M  89% /srv/monApplication/datas
root@serveurtest:~# resize2fs /dev/mapper/monApplication-MA--datas
resize2fs 1.42.13 (17-May-2015)
Le système de fichiers de /dev/mapper/monApplication-MA--datas est monté sur /srv/monApplication/datas ; le changement de taille doit être effectué en ligne
old_desc_blocks = 1, new_desc_blocks = 1
Le système de fichiers sur /dev/mapper/monApplication-MA--datas a maintenant une taille de 2620416 blocs (4k).
root@serveurtest:~# df -h /srv/monApplication/datas
Sys. de fichiers                     Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/monApplication-MA--datas   9,8G    4,1G  5,3G  44% /srv/monApplication/datas
```
**Remarques** : 
1. si l'on veut faire les deux étapes précédentes en une seule, c'est possible. Il suffit de l'indiquer à la commande lvresize à l'aide de *--resizefs*
2. si l'on veut allouer tout l'espace libre du *volume group* au *logical volume* sans avoir besoin de calculer la taille ou les extents restants, on peut utiliser *--extents +100%FREE*
```bash
root@serveurtest:~# lvextend --extents +100%FREE --resizefs /dev/mapper/monApplication-MA--data
  Size of logical volume monApplication/MA-datas changed from 5,00 GiB (1280 extents) to 10,00 GiB (2559 extents).
  Logical volume MA-datas successfully resized.
resize2fs 1.42.13 (17-May-2015)
Le système de fichiers de /dev/mapper/monApplication-MA--datas est monté sur /srv/monApplication/datas ; le changement de taille doit être effectué en ligne
old_desc_blocks = 1, new_desc_blocks = 1
Le système de fichiers sur /dev/mapper/monApplication-MA--datas a maintenant une taille de 2620416 blocs (4k).
```
