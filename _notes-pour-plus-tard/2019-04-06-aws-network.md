---
layout: post
title: "AWS, le fonctionnement du réseau"
date: 2020-04-05 07:48:00
description: AWS, le fonctionnement du réseau
category: 'notes pour plus tard'
introduction: ' '
collection: notes
permalink: /notes-pour-plus-tard/AWS-le-fonctionnement-du-reseau/
toc: true
tags:
- notes-pour-plus-tard
- AWS
- réseau
- IPv4
- IPv6
---

## Notes sur le réseau sur AWS (Amazon Web Services)

### Introduction
Amazon Web Services (AWS) est le leader (au moment d'écrire cet article) des fournisseurs de _Cloud_. La philosophie du réseau sur le cloud est différente de la phisolophie du réseau physique, même si les deux mondes vont, forcément, fusionner à terme. Lorsque l'on doit passer d'un monde _purement physique_ ou _auto-hébergé_ vers AWS, il faut bien comprendre comment fonctionne le réseau pour construire quelque chose qui tient la route.

Cette page ne se veut pas un manuel complet du réseau sur AWS, non. Elle n'a pas vocation à remplacer, loin de là, [la documentation officielle d'AWS](https://docs.aws.amazon.com/fr_fr/vpc/latest/userguide/what-is-amazon-vpc.html) (très bonne au démeurant). Cependant, elle me sert de référence : lorsque j'ai un doute, je la regarde. Lorsque je ne trouve pas l'information, je la recherche puis je l'ajoute ici.

### VPC - Virtual Private Cloud
Un VPC peut-être vu, en première approche, comme un _réseau d'entreprise_. Si vous êtes une TPE, vous disposez généralement :
- d'un parefeu/d'un routeur en entrée de réseau
- d'une (ou plusieurs) DMZ : un réseau exposé sur Internet
- d'un LAN : un réseau dédié aux postes bureautiques
- d'un réseau pour les serveurs du LAN
- d'un réseau pour la R&D
- ...

Si l'on devait basculer toute cette infrastructure sur AWS, en première approche on pourrait copier/coller ce réseau dans un VPC. Cependant, on ne fera pas forcément cela car :
1. généralement, on ne migre pas le LAN et les serveurs du LAN sur AWS. On peut le faire mais ce n'est pas forcément la première action que l'on réalise.
1. il est possible d'isoler un peu plus les équipements en créant des VPC différents : un VPC par _service rendu_. Notamment, si vous fournissez des services différents à vos utilisateurs externes, il peut être intéressant de les isoler encore plus en les mettant dans différents VPC.

Selon ma vision (qui peut être mauvaise), on évite de faire dialoguer des VPC entre eux. Là, encore une foisn c'est possible. Cependant, pour une première construction, ce n'est pas nécessaire.

#### IPv4 dans un VPC
Un VPC dispose d'une plage IPv4 _"RFC1918"_. Lorsque l'on crée son VPC et que l'on demande un réseau IPv4, on choisit un réseau IPv4 de taille /16. Ensuite, on peut créer des sous-réseaux IPv4 comme on le souhaite.

#### IPv6 dans un VPC
Un VPC dispose d'une plage IPv6. Lorsque l'on crée son VPC et que l'on demande un réseau IPv6, on obtient un réseau Ipv6 /56. Ensuite, on peut créer des sous-réseaux IPv6 comme on le souhaite.

#### Ajout de nouveaux sous-réseaux au VPC
Vous pouvez créer des sous-réseaux à votre VPC du moment qu'il ne sort pas du réseau associé au VPC. Par exemple, si votre VPC dispose d'un réseau 10.1.0.0/16, que vous aviez créé 2 sous-réseaux 10.1.1.0/24 et 10.1.2.0/24, vous pouvez ajouter par exemple 10.1.3.0/24, 10.1.4.0/24, 10.1.5.0/24, ..., jusqu'à 10.1.255.0/24.

Théoriquement, vous avez choisi un réseau IPv4 suffisamment grand pour votre VPC. Vous avez aussi l'expérience des erreurs passées et vous avez conçu et découper vos sous-réseaux pour ne pas surconsommer. Mais bon, votre TPE est devenu une entreprise internationnale sur les 5 continents et vous avez dépassé la capacité prévue à l'origine. Pas d'inquiétude, il est possible de rajouter [d'autres réseaux](https://docs.aws.amazon.com/fr_fr/vpc/latest/userguide/VPC_Subnets.html#vpc-resize) en respectant les règles.

Si vous saturez le réseau IPv6, appelez moi : je veux vous interviewer pour savoir comment vous avez fait :-) .


### Associer une adresse IPv4/IPv6 accessible de l'extérieur



### Sécurité


### Relations entre les objets
L'idée ici est d'indiquer 
