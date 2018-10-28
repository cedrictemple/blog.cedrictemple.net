---
layout: post
title: "Valider les changements de version d'une API : une méthode (II)"
date: 2017-11-19 07:48:00
description: Valider la nouvelle version d'une API en vérifiant les appels et les résultats, proposition d'une meilleure méthode
image: /assets/img/...
category: 'automatisation du SI'
twitter_text: Valider les changements de version d'une API, une méthode (II)
introduction: Pour que la post-mise en production soit calme !
tags:
- API
- automatisation du SI
- JSON
---

Nous disposons d'une API, utilisée par notre outil interne. Cette API est ouverte à d'autres utilisations, par des outils externes à notre entreprise. C'est un succès : la cible fixée est en train d'être atteinte. Les cas d'utilisation sont nombreux. On a même parfois le sentiment de perdre la main : nous ne savons pas exactement quels sont les appels faits, avec quels paramètres, quand ils sont faits, quelles sont les données récupérées et pourquoi. C'est normal mais c'est un peu stressant : comment s'assurer que les changements faits à l'API ne cassent pas les outils externes ? Pour les outils internes, c'est relativement simple : nous avons une plate-forme de développement et nous l'utilisons correctement. Pour les outils externes, c'est plus complexe :
- certains développements sont faits par des prestataires externes. Certes, il y a un contrat de maintenance mais généralement, les prestataires bloquent pour faire les changements nécessaires à l'évolution de l'API.
- nous ne maitrisons pas le planning des développements externes.
- les développements externes n'ont pas la même maturité que nous, ils n'ont pas d'environnement de développement branché sur le notre. Ils ont à peine un environnement de pré-production, que nous leur avons imposé, mais qu'ils n'utilisent que très peu.
- le développement de l'API est en forte progression : nous n'avons pas atteint la pleine maturité de l'API et celle-ci évolue très rapidement. De très nombreuses fonctionnalités sont ajoutées au fur et à mesure, des refontes sont faites pour améliorer les performances, des composants sont mis à jour vers des nouvelles versions majeures, des bouleversements ont lieu régulièrement.
- nous avons beau imposé aux développeurs qu'aucun changement ne casse l'API, ceux-ci en font. Ce n'est pas volontaire (voir point précédent), mais tout changement de ce type mis en production génère des *dramas* terribles : de nombreux responsables externes sont au courant et appellent, demandant à résoudre le problème dans l'immédiat, ce qui s'avère impossible. Les développeurs n'ont pas mis, n'ont pas voulu ou n'ont pas su mettre en place les éléments pour s'assurer de cela.

Nous avons donc besoin de recetter l'API avant qu'elle ne passe en pré-production.

## Une méthode



PAS de # TITRE 1 car il est déjà récupéré par title dans YML
## Titre 2
### Titre 3
#### Titre 4

`code en ligne dans le texte`

    code de type listing (tabulation ou 4 espaces)

Images : 
![titre alt](https://placehold.it/800x400 "Large example image")
![titre alt](https://placehold.it/400x200 "Medium example image")
![titre alt](https://placehold.it/200x200 "Small example image")
    

- **bold text**
- *italicize text*
> Citation

[Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).

* liste non ordonnée
* liste non ordonnée

1. liste ordonnée
2. liste ordonnée
3. liste ordonnée



