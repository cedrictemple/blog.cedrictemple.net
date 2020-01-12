---
layout: post
title: "ImageMagick, utilisation de identify"
date: 2020-01-12 12:08:00
description: ImageMagick, utilisation de identify
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/ImageMagick-utilisation-de-identify/
toc: true
tags:
- notes pour plus tard
- ImageMagick
- identify
- image
- PNG
- JPEG
- identification de fichier
---

## Notes sur la commande identify d'ImageMagick

### Introduction
identify d'ImageMagick permet de récupérer des informations sur des images. Il va très loin car il peut récupérer les méta-datas techniques d'une image. Il peut donner aussi des informations sur les images d'une vidéo mais c'est moins pertinent.

### Principe de fonctionnement
``` bash
identify [Option] Fichier_image
```

### Cas simple
``` bash
cedric@portable:~$ identify image.png
image.png PNG 1366x768 1366x768+0+0 8-bit sRGB 1.281MB 0.000u 0:00.000
cedric@portable:~$ identify image.jpg 
image.jpg JPEG 1366x768 1366x768+0+0 8-bit Grayscale Gray 256c 168KB 0.000u 0:00.000
```

On constater que identify affiche :
* le nom du fichier
* son type (ici: PNG pour la première puis JPEG)
* ses dimensions
* l'espace de couleurs (sRGB, niveaux de gris dans les 2 examples ci-dessus)
* la taille du fichier
* ...

Il est possible de demander plus d'informations ou d'avoir uniquement les informations que l'on veut.


### Obtenir plus d'informations
``` bash
# utilisation de -verbose pour obtenir toutes les informations :
cedric@portable:~$ identify -verbose image.jpg
Image: classe_GERE_N2_Rec709Luma.jpg
  Format: JPEG (Joint Photographic Experts Group JFIF format)
  Mime type: image/jpeg
  Class: PseudoClass
  Geometry: 1366x768+0+0
  Resolution: 37x37
  Print size: 36.9189x20.7568
  Units: PixelsPerCentimeter
  Type: Grayscale
  Endianess: Undefined
  Colorspace: Gray
  Depth: 8-bit
  Channel depth:
    gray: 8-bit
  Channel statistics:
    Pixels: 1049088
    Gray:
      min: 0 (0)
      max: 252 (0.988235)
      mean: 156.695 (0.614488)
      standard deviation: 97.7887 (0.383485)
      kurtosis: -1.0666
      skewness: -0.913608
      entropy: 0.670481
  Colors: 253
  Histogram:
    269929: (  0,  0,  0) #000000 gray(0)
    ...
    ...
    ...
  Colormap entries: 256
  Colormap:
         0: (  0,  0,  0) #000000 gray(0)
         ...
         ...
  Rendering intent: Undefined
  Gamma: 0.454545
  Background color: gray(255)
  Border color: gray(223)
  Matte color: gray(189)
  Transparent color: gray(0)
  Interlace: None
  Intensity: Undefined
  Compose: Over
  Page geometry: 1366x768+0+0
  Dispose: Undefined
  Iterations: 0
  Compression: JPEG
  Quality: 92
  Orientation: Undefined
  Properties:
    date:create: 2020-01-03T17:52:19+01:00
    date:modify: 2020-01-03T17:52:19+01:00
    jpeg:colorspace: 1
    jpeg:sampling-factor: 1x1
    signature: a61e382437b75eddd03b8640206b9a65f314d3b353259ff284101b18678cd5b7
  Artifacts:
    filename: classe_GERE_N2_Rec709Luma.jpg
    verbose: true
  Tainted: False
  Filesize: 168KB
  Number pixels: 1.049M
  Pixels per second: 52.45MB
  User time: 0.030u
  Elapsed time: 0:01.019
  Version: ImageMagick 6.9.7-4 Q16 x86_64 20170114 http://www.imagemagick.org
```

Remarque :
1. on voit à la dernière ligne que c'est ImageMagick lui-même qui a été utilisé pour créer ce fichier
2. les lignes où il y a "..." sont coupées. En effet, les parties "Histogram" et "Colormap" sont très longues et j'ai donc coupé pour faciliter la lecture
3. on a énormément d'informations !


### Choisir les informations que l'on souhaite voir afficher
Il n'est pas simple d'analyser la sortie "standard" de identify et de s'en servir dans un script, surtout lorsque l'on passe l'option -verbose. La command identify vient avec une option de sélection et de formattage de la sortie pour qu'il soit plus simple de lire le résultat. Exemples :
``` bash
cedric@portable:~$ identify -format "%[colorspace]\n" image.jpg
Gray
cedric@portable:~$ identify -format "%[colorspace]\n" image.png 
sRGB
cedric@portable:~$ identify -format "%[width] %[height]\n" image.png
1366 768
cedric@portable:~$ identify -format "%[width]\n%[height]\n" image.png
1366
768
cedric@portable:~$ identify -format "%[width]x%[height]\n" image.jpg
1366x768
cedric@portable:~$ identify -format "%[size]\n" image.jpg
168KB
```

Ça se sont les "options longues". Il est possible d'utiliser des options courtes (exemple : %w pour width) mais à titre personnel, je préfère toujours les options longues quand elles sont disponibles.

La liste de toutes les options est disponible sur [la page dédiée d'ImageMagick](http://www.imagemagick.org/script/escape.php).
