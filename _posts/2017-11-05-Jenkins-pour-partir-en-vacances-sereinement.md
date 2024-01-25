---
layout: post
title: "Jenkins : pour partir en vacances sereinement"
date: 2017-11-04 06:30:00
description: Jenkins, pour que les admin. sys. puissent partir en vacances sereinement
image: /assets/img/jenkins_dashboard.png
category: 'automatisation du SI'
twitter_text: Jenkins, pour que les admin. sys. puissent partir en vacances sereinement
introduction: Vas-y, bosse pendant que je bronze !
tags:
- administration système
- Jenkins
- automatisation du SI
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">


L'automatisation du système d'information est critique lorsqu'on est *admin. sys.* dans une [TPE](https://fr.wikipedia.org/wiki/Tr%C3%A8s_petite_entreprise)/[PME](https://fr.wikipedia.org/wiki/Petite_et_moyenne_entreprise). Mais ce n'est pas suffisant : il ne faut pas que l'*admin. sys.* soit dans le déclencheur de toutes les tâches automatisées, sinon il reste le [SPOF](https://fr.wikipedia.org/wiki/Point_individuel_de_d%C3%A9faillance) : s'il n'est pas là, rien ne se réalise. Nous allons voir comment répondre à cet enjeux.

## Contexte

Nous sommes dans une TPE ou dans une PME. Il y a une équipe technique (informatique), de taille restreinte et une équipe métier, qui utilise l'outil informatique mais qui n'en a pas fait son métier. L'équipe métier demande beaucoup de réalisations à l'équipe technique qui est débordée et ne peut répondre à tous les projets. Elle est limitée par le nombre de personnes mais ne peut augmenter ce nombre car *"l'informatique n'est pas le métier principal de l'entreprise"*.

Il faut donc automatiser les actions : il faut que toute action qui doit être effectuée souvent soit réalisée automatiquement par un outil. La première question que l'on entend souvent est *"Quand automatiser ?"*. La réponse est simple : dès que l'on parle d'une fois par mois et que cette action prend un temps significatif à un admin. sys., il est nécessaire d'automatiser.

Automatiser les actions n'est pas suffisant. En effet, si l'équipe est trop restreinte, elle l'est encore plus lors des congés annuels, lorsqu'un admin. sys. est malade, lorsqu'il est à l'extérieur pour rencontrer un client, un partenaire ou bloqué dans ce foutu RER D qui est encore en panne à cause des feuilles, de la pluie fine, de la chaleur, du froid, de la neige, du vent, des animaux sur les voies, des gens sur les voies, des bagages abandonnés, des pannes matérielles, des incendies de poste de signalisation, des ... Oups, pardon ! Bref, faisons en sorte que les métiers puissent travailler pendant que l'admin. sys. n'est pas là.

Si l'admin. sys. n'est pas là, il faut pouvoir :
* lancer les actions ;
* voir le résultat de ces actions.

Un élément important à prendre en compte : ces deux points vont être réalisés par des utilisateurs de l'outil informatique, non pas par des techniciens de l'outil. Il faut donc que ce soit simple à faire et simple à comprendre.

## Objectifs primaires
Les objectifs primaires sont donc clairs :
* il faut que les tâches de l'admin. sys. soient automatisées ;
* il faut qu'elles se réalisent seules ou que les utilisateurs puissent les actionner eux-mêmes simplement ;
* il faut que les utilisateurs soient avertis en fin de processus et ils doivent pouvoir comprendre si cela s'est bien passé ou non ;
* l'outil doit s'adapter à deux typologies d'utilisateur : les admin. sys. et les non techniciens.

Ce sont les points sur lesquels il faut se concentrer.

## Choix de l'outil
Au niveau de la mise en œuvre, nous avons choisi Jenkins. En fait, le choix de l'outil n'est pas le plus important. Le plus important est l'alignement de l'outil avec les objectifs primaires et secondaires. Nous avons choisi cet outil car :
* il répond à tous les objectifs primaires ;
* il répond à des objectifs secondaires qui nous intéressent : 
  * il est Libre : c'était un pré-requis ;
   * il était déjà connu d'une personne en interne ;
   * il peut lancer des scripts shell, du python, du java, ... : il est totalement ouvert aux différents langages ;
   * son interface permet de faire déclencher des tâches à des utilisateurs non techniciens ;
   * il récupère les résultats de tests unitaires pour les présenter de manière graphique ;
   * une tâche peut être déclenchée par une mise à jour dans un dépôt de code (GIT) ;
   * il peut avertir des utilisateurs avec moult détails (logs de construction) ;
   * il peut avertir des utilisateurs non technicien avec des messages adaptés (que vous avez à écrire) ;
   * il s'interface avec de nombreux outils externes (GitHub, JIRA, Slack, GIT, ...). Bref, il est extensible !

## Mise en œuvre
Une fois l'outil choisi, il faut l'installer, commencer le déploiement, avoir des retours, les analyser, améliorer la configuration puis avoir des retours, les analyser, améliorer la configuration puis on recommence encore et encore.

Les facteurs de succès chez nous :
* une gestion des droits relativement simple :
  * l'authentification est déléguée à notre LDAP ;
  * des administrateurs qui ont tous les droits ;
  * des utilisateurs qui peuvent voir les statuts de quelques tâches bien choisies et lancer quelques tâches encore plus minutieusement choisies
* la documentation, dans un wiki externe, des tâches que les utilisateurs non techniques peuvent lancer
* une *micro-formation* pour les utilisateurs non techniciens, pour lancer les tâches :
  * *"pour faire ça, tu cliques là, puis là et tu rentres tel paramètre et tu appuis sur ce bouton ; quand ça clignote, c'est que ce n'est pas fini ; quand ça ne clignote plus, c'est que c'est fini, vérifie tes mails"*
  * puis faire lancer les tâches par les utilisateurs non techniciens, pour qu'ils prennent confiance, pendant que les admin. sys. sont présents
* des notifications par email :
  * lorsqu'une tâche est terminée, un mail part en direction des admin. sys. mais aussi des utilisateurs ;
  * certains mails sont ultra-détaillés et à destination des admin. sys.
  * d'autres sont plus concis et plus précis à destination des utilisateurs non techniciens et plus directif ( *"cliquer sur le lien ci-dessous pour voir le résultat"* )
dans certains cas, si l'utilisateur va être perturbé par la mise à jour d'un serveur de préproduction, une notification par email est envoyée aux utilisateurs pour les avertir ;
* Jenkins est signalé constamment :
  * à chaque réunion d'équipe, pour que les utilisateurs comprennent son utilité ( *"ok, je vais régler ce problème en ajoutant une tâche Jenkins qui va faire ça, le mail sera envoyé à toi et toi. La tâche se déclenchera automatiquement mais tu pourras la faire manuellement comme d'habitude."* ) ;
  * on rappelle son rôle, ce qu'il apporte ;
  * répéter constamment pour que l'information prenne : l'outil existe, il est utilisé tous les jours, tout le temps, adaptez-vous !
  * les mails proviennent de Jenkins : l'outil n'est pas caché, on ne fait pas croire que le mail est envoyé par un humain ;
* les tâches sont déclenchées par des outils externes (commit GIT ou SVN) automatiquement, sans action humaine ;
* les utilisateurs comprennent qu'ils peuvent voir le message de commit dans Jenkins, faire le lien avec JIRA, donc voir le bug qui est corrigé par les développeurs externes lors de la dernière mise à jour.

## Conclusion
L'outil réalise des tâches automatiquement, sans action des admins. sys. Il prévient les utilisateurs qui peuvent réaliser les vérifications de la livraison, en comparant ce que déclare les développeurs (bug fermé dans JIRA) et ce qui est réellement corrigé. Il rend des services alors qu'aucun admin. sys. n'est présent. Les utilisateurs demandent à avoir plus de détails dans les messages pour analyser un éventuel problème ou, au contraire, moins de notifications car ils en reçoivent trop ou d'ajouter une nouvelle tâche Jenkins pour faire Y, ... Ils viennent vous voir en vous disant : *"tu as vu, le build de X est planté. J'ai vu que c'était lié à une dépendance NPM qui plante, que le développeur a ajouté dans le JIRA PTA-2289"* et vous entendent répondre *"ha bon ? Je n'avais pas encore vu :-) "* .

**Félicitations** , l'outil est rentré dans les mœurs ! C'est un beau succès. Vous pouvez partir en vacances sereinement, vous ne serez pas sollicité inutilement.

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
