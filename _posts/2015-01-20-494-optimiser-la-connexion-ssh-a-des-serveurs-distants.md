---
layout: post
title: "Optimiser la connexion SSH à des serveurs distants"
date: 2015-01-20 12:26:40
image: /assets/img/ssh.png
description: Optimiser la connexion SSH à des serveurs distants
category: 'administration système'
tags:
- administration système
- SSH
twitter_text: Optimiser la connexion SSH à des serveurs distants
introduction: Optimiser la connexion SSH à des serveurs distants pour se simplifier la vie lors du télétravail
---

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">

> [image disponible sur WikiCommons](https://commons.wikimedia.org/wiki/File:Auth_ssh.png) par [Pigr8](https://it.wikipedia.org/wiki/User:Pigr8) sous licence BSD


Le télétravail est une belle invention. Vous pouvez travailler de chez vous, commencer plus tôt et terminer plus tard tout en étant moins fatigué. Vous disposez d’une certaine souplesse, après vous être mis d’accord avec votre responsable, pour vous absenter une petite heure pour aller conduite la voiture au garage par exemple. Vous évitez les transports en commun, très aléatoire en région parisienne, ou les 10 petits kilomètres en voiture à une vitesse moyenne de… 20km/h. Bref, c’est que du bonheur…

Vous lancez votre VPN et vous vous connectez en SSH sur votre poste. De là, vous pouvez lancer des applications graphiques qui s’exécutent sur votre poste au bureau mais s’affichent sur votre ordinateur familial. Vous disposez d’une connexion supra-giga-ultra-méga-très-très-haut débit, grâce à la fibre optique, c’est à dire du 100MBits/s (!!! vivement le supra-giga-ultra-méga-très-très-haut ++ débit) en download et du 50MBits/s en upload. Petit veinard! En dehors du fait qu’on se moque de nous sur le côté très-très-très-haut débit, on constate quand même que ça reste assez… lent. Il y a une certaine latence entre la frappe d’une touche sur le clavier et le moment où le caractère s’affiche. De plus, Firefox et LibreOffice mettent un certain temps à s’afficher lors de nombreux « Alt-Tab ». Ceci est très gênant. D’autant plus gênant lorsqu’on enchaîne deux connexions SSH dans deux tunnels OpenVPN distincts pour lancer un Firefox à l’autre bout afin d’utiliser l’outil d’administration graphique du SAN ou de l’outil de virtualisation. Il peut se passer plusieurs dizaines de secondes entre le changement de fenêtre et le rafraîchissement de l’affichage de cette fenêtre. Comment « accélérer » la connexion SSH? Comment améliorer le ressenti utilisateur?

Dans toute la suite j’utiliserai les termes « serveur (SSH) », « utilisateur » et « client (SSH) ». Ces termes sont utilisés avec les définitions suivantes :

   * « serveur (SSH) » : c’est la machine cible, celle sur laquelle un client SSH souhaite se connecter.
   * « client (SSH) » : c’est le poste utilisateur (généralement un « poste bureautique ») sur laquelle un utilisateur se trouve et depuis laquelle il essaye de se connecter à un « serveur SSH ».
   * « utilisateur » : un utilisateur Unix. Il peut être côté « client SSH » (c’est alors un utilisateur qui veut se connecter à un serveur) ou côté « serveur SSH » (c’est l’identité sous laquelle je souhaite être connecté sur le serveur).

## Les fichiers de configuration SSH

Un petit rappel sur les fichiers de configuration SSH. En fait, il y en a quatre différents, à modifier selon le besoin :

   * /etc/ssh/sshd_config : fichier de configuration du serveur SSH. Ce fichier est à configurer côté serveur, notamment s’il ont veut interdire à quiconque de se logger en tant que root en SSH par exemple (PermitRootLogin No). Si vous modifiez ce fichier côté client (votre poste utilisateur), cela n’aura absolument aucun impact sur la connexion entre votre poste et vos serveurs.
   * /etc/ssh/ssh_config : fichier de configuration du client SSH. Ce fichier est à modifier côté poste utilisateur, jamais côté serveur (sauf en cas de rebond). Ce fichier est global à tous les utilisateurs du poste utilisateur : chaque modification faite dans ce fichier impactera tous les utilisateurs du poste utilisateur.
   * ~/.ssh/config : fichier de configuration du client SSH, spécifique à un utilisateur. Ce fichier est à modifier côté poste utilisateur, jamais côté serveur. Ce fichier est spécifique à l’utilisateur concerné sur le client SSH.
   * ~/.ssh/authorized_keys : fichier de configuration spécifique à un utilisateur, permettant de définir quelles sont les clés SSH publiques autorisées à se connecter sous l’identité de l’utilisateur concerné sur ce serveur particulier. Ce fichier est à modifier côté serveur, pour l’utilisateur cible choisi. Il est recommandé de ne pas modifier directement ce fichier à la main sur le serveur mais d’utiliser la commande « ssh-copy-id » depuis le client SSH.

Dans le cas qui concerne cet article, je souhaite optimiser la connexion :

   * entre le poste utilisateur de ma maison et le poste utilisateur de mon bureau : ceci afin d’améliorer les temps de réponse, notamment le rafraîchissement de l’affichage sur l’écran de ma maison des applications lancées sur le poste de travail de mon bureau, dans le tunnel SSH dans le tunnel VPN.
   * entre le poste utilisateur de mon bureau et tous les serveurs connectés en VPN : nous administrons à distance des serveurs situés chez nos membres, géographiquement répartis dans toute la France, avec des différences de débit conséquentes.

Je vais donc modifier le fichier ~/.ssh/config :

   * de l’utilisateur « cedric » du poste utilisateur de ma maison
   * de l’utilisateur « cedric » du poste utilisateur de mon bureau

# Configuration du client SSH du poste utilisateur de ma maison

Le fichier à modifier est ~/.ssh/config. Le chemin complet est /home/cedric/.ssh/config. Voici les lignes de ce fichier :

    Host 10.54.65.1
    GSSAPIAuthentication no
    GSSAPIKeyExchange no
    GSSAPIRenewalForcesRekey no
    Compression yes
    CompressionLevel 9
    ForwardX11 yes
    ForwardX11Trusted yes

Regardons les lignes une par une :

   * Host 10.54.65.1 : cette ligne indique que toutes les lignes de configuration en dessous de celle-ci et jusqu’à la prochaine ligne Host seront limitées à cette adresse IP (ou ce nom DNS). Chez moi, j’ai souhaité faire une configuration spécifique dédiée à la connexion VPN à mon bureau, c’est donc l’adresse IP de mon poste utilisateur de mon bureau. Si vous n’ajoutez pas de ligne Host …, la configuration est faite pour toutes les cibles.
   * GSSAPI.* : je n’active pas GSSAPI car l’activation de ce protocole ralentit le début de la connexion SSH. Le client ne va pas essayer d’utiliser ce protocole pour s’authentifier auprès du serveur. Si vous laissez ce protocole activé alors qu’il n’est pas configuré côté serveur, il y a un délai de quelques secondes au tout début de la connexion SSH. Délai pendant lequel on se demande : « plus d’internet? serveur tombé? VPN tombé? c’est quand qu’on arrive? t’as pensé au pain? ». Bref, n’ajoutons pas de stress inutile.
   * Compression yes : j’active la compression SSH. Cela accélère la communication et réduit le délai lors des échanges. Je mets le niveau de compression le plus élevé à l’aide de CompressionLevel 9, afin d’optimiser le plus possible les échanges. Activer la compression par défaut peut charger un peu le CPU, côté client comme côté serveur et peut être inutile voire contre-performant lors des transferts de fichier à l’aide de la commande scp. Ce n’est pas grave pour mon propre cas. Vous ne devriez pas être gêné vous non plus.
   * ForwardX11 : j’active le transfert X11. Dès lors, lorsque je lance la commande « firefox » en SSH, il s’exécute sur l’ordinateur de mon bureau mais l’affichage est déporté sur l’écran du poste de ma maison. J’ai activé cette configuration par défaut car je l’utiliserai systématiquement.
   * ForwardX11Trusted : j’ai activé cette option par défaut (je n’avais pas à le faire car elle est activée par défaut dans Debian) car j’ai pleinement confiance dans mes postes utilisateurs. Je connais bien l’administrateur des postes, je lui fais confiance (c’est moi!).

## Configuration du client SSH du poste utilisateur de mon bureau

Le fichier à modifier est ~/.ssh/config. Le chemin complet est /home/cedric/.ssh/config. Voici les lignes de ce fichier :

    Host *.vpn
    GSSAPIAuthentication no
    GSSAPIKeyExchange no
    GSSAPIRenewalForcesRekey no
    Compression yes
    CompressionLevel 9
    ForwardX11 yes
    ForwardX11Trusted no

Les modifications intéressantes sont :

   * la configuration concerne uniquement les serveurs dont le nom de connexion se termine par .vpn. Les serveurs internes ne seront donc pas impactés par les modifications. Mon réseau local est suffisamment performant, pas besoin de faire de compression.
   * les connexions X11 ne sont pas trusted par défaut. Normal, le serveur distant peut être administré par d’autres personnes, que je ne connais pas ou très très peu. Un risque est toujours possible. Cette configuration a tendance à ralentir énormément la connexion SSH. Je la repasse à yes lors d’un problème urgent, à régler rapidement, après avoir vérifier que personne d’autre que moi n’est connecté au serveur.

Avec ses deux fichiers de configuration, je couvre presque tous mes cas. Mes connexions sont optimisées et je ressens beaucoup moins cette rage que j’avais auparavant, lorsque je suis contraint d’agir à distance, en urgence, sur un problème complexe et risqué et que « ça ralentit ».

Ce contenu est fourni sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr)<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1">
