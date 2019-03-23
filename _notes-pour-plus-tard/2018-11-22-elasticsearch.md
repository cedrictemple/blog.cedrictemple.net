---
layout: post
title: "ElasticSearch, utilisation de l'API par un adminSys"
date: 2018-11-22 07:48:00
description: "ElasticSearch, utilisation de l'API par un adminSys"
category: 'notes pour plus tard'
introduction: ''
collection: notes
permalink: /notes-pour-plus-tard/ElasticSearch-utilisation-de-l-API-par-un-adminSys/
tags:
- notes pour plus tard
- elasticsearch
- API
- json
---

## Notes sur ElasticSearch

### Introduction
En tant qu'AdminSys, on doit souvent intervenir sur les applications pour les installer, les mettre à jour, analyser ou purger les logs, les redémarrer, changer la configuration, ... On doit aussi intervenir sur les données pour les sauvegarder, les purger, les voir, les analyser, les transformer pour en tirer une certaine intelligence, ...

Ceci sont mes notes sur les éléments de l'API ElasticSearch que j'utilise. 

Dans la suite, je considère que le serveur ElasticSearch est configuré dans la variable ELASTICSEARCH_HOST de la façon suivante :
```
cedric@portable:~ export ELASTICSEARCH_HOST="http://monserveur.tld:9200"
```

### Utilisation dans un terminal, sans le poids du JSON
ElasticSearch fournit une entrée API qui est _cat. Cette entrée est très pratique pour être utilisée dans un terminal et être afffichée en mode "plat", pas en mode JSON. Exemple pour afficher les indices :

``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/indices"
green open index1   Ip1vYDhYTOKLk0_kMGaNjQ 1 0  65469 0  12.8mb  12.8mb
green open index2   piVclkiqQY-IeFCQ-eMlbg 1 0   1693 0  40.5mb  40.5mb
green open index3   1Se8IjIHQi2XZfytb11K7A 1 0  14638 0   2.8mb   2.8mb
green open index4   iEuoNPPKRIifBx38DT4Jag 1 0  10717 0   1.7mb   1.7mb
green open index5   TVLj8qJEToOMiCsa4khcxw 1 0   2046 0  71.8mb  71.8mb
green open index6   K4d4aINvStOK5EBxdq_Sjg 1 0   3444 0  89.8mb  89.8mb
green open index7   wQuuFxj1S5Ker69IzZ9isw 1 0   3319 0  80.4mb  80.4mb
green open index8   f2WpxYmYSXm02GCXzUWcVQ 1 0   3472 0 135.6mb 135.6mb
```

On peut passer un argument pour afficher le nom des colonnes :
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/indices?v"
health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   index1   Ip1vYDhYTOKLk0_kMGaNjQ 1   0   65469      0            12.8mb      12.8mb
green  open   index2   piVclkiqQY-IeFCQ-eMlbg 1   0    1693      0            40.5mb      40.5mb
green  open   index3   1Se8IjIHQi2XZfytb11K7A 1   0   14638      0             2.8mb       2.8mb
green  open   index4   iEuoNPPKRIifBx38DT4Jag 1   0   10717      0             1.7mb       1.7mb
green  open   index5   TVLj8qJEToOMiCsa4khcxw 1   0    2046      0            71.8mb      71.8mb
green  open   index6   K4d4aINvStOK5EBxdq_Sjg 1   0    3444      0            89.8mb      89.8mb
green  open   index7   wQuuFxj1S5Ker69IzZ9isw 1   0    3319      0            80.4mb      80.4mb
green  open   index8   f2WpxYmYSXm02GCXzUWcVQ 1   0    3472      0           135.6mb     135.6mb
```
On peut choisir aussi les colonnes que l'on souhaite afficher avec l'option h (pour header) :
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/indices?v&h=index,docs.count,store.size,pri.store.size"
index            docs.count store.size pri.store.size
monindex1                15    182.4kb        182.4kb
monindex2             65469     12.8mb         12.8mb
monindex3              1693     40.5mb         40.5mb
```
On peut trier selon une colonne avec l'option s (pour sort). Dans l'exemple, je trie selon la colonne docs.count avec un tri "descendant" (le plus grand nombre est en premier) :
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/indices?v&h=index,docs.count,store.size,pri.store.size&s=docs.count:desc"
index     docs.count store.size pri.store.size
monindex      816000    330.7mb        330.7mb
monindex      425021     93.6mb         93.6mb
monindex      379366      5.2gb          5.2gb
monindex      342819     81.3mb         81.3mb
monindex      340211     78.2mb         78.2mb
monindex      235439     50.3mb         50.3mb
monindex      157330     48.7mb         48.7mb
monindex      137939      4.1gb          4.1gb
monindex      122784     26.8mb         26.8mb
```
Remarque : il est possible de trier sur plusieurs colonnes :
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/indices?v&h=index,docs.count,store.size,pri.store.size&s=docs.count:desc,store.size:desc"
```
On peut voir les alias :
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_cat/aliases
alias                        index         filter routing.index routing.search
monjolialias1        monjoliindex1              -      -             -
monjolialias2        monjoliindex2              -      -             -
monjolialias3        monjoliindex3              -      -             -
```

### Gestion des index
#### Création d'un index
``` bash
cedric@portable:~$ curl -XPUT "${ELASTICSEARCH_HOST}/<leNomDeMonIndex>"
# exemple : je crée un index contenant des méta-datas sur des images que je nomme "mages-metadatas"
cedric@portable:~$ curl -XPUT "${ELASTICSEARCH_HOST}/images-metadatas"
```


#### Suppression d'un index
``` bash
cedric@portable:~$ curl -XDELETE "${ELASTICSEARCH_HOST}/<leNomDeMonIndex>"
# exemple : j'efface un index contenant des méta-datas sur des images que je nomme "mages-metadatas"
cedric@portable:~$ curl -XDELETE "${ELASTICSEARCH_HOST}/images-metadatas"
```

#### Voir les index



### Gestion des alias
#### Intérêt d'un alias
Un alias permet de donner un autre nom à un index. Un alias identique peut être donné à plusieurs index : dans ce cas, tous les documents de cet index sont rechercher. Différents cas d'utilisation :
* j'ai plein d'index et je ne veux pas que mon application sache lequel elle doit utiliser. Je crée donc un alias qui permet d'identifier l'index à utiliser. Dès lors, le code applicatif est plus simple.
* je crée plusieurs index (pour des raisons techniques par exemple) et j'indique à mon application les index qu'elle doit utiliser en utilisant le même alias pour tous les index. Là encore, le code applicatif est plus simple.
* mes données proviennent de l'extérieur et j'importe tous les jours une mise à jour complète de ces données dans un nouvel index. J'indique à mon application le bon index à utiliser en changeant l'alias. L'avantage est que la création d'un alias est ultra-rapide, comparitivement à un import de données. S'il y a beaucoup de données, la bascule d'un alias d'un index vers un autre est ultra-rapide et ne nécessite pas de redémarrer mon application.


#### Voir les alias
``` bash
cedric@portable:~$ curl "${ELASTICSEARCH_HOST}/_aliases"
```
``` json
{
  "<nomDeMonIndexe>": {
    "aliases": {
      "<NomDeMonAlias>": {}
    }
  },
  "<AutreNomDIndex>": {
    "aliases": {
      "<AutresNomDAlias>": {}
    }
  },
  ...
}
```

#### Trouver les index qui n'ont pas d'alias
Pour notre utilisation, nous créons un index par "site web" pour environ 120 sites web. Chaque index correspond à une version des données à un jour J. Pour mettre à jour un site web, nous créons un nouvel index daté du jour J (_"Jour J"_ == _"date des données"_) puis nous basculons les alias. Ce qui a pour conséquence : tout index n'ayant pas d'alias est un index _"outdated"_. Cet index devrait être supprimé. Donc, pour réaliser l'action "purge des données inutiles car outdated", nous avons besoin d'identifier "les index qui n'ont pas d'alias".

J'ai donc fait un script (un peu bourrin, il faut bien se l'avouer) d'identification des index qui n'ont pas d'alias :
``` bash
# récupération des index
curl -s ${ELASTICSEARCH_HOST}/_cat/indices/?h=index&s=index > indices.txt
# récupération des alias
curl -s ${ELASTICSEARCH_HOST}/_cat/aliases/?h=index > aliases.txt
# vérification que pour chaque index, on dispose d'un alias, sinon afficher le nom de cet index
cat indices.txt | while read a
do
   NB=`grep $a aliases.txt | wc -l `
   if [ ${NB} -eq 0 ]
      then
          echo "Indexe sans alias : $a"
   fi
done
```
Il est très probable qu'on peut améliorer ce script :
1. en utilisant un langage de plus haut niveau (Python, Perl) plus efficace en limitant les nombreux forks utilisés ici pour lancer différentes commandes
2. en ne faisant qu'une seule requête à ElasticSearch sur /\_aliases (en JSON) et en contrôlant qu'il n'y a rien dans la propriété _"aliases"_ de l'index correspondant.

Cependant, ici, nous avons fait au plus vite et au plus efficace en temps de "développement" tout en vérifiant que les performances sont correctes au vu du but à atteindre (le script est lancé une seule fois par jour et ne prend que quelques secondes). Bref, une optimisation ici ne nous serait pas forcément utile (car nous avons assez peu d'index/alias au final). Dans un autre cadre, il serait peut-être pertinent d'optimiser ce script.

#### Créer un alias
Pour créer un alias sur un index, il faut juste indiquer le nom de l'index qui sera la cible de l'alias.
``` bash
cedric@portable:~$ curl -X POST "${ELASTICSEARCH_HOST}/_aliases" -H 'Content-Type: application/json' -d 
 {
     "actions" : [
         { "add" : { "index" : "<leNomDeMonIndex>", "alias" : "<LeNomDeMonAlias>" } }
     ]
 }
'
```


#### Supprimer un alias
Supprimer un alias ne supprime pas l'index correspondant. On supprime juste l'alias.
``` bash
cedric@portable:~$ curl -X POST "${ELASTICSEARCH_HOST}/_aliases" -H 'Content-Type: application/json' -d 
 {
     "actions" : [
         { "add" : { "index" : "<leNomDeMonIndex>", "alias" : "<LeNomDeMonAlias>" } }
     ]
 }
'
```
On peut créer un alias sur 2 index différents. Dès lors, la recherche de documents dans cet alias va en réalité chercher dans tous les index. Exemple, ici, on va créer un alias nommé _"images-metadatas"_ qui _"pointe"_ sur 2 index différents :
``` bash
cedric@portable:~$ curl -X POST "${ELASTICSEARCH_HOST}/_aliases" -H 'Content-Type: application/json' -d 
 {
     "actions" : [
         { "remove" : { "index" : "images-metadatas-2018-01", "alias" : "images-metadatas" } },
         { "remove" : { "index" : "images-metadatas-2018-02", "alias" : "images-metadatas" } }
     ]
 }
'
```

#### "Déplacer" un alias
On peut _"déplacer"_ un alias : c'est à dire que l'on peut faire en sorte qu'un alias qui pointait sur un index pointe maintenant sur un autre index. Cette opération étant ultra-rapide, l'application (si elle est développée correctement) ne sera pas touchée (pas de redémarrage nécessaire). Imaginons que nous ayons un index _"images-metadatas"_ qui pointait vers un seul index _"images-metadatas-2018-01"_ et que l'on veut le _"déplacer"_ vers l'index _"images-metadatas-2018-02"_ :
``` bash
cedric@portable:~$ curl -X POST "${ELASTICSEARCH_HOST}/_aliases" -H 'Content-Type: application/json' -d 
 {
     "actions" : [
         { "remove" : { "index" : "images-metadatas-2018-01", "alias" : "images-metadatas" } },
         { "add" : { "index" : "images-metadatas-2018-02", "alias" : "images-metadatas" } }
     ]
 }
'
```

### Gestion des documents


### Erreurs déjà rencontrées
#### Result window is too large
Voici l'erreur complète : 
```
Result window is too large, from + size must be less than or equal to: [10000] but was [10020]. See the scroll api for a more efficient way to request large data sets. This limit can be set by changing the [index.max_result_window] index level parameter
```
Comme on ne pouvait pas régler définitivement le problème, pour une raison très précise, nous avons été contraint d'augmenter la limite, avec un impact sur les performances non négligeable. Pour cela, il faut modifier un paramètre au niveau de l'index, avant ou après l'import de données :
``` bash
curl -XPUT "${ELASTICSEARCH_HOST}/<nomIndex>/_settings" -d '{"index" : {"max_result_window": <nbMaxDoc>}}
```
où _nbMaxDoc_ correspond au nombre maximum d'éléments.
Exemple, si votre index se nomme _"images-metadatas"_ et que vous souhaitez augmenter le chiffre jusqu'à 400 000 :
``` bash
curl -XPUT "${ELASTICSEARCH_HOST}/images-metadatas/_settings" -d '{"index" : {"max_result_window": 400000}}
```
