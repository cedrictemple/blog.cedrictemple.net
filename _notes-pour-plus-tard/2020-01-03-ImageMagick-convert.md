---
layout: post
title: "ImageMagick, utilisation de convert"
date: 2020-01-12 12:08:00
description: ImageMagick, utilisation de convert
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/ImageMagick-utilisation-de-convert/
toc: true
tags:
- notes pour plus tard
- ImageMagick
- convert
- image
- PNG
- JPEG
---

## Notes sur la commande convert d'ImageMagick

### Introduction
convert est la commande de base pour convertir des images avec ImageMagick. Elle dispose de très nombreuses options qu'il convient de bien comprendre si l'on veut en tirer toute la quintessence.

Dans cette page, je ne donne que les exemples que j'ai déjà utilisés et qui me semblent pertinents.

### Principe de fonctionnement
``` bash
convert [Option sur le fichier source] Fichier_source [Option de sortie] Fichier_destination
```

### Conversion simple d'un format vers un autre
``` bash
# conversion basique d'un format vers un autre
# la source est au début, la destination ensuite
convert source.png destination.jpg
```

Les dimensions de l'image destination sont identiques à celles de l'image source.

### Redimensionner une image
``` bash
# ici, hxl représente :
# h : la hauteur de l'image (en pixels)
# l : la largeur de l'image (en pixels)
convert source.png -resize hxl destination.jpg
# exemple :
convert source.png -resize 800x255 destination.jpg
```
L'option resize en sortie permet de re-dimensionner l'image en entrée sans modifier ses proportions. Cette syntaxe re-dimensionne les images plus grandes et plus petites par rapport au format donné en essayant de l'intégrer dans les dimensions de l'image destination.

Exemples avec un -resize 800x255 :
* j'ai une image _"trop grande"_, de taille 800×1600 que je veux re-dimensionner en 800x255. L'image résultat aura pour taille 128×255 (sortie plus petite que l'entrée)
* j'ai une image _"trop petite"_, de taille 400×100 que je veux re-dimensionner en 800x255. L'image résultat aura pour taille 800×200 en sortie (sortie plus grande que l'entrée).

Il faut donc comprendre que lorsque je passe "800x255", convert va faire en sorte que l'image résultat va s'inscrire dans ce rectangle.

Il est aussi possible de passer un pourcentage des dimensions de l'image source :
``` bash
convert source.png -resize 40% destination.jpg
```

**Remarque** : le redimensionnement ne nécessite pas le changement de format :
``` bash
convert source.png -resize 40% destination.png
```


### Redimensionner une image tout en évitant l'agrandissement
Il est courant de vouloir re-dimensionner une série d'images tout en ne souhaitant pas que convert agrandisse les images inutilement car cela donne une image floue. Non, ce que l'on veut est _"re-dimensionner les images trop grandes"_. C'est simple :
```
# ajout de \> après les dimensions pour éviter l'agrandissement
convert source.png -resize hxl\> destination.jpg
# exemple
convert source.png -resize 800x255\> destination.jpg
```

Exemple avec un -resize 800x255\> :
* Une image de taille 800×1600 en entrée donnera une image de taille 128×255 en sortie (sortie plus petite que l'entrée)
* Une image de taille 400×100 en entrée donnera une image de taille 400×100 en sortie (sortie identique à l'entrée)

### Convertir une image en niveaux de gris
``` bash
# mode linéraire
convert source.png -grayscale Rec709Luminance destination.png
# mode non linéaire
convert source.png -grayscale Rec709Luma destination.png
```

### Faire un GIF animé
Faire des GIF animés est très utile pour des supports techniques ou de formation. Il est alors possible de jouer plusieurs images successivement pour présenter un concept. Par exemple, lorsqu'on veut évoquer le transfert d'un paquet d'un ordinateur A vers un ordinateur B passant par plusieurs routeurs, on fait plusieurs images qu'on agrège en un GIF animé et que l'on joue. Cela prend moins de place sur une page WEB que de mettre les images les unes à la suite des autres.
``` bash
# prendre les images source1.png source2.png source3.png source4.png source5.png
# faire un GIF animé dans cet ordre
# afficher chaque image 1s (-delay est en 100ième de seconde)
convert -delay 100 source1.png source2.png source3.png source4.png source5.png destination.gif
# même GIF animé mais avec chaque image affichée une demi-seconde
convert -delay 50 source1.png source2.png source3.png source4.png source5.png destination.gif
# boucler 3 fois l'animation et arrêter l'animation :
convert -delay 50 -loop 3 source1.png source2.png source3.png source4.png source5.png destination.gif
# boucler indéfiniment :
convert -delay 50 -loop 0 source1.png source2.png source3.png source4.png source5.png destination.gif
# ne pas faire de boucle (== jouer une seule fois la boucle) :
convert -delay 50 -loop 1 source1.png source2.png source3.png source4.png source5.png destination.gif
```

Quelques conseils pour faire des GIF animés dans le cas de support de formation ou de documentation technique :
1. chaque image doit être affichée suffisamment longtemps (2s dans certains cas)
2. utiliser des images sources de la même taille
3. utiliser des images sources à la taille de la destination cible pour une plus grande lisibilité

Inconvénient des GIF animés : ils ne sont pas imprimés image après image. Gênant si vous souhaitez pouvoir imprimer vos documents.
