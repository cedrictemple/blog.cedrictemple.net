---
layout: post
title: "VirtualBox : introduction à son utilisation par un étudiant ou un professionnel de l'informatique"
date: 2024-02-01 08:00:00
description: VirtualBox, introduction à son utilisation par un étudiant ou un professionnel de l'informatique
category: 'Formation VirtualBox'
introduction: ''
collection: formation-virtualbox
permalink: /formations/VirtualBox/introduction-a-son-utilisation-pour-un-etudiant-ou-un-professionnel-de-linformatique/
toc: true
tags:
- Formations
- VirtualBox
- administration système
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

## Introduction
Ce premier article sur VirtualBox fait partie d'une série d'articles écrits avec pour objectif de vous **apprendre** à bien utiliser cet outil. Cette série fera donc partie de la catégorie "Formations". 

## "Formation ?" VirtualBox
Cette série est organisée sous forme de "formation" car je la trouve la plus adaptée au contenu que je souhaite vous proposer. Par le passé, j'ai travaillé avec un IUT pour réaliser un cours pour une formation réalisée à 100% en distanciel. C'est à dire que les étudiants avaient tous accès à tous les cours par Internet, aucun cours n'étant réalisé dans une salle de classe. Tous les cours étaient donc conçus pour que les étudiants soient autonomes, puissent apprendre à leur rythme, quand ils le veulent, d'où ils le veulent, puissent faire des TPs de chez eux, puissent revoir le cours. Le contenu des cours avait donc été adapté pour ces objectifs. Les étudiants avaient accès à un outil que l'on nomme [LMS (pour Learning Management System)](https://fr.wikipedia.org/wiki/Learning_management_system) sur lequel, en plus des cours, ils pouvaient également échanger avec leurs professeurs (rendre des devoirs, poser des questions) et les autres étudiants.

Ici, nous ne passerons pas par un LMS, même si j'aimerai bien pouvoir le faire, pour des raisons de coûts d'hébergement et de maintenance que je n'ai pas la capacité de supporter mais aussi par manque de temps. Cependant, je vais essayer d'utiliser les bonnes pratiques que j'ai apprises durant le processus de création du cours en distanciel.

Le contenu de cette série d'articles appelée "formation" sera différente du contenu des autres articles : il contiendra des vidéos, il sera plus détaillé, son organisation a une vocation pédagogique et des travaux pratiques (TP) seront proposés. Bien entendu, je ne vais pas vous demander de m'envoyer des comptes-rendus de TP, ni vous obligez à les réaliser, vous n'aurez pas d'examen, vous n'aurez pas de diplôme, ni de certificat de suivi, ni de coût de formation, ni de prise en charge par un OPCO ou OPCA, ni feuille de présence et non, je n'ai pas de certification QualiOpi ! Vous ne pourrez prétendre à rien de plus que les informations que je vous fournis sans contre-partie et sans garantie. Cependant, j'espère que vous pourrez apprendre des choses qui vous serviront et qui vous rendront opérationnel soit dans votre formation étudiante, soit dans votre cadre professionnel.

## Cible de la formation
Nous axons le contenu de cette formation pour deux profils distincts : 
1. l'étudiant en informatique qui suit par ailleurs une formation dans une fac, dans un IUT ou dans une école d'ingénieur, qui a besoin de faire des travaux pratiques et qui utilise VirtualBox pour les réaliser
2. le professionnel de l'informatique (l'administrateur système, le SRE, le DevOps ou le développeur) qui utilise VirtualBox pour son travail ou pour ses projets personnels, pour faire ses tests

L'objectif est de bien maîtriser VirtualBox pour être efficace, pour se faciliter la vie, pour accélérer les opérations et pour éviter les pertes de données.

## Contenu de cette "formation"
Dans cette série d'articles, nous aborderons les thèmes suivants : 
* quelques bases sur la virtualisation : nous reviendrons sur la virtualisation, ce que c'est, ce que ce n'est pas.
* Cas d'utilisation de la virtualisation sur le poste utilisateur : nous verrons pourquoi et quand vous devez utiliser un outil comme VirtualBox pour faire de la virtualisation
* Différence entre virtualisation du poste utilisateur et virtualisation sur le poste utilisateur
* Pourquoi utiliser VirtualBox 
* Installation de VirtualBox sur un poste GNU/Linux Debian
* Installation de VirtualBox sur un poste Windows
* Utilisation basique de VirtualBox
* Import d'une machine virtuelle dans VirtualBox
* Création d'une machine virtuelle dans VirtualBox 
* Le fonctionnement du réseau virtuel (concepts)
* Configuration du réseau d'une machine virtuelle dans VirtualBox
* Snapshots de machine virtuelle (concepts)
* Faire des snapshots d'une machine virtuelle dans VirtualBox
* Export de machine virtuelle (concepts)
* Faire des exports d'une machine virtuelle dans VirtualBox
* VirtualBox en ligne de commande

Si un article n'a pas de lien, c'est que le contenu n'est pas encore produit. Patiente !

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
