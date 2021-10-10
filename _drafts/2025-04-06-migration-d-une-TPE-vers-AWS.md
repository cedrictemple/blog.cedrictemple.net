---
layout: post
title: "Migration d'une TPE vers AWS"
date: 2025-04-05 07:48:00
description: Migration d'une TPE vers AWS
category: 'notes pour plus tard'
introduction: ' '
collection: notes
permalink: /notes-pour-plus-tard/migration-d-une-TPE-vers-AWS/
toc: true
tags:
- notes pour plus tard
- AWS
- migration
- IPv4
- IPv6
---

## Notes sur le réseau sur AWS (Amazon Web Services)

### Introduction
TO BE CHANGE !!!
Amazon Web Services (AWS) est le leader (au moment d'écrire cet article) des fournisseurs de _Cloud_. La philosophie du réseau sur le cloud est différente de la phisolophie du réseau physique, même si les deux mondes vont, forcément, fusionner à terme. Lorsque l'on doit passer d'un monde _purement physique_ ou _auto-hébergé_ vers AWS, il faut bien comprendre comment fonctionne le réseau pour construire quelque chose qui tient la route.

Cette page ne se veut pas un manuel complet du réseau sur AWS, non. Il n'a pas vocation à remplacer, loin de là, la documentation officiel d'AWS (très bonne au démeurant). Cependant, elle se veut plutôt en mode _une documentation sur le réseau AWS par un ancien du monde physique pour la migration d'un réseau d'une PME/TPE vers AWS_. En effet, c'est le chemin que j'ai dû faire : migrer un réseau existant, construit depuis 30, rénové en parti il y a 8 ans mais qui est loin des meilleures pratiques. Il faut donc porter ce réseau existant vers AWS avec plusieurs objectifs :
1. migrer les services avec le moins de casse possible
2. en profiter pour passer aux meilleures pratiques, tant sur le réseau que sur la sécurité
3. isoler ce qui peut l'être
4. passer aux _nouvelles technologies_

Cette page a donc une vocation didactique. Elle me sert aussi de référence pour plus tard.

### Compresser un fichier
``` bash
# compresser le fichier et effacer l'ancien fichier non compressé
bzip2 monfichier.txt
# compresser le fichier et garder l'ancien fichier non compressé
bzip2 -k monfichier.txt
bzip2 --keep monfichier.txt
# compresser et envoyer le résultat vers stdout, l'ancien fichier restant présent
# on redirige vers le fichier compressé
bzip2 --stdout monfichier.txt > monfichier.txt.bz2
```

### Choix du taux de compression
``` bash
# le plus compressé
bzip2 -9 monfichier.txt
bzip2 --best monfichier.txt
# le moins compressé
bzip2 -1 monfichier.txt
bzip2 --fast monfichier.txt
# à noter : --best et --fast sont des faux amis
# et sont là pour la compatibilité avec gzip
# --fast n'est pas forcément plus le rapide
# par défaut, le taux de compression est -9
```

### Décompression
``` bash
# commandes équivalentes
bzip2 -d monfichier.txt.bz2
bzip2 --decompress monfichier.txt.bz2
bunzip2 monfichier.txt.bz2
# décompression vers sortie standard pour passage à un autre programme
bunzip --stdout monfichier.txt.bz2 | monprogramme ...
# Très utile pour importer un dump SQL par exemple :
bunzip2 --stdout mondump.sql.bz2 | mysql -p -u <user> <database> 
```

### Travail avec d'autres programmes
Lorsqu'on enchaîne les commandes avec _pipe_, il faut connaître le comportement de bzip2/bunzip2. Si on passe des données sur l'entrée standard, alors bzip2/bunzip2 va sortir les données vers sa sortie standard et non vers un fichier. Exemple :
``` bash
monprogramme | bunzip2 > monfichier_decompresse.txt
monprogramme | bunzip2 | grep ... | ... > monfichier_decompresse.txt
# autre moyen avec bunzip2
bunzip2 < monfichiercompresse.sql.bz2 | mysql -p -u <user> <database> 
```

### Comparatif (rapide) de rapidité et de compression entre gzip et bzip2
Ici, le but n'est **pas** de donner un résultat exact et objectif des deux outils mais une tendance de leur performance respective tant en compression qu'en rapidité de compression. L'idée est de pouvoir choisir entre l'un ou l'autre en fonction du contexte. En effet, on peut avoir besoin d'une forte compression en se moquant de la durée de compression ou au contraire, vouloir une compression qui n'est pas la meilleure mais dans un temps raisonable. Il peut y avoir un autre paramètre permettant de faire un choix : le temps de décompression (qui parfois est plus important que le temps de compression). Il n'est pas mesuré ici car je n'ai pas de contexte le justifiant.
``` bash
cedric@portable:~$ ls -lh *
-rw-r--r-- 1 cedric cedric 2,8G avril  5 21:53 database-backup.sql
cedric@portable:~$ time gzip --keep --fast database-backup.sql 

real    0m26.487s
user    0m18.839s
sys     0m1.123s
cedric@portable:~$ ls -lh *
-rw-r--r-- 1 cedric cedric 2,8G avril  5 21:53 database-backup.sql
-rw-r--r-- 1 cedric cedric 297M avril  5 21:53 database-backup.sql.gz
cedric@portable:~$ time gzip --keep --best database-backup.sql

real    1m35.320s
user    1m27.281s
sys     0m1.120s
cedric@portable:~$ ls -lh
total 2,9G
-rw-r--r-- 1 cedric cedric 2,8G avril  5 21:53 database-backup.sql
-rw-r--r-- 1 cedric cedric 177M avril  5 21:53 database-backup.sql.gz
cedric@portable:~$ time bzip2 --keep --best database-backup.sql 

real    5m19.511s
user    5m6.917s
sys     0m1.440s
cedric@portable:~$ ls -lh
total 2,8G
-rw-r--r-- 1 cedric cedric 2,8G avril  5 21:53 database-backup.sql
-rw-r--r-- 1 cedric cedric  84M avril  5 21:53 database-backup.sql.bz2
cedric@portable:~$ time bzip2 --keep --fast database-backup.sql 

real    3m40.317s
user    3m31.527s
sys     0m1.652s
cedric@portable:~$ ls -lh
total 2,9G
-rw-r--r-- 1 cedric cedric 2,8G avril  5 21:53 database-backup.sql
-rw-r--r-- 1 cedric cedric 164M avril  5 21:53 database-backup.sql.bz2
```
**Remarque** : gzip comme bzip2 ne modifie pas la date de création de fichier. C'est pour cela qu'on voit que l'heure de création de fichier est toujours la même (21h53).
