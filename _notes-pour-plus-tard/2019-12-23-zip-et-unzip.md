---
layout: post
title: "zip et unzip, archives compressées"
date: 2019-09-23 07:48:00
description: zip et unzip, archives compressées
category: 'notes pour plus tard'
introduction: ' '
collection: notes
permalink: /notes-pour-plus-tard/zip-et-unzip-archives-compressees/
toc: true
tags:
- notes pour plus tard
- zip
- unzip
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Notes sur zip et unzip

### Créer une archive compressée
``` bash
# créer une archive monarchive.zip contenant des fichiers
zip monarchive.zip fichier1 fichier2 fichier3 ...
# créer une archive monarchive.zip contenant des fichiers et des répertoires
zip -r monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
# créer une archive chiffrée par un mot de passe (qui sera demandé en ligne de commande)
zip -r -e monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
zip -r --encrypt monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
# ne mettre dans l'archive que les fichiers se terminant par .xml
zip -r monarchive.zip XML_DIR -i \*.xml 
zip -r monarchive.zip XML_DIR --include \*.xml 
# pour être un peu plus verbeux : afficher les fichiers compressés et restant à compresser
zip -r --display-counts monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
zip -r -dc monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
# pour être un peu plus verbeux : afficher des . par 10Mo compressé pour chaque fichier
zip -r --display-dots monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
zip -r -dd monarchive.zip fichier1 fichier2 ... repertoire1 repertoire2
```

### Décompression
``` bash
unzip monarchive.zip
# décompression vers un autre répertoire
# très utile pour les archives qui contiennent plein de fichiers
unzip monarchive.zip -d nouvelledestination
# voir les fichiers contenus dans l'archive
unzip -l monarchive.zip
# décompresser vers la sortie standard
unzip -p monarchive.zip | monprogramme
# Très utile pour importer un dump SQL par exemple :
unzip -p monarchive.zip | mysql -p -u <user> <database> 
# tester l'archive et contrôler qu'elle n'est pas corrompue
zip -t monarchive.zip
```


Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
