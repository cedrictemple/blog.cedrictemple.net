---
layout: post
title: "Faire des requêtes SNMP en ligne de commande sous Linux"
date: 2013-04-01 12:26:40
image: /assets/img/snmptable.jpg
description: Faire des requêtes SNMP en ligne de commande sous Linux
category: 'SNMP'
tags:
- administration système
- SNMP
twitter_text: Faire des requêtes SNMP en ligne de commande sous Linux
introduction: La ligne de commande, c'est plus simple quand on utilise les bons outils !
---

Voici une vidéo que j’ai réalisé sur l’utilisation de la ligne de commande Linux pour faire des requêtes SNMP. Vous trouverez en dessous de cette vidéo le texte sur lequel est basé cette vidéo. Les lignes de commande sont disponibles afin que vous puissiez les copier/coller si vous le souhaitez.

{::nomarkdown}<iframe width="560" height="315" src="https://www.youtube.com/embed/xaPsoj8JecE" frameborder="0" allowfullscreen></iframe>{:/nomarkdown}

Bonjour, je suis Cédric Temple, bienvenu sur le blog http://blog.cedrictemple.net et bienvenu chez moi. Et oui, on est … chez moi. D’ailleurs, il se peut que vous voyez passer mon chat quelques fois, ou qu’un jouet pour enfant traîne sur le sol, qu’un mannequin de Victoria Secrets passe nue derrière moi ou qu’une voisine sonne.

Ha non, il n’y a personne!

Bref! Pourquoi me direz vous? Souvenez vous, j’avais fait quelques vidéos sur les ACLs de Centreon. J’enregistrais ce qui se passait sur mon bureau pendant que je vous parlais. C’était intéressant mais insuffisant. Je rencontrai un problème assez désagréable. J’avais le sentiment d’être assez enfermé : je ne pouvais pas parler pendant plusieurs dizaines de secondes sans que mon écran ne bouge. En effet, cela est très perturbant pour vous : vous vous attendez à avoir une synchronisation parfaite entre ce qui est dit et ce qui est montré. Si vous voyez un écran immobile pendant que je parle, cela va beaucoup vous gêner. Je devais donc me contraindre à éviter de parler trop longtemps sans que ça ne bouge à l’écran. Très, très gênant. Je le sais, moi-même ça me gêne dans les vidéos réalisées par d’autres. De ce fait, j’ai décidé de tenter une nouvelle expérience : me filmer pendant que j’aborde les sujets plus… théoriques et réaliser des captures d’écran lorsque je ferai les démonstrations techniques. Dites moi, dans les commentaires, si cela vous convient ou si vous préférez autre chose. Ce blog se veut ouvert. Il me permet de partager mes expériences avec vous et de recevoir vos commentaires, tant positifs que négatifs. N’hésitez pas à me les faire parvenir, j’en serai très ravis. J’essaierai, si cela m’est possible bien entendu, de prendre en compte vos remarques afin d’améliorer ce blog.

## Différence entre SNMPGET et SNMPWALK

Aujourd’hui, nous allons voir comme faire des requêtes SNMP en ligne de commande sur un système Linux. L’idée n’est pas simplement de comprendre l’utilisation des commandes standards snmpget et snmpwalk mais d’aller un peu plus loin. En effet, comme vous pouvez le remarquer, je suis un vieux con : j’adore la ligne de commande. Les commandes recèlent tant et tant d’options qu’il est difficile de faire plus efficace et puissant. Nous verrons donc les options que vous n’utilisez peut-être pas mais aussi nous verrons d’autres commandes. L’idée est de vous montrer que vous avez un vrai intérêt, tant dans l’utilisation des options complémentaires que des autres commandes. Nous allons voir dans un premier temps les deux commandes standards : snmget et snmpwalk. Tout d’abord, quelle est la différence entre snmget et snmpwalk?

En fait c’est simple : snmpget permet de récupérer la valeur d’un OID feuille alors que snmpwalk permet de récupérer toutes les valeurs d’un OID « noeud ». Avec snmpget, vous récupérez une et une seule valeur : la valeur de l’OID demandé. Si cet OID n’est pas une feuille, vous n’aurez pas de réponse. snmpwalk permet de récupérer toutes les valeurs d’un sous-arbre : vous récupérerez toutes les valeurs disponibles en dessous de l’arbre.

ATTENTION : ne faites JAMAIS une requête snmpwalk sur la racine de l’arbre SNMP ou sur un noeud de haut niveau. Si vous faites cela, vous allez saturer l’agent SNMP interrogé, le réseau et votre poste. Dans le passé, vous pouviez saturer certains agents SNMP et il était nécessaire de les redémarrer voire de redémarrer l’équipement. Ce pourrait être très gênant si vous deviez demander à l’équipe réseau de redémarrer un routeur.

L’utilisation des commandes snmpget et snmpwalk est exactement la même, leur syntaxe est identique. Seul l’OID interrogé va différer, selon que vous souhaitez interroger un sous-arbre ou un OID feuille. Pour faire une requête, il vous suffit de taper pour snmpwalk:

    snmpwalk -v <laversion> -c <lacommunaute> <adresseip> <oid>

Exemple :

    snmpwalk -v 2c -c public 192.168.1.13 1.3.6.1.2.1.2.2.1.10

Si vous savez utiliser la commande snmpwalk, vous saurez utiliser snmpget. C’est exactement la même syntaxe :

    snmpget -v <laversion> -c <lacommunaute> <adresseip> <oid>
    snmpget -v 2c -c public 192.168.1.13 1.3.6.1.2.1.2.2.1.10.1

La différence de résultat entre snmpwalk et snmpget est flagrante. Avec snmpwalk, vous obtenez plusieurs réponses. Avec snmpget, pour le même OID, vous n’obtenez aucune réponse mais vous obtenez une réponse avec un oid feuille.
Options de sortie

snmpget et snmpwalk disposent d’options complémentaires. Peu de personnes les utilisent, ce qui est dommage car certaines sont très utiles et vous apportent des informations complémentaires. Parfois même, certains ne savent pas qu’elles existent car ils n’ont pas identifié la bonne documentation. Généralement, sur Linux, pour avoir de la documentation sur une commande, on tape

    man <nomdelacommande>

C’est pareil pour ces commandes mais avec une subtilité : les options communes de toutes les commandes snmpget, snmpwalk mais aussi toutes les autres snmptable, snmpbulk, snmpdelta, … sont regroupées dans une seule et même page de man. Cette page de man est :

    man snmpcmd

snmpcmd : cmd comme « commande »

Nous n’allons pas détailler toutes les options possibles mais noter celles qui sont intéressantes. Toutes les options dont je vais parler sont celles liées à l’affichage des résultats. Une commande snmpwalk sans option de sortie particulière affiche ses résultats en format raccourcit. C’est à dire que la commande n’affiche pas le début de l’OID mais le nom de la MIB dans laquelle se trouve cet OID. Ceci est fait pour simplifier la lecture et raccourcir l’affichage. Cependant, il peut être intéressant d’avoir l’OID complet. Pour cela, c’est très simple, il suffit d’ajouter l’option O (en majuscule), O comme output suivi d’un f (minuscule), f comme « full ». La ligne de commande devient donc:

    snmpwalk -v 2c -c public -Of 192.168.1.13 1.3.6.1.2.1.2.2.1.10

Vous avez alors l’OID complètement affiché.

Les commandes font de la traduction automatiquement. Cette traduction est faite en entrée, c’est à dire lorsque vous saisissez un OID au format alphanumérique sur la ligne de commande puis en sortie, lors de l’affichage. Cette traduction n’est possible que si la MIB est présente sur le système et que le système est configuré pour lire ces MIBs. Cependant, pour améliorer les performances, il est toujours préférable d’éviter cette traduction. Notamment, dans les scripts, il est toujours préférable de saisir les OID au format numérique et de demander aux commandes de ne sortir les résultats qu’au format numérique.

L’option permettant d’afficher les OIDs au format numérique est O (majuscule), O comme « output », suivi de n (minuscule), n comme « numeric ». La ligne de commande devient donc:

    snmpwalk -v 2c -c public -On 192.168.1.13 1.3.6.1.2.1.2.2.1.1

L’option suivante vous permet d’afficher la valeur de l’OID sans rappeler l’OID. J’utilise personnellement cette option lorsque j’interroge un agent snmp depuis un script afin de simplifier le développement du script. En effet, il est désagréable (et peu performant) de devoir parser le résultat de la commande à coup de grep/awk/sed ou autre alors qu’on peut l’éviter. Cette option est « Ov », O majuscule comme Output et v (minuscule) comme value only

snmpwalk -v 2c -c public -Ov 192.168.1.13 1.3.6.1.2.1.2.2.1.1

Une autre option que j’utilise dans les scripts, est le e minuscule. Cette option permet d’éviter une traduction de la valeur de l’OID. La valeur d’un OID est généralement un entier et cet entier correspond à un code d’erreur. La MIB SNMP définit cette traduction et la commande l’interprète. Par exemple, l’OID correspondant à IP Forwarding dispose du code suivant:

* 1 ==> Forwarding
* 2 ==> not forwarding.

Pour éviter que la commande ne traduise automatiquement cette valeur et remplace 1 par « forwarding », ce qui serait plus complexe à parser pour un script, il vous suffit d’utiliser l’option Oe. Enfin, pour disposer d’un résultat totalement pur, il faut ajouter un Q pour ne pas afficher le type de la réponse.

Au final, la commande devient:

    snmpwalk -v 2c -c public -OevQ 192.168.1.13 ipForwarding.0

## snmptable

Ce que beaucoup ignorent, c’est que les OIDs sont organisés sous forme d’un tableau. Prenons un exemple : les connexions TCP sur un serveur. Une connexion TCP dispose de plusieurs informations : son statut, l’adresse IP locale, le port TCP local, l’adresse IP distante et le port TCP distant. Chaque information correspond à 1 OID. Et il faut ajouter à chacun des OIDs le numéro de la connexion. Si on utilise la commande SNMPWALK, le résultat est très peu lisible. Le résultat est organisé par OID et non par connexion. Par contre, en utilisant la commande snmptable, la présentation des résultats va être améliorée par la commande. Plutôt que de présenter les OIDs les uns à la suite des autres, elle va les présenter sous forme de tableau : chaque connexion TCP sera sur une ligne et ses caractéristiques sur les colonnes. Beaucoup plus simple à lire pour un humain normal.

    snmptable -v 2c -c public localhost 1.3.6.1.2.1.6.13

C’est à dire, tout humain dont le nom n’est pas Sheldon Cooper ;-). Quelques options peuvent être passées à la commande snmptable. Deux options que je vous recommande. La première est -Ci et affiche l’index. Cela peut être intéressant pour l’utiliser dans la suite d’un script.

    snmptable -v 2c -c public -Ci localhost 1.3.6.1.2.1.6.13

La seconde est -Cb et elle affiche les entêtes de colonne sous forme courte. Les entêtes sont alors plus lisibles.

    snmptable -v 2c -c public -Cb localhost 1.3.6.1.2.1.6.13

De nombreux OIDs sont organisés sous forme de tableau : les partitions, les interfaces réseaux, la charge des processeurs, la liste des processus, les filesystèmes, les métriques de performances des processus, … Cependant, attention : vous ne pourrez obtenir une présentation sous forme de table que pour les OIDs qui … sont organisés sous forme de table. Cela apparaît évident mais ça va mieux en le disant.

## Conclusion

Voilà, c’est tout pour cette vidéo. N’hésitez pas à participer. Pour cela, vous pouvez ajouter des commentaires à cet article. Si vous avez des questions, je vous invite à les poser. Si vous avez des précisions à apporter, ce sera avec joie. Hein Surcouf! Je suis persuadé que tu as quelques commentaires intéressants à nous apporter. Si vous avez des suggestions, des propositions d’article, j’essaierai aussi de les prendre en compte selon mes moyens bien entendus.
