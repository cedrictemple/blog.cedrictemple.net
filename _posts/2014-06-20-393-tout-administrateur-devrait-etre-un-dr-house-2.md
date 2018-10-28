---
layout: post
title: "Tout administrateur devrait être un Dr House (2)"
date: 2014-06-20 12:26:40
image: /assets/img/dr_house_one_sick_bastard_by_alfinkahar-600x576.jpg
description: S'inspirer du fameux Dr House dans son boulot d'amin. sys.
category: 'administration système'
tags:
- administration système
twitter_text: Tout administrateur système devrait être un Dr House (2)
introduction: S'inspirer du fameux Dr House dans son boulot d'amin. sys.
---

Image [« Dr house one sick bastard »](http://alfinkahar.deviantart.com/art/dr-house-one-sick-bastard-152264790) par [alfinkahar](http://alfinkahar.deviantart.com/), Licence CC BY 3.0

On continue le parallèle entre Dr House et le métier d’administrateur commencé quelques mois plus tôt.

## « – Mais je n’ai jamais fait l’amour, il n’y a pas de possibilité de tomber enceinte autrement, comme en s’asseyant sur le siège des toilettes ?
## – Oui bien sur, s’il y a un garçon entre vous et le siège des toilettes. »

Le parallèle est évident. L’utilisateur a consulté des sites interdits et a ramené un joli virus. Personne n’admettra avoir consulté des sites pornographiques ou avoir téléchargé illégalement du contenu protégé par le droit d’auteur ou avoir ouvert le dernier fichier à la mode (« super_marrant.docx ») envoyé par le pote d’à côté. Il y a plusieurs manières de faire entendre raison à un utilisateur qui aurait réalisé ce genre de chose. La première, la plus évidente est de lui mettre le nez dedans: sortir les logs de connexion, identifier son IP, corréler avec une connexion légitime pour démonter son futur argument « ce n’est pas moi, on a forcément pris le contrôle de mon ordinateur » et lui dire tout cela par téléphone ou entre « quatre yeux ». La deuxième, beaucoup plus méchante, est de faire la même chose mais en public. La troisième, beaucoup plus sournoise, est de lui demander poliment, en essayant de l’amener à dire des éléments qui seront faciles à contrer et tout cela en public. Puis de démontrer le contraire et l’humilier. La quatrième, ma préférée et de loin, beaucoup plus subtile, est de supprimer, de ne pas accuser et de l’appeler pour rappeler des règles simples:

* n’utilisez pas de clé USB externe, ceci est d’autant plus vrai si vous la trouvez sur un parking, devant une centrale nucléaire ou dans votre parking alors que vous travaillez dans une centrale nucléaire (#comprendraQuiPourra comme disent les jeunes)
* ne ramenez pas de chez vous des fichiers, ne vous les envoyez pas non plus: votre ordinateur personnel peut être infecté
* n’ouvrez jamais, jamais, JAMAIS, non mais… JA-MAIS!!! J’ai dit JA-MAIS!!!! les documents/vidéos/fichiers que l’on vous envoie par messagerie, même si vous connaissez très bien la personne
* n’allez pas sur des sites pornographiques, vous pourriez attraper un virus (et vous faire licencier)
* ne récupérez pas des fichiers sur les torrents
* …

Comme « tout le monde ment », vous n’aurez pas d’aveux mais le message sera passé (sissi, si vous regardez bien, votre interlocuteur a fait « GLOUPS! » lorsque vous avez mis le doigt sur le sujet.

 
## « On ne prescrit pas de médicaments à partir d’hypothèses. Du moins plus depuis Tuskegee et Mengele. »

Lorsque l’on détecte un problème, il arrive qu’on ne sache pas exactement quelle est ou quelles sont les causes. Il est tentant parfois, sous la pression, d’essayer quelque chose. Parfois, quelque chose de désespéré. On a des hypothèses et on extrapole une « solution« . Par exemple, il y a le fameux « et si on redémarrait?« . La question à se poser est « pourquoi? qu’est ce qu’un redémarrage peut réaliser que je ne puisse pas« . Cela peut être un redémarrage de l’application ou un redémarrage complet du système. Le gros problème est qu’en ne sachant pas quelle sont les causes, le résultat de l’action peut être plus grave que de ne rien faire. Il m’est arrivé parfois, sous la pression, de « redémarrer » (un serveur d’application, une base de données ou un serveur) sans que je ne sache quelle était l’origine du problème. Selon mon ressenti personnel, c’est du 50/50 : une fois sur deux, le problème est effectivement résolu mais une fois sur deux, le problème empire (impossible de redémarrer l’application, vérification des partitions au redémarrage du serveur, arrêt de service complet pendant plusieurs dizaines de minutes, …). Mais même si le problème semble résolu, personne ne peut en être sûr: que s’est-il réellement passé? Le problème va-t’il revenir? Si oui, quand? Quelle sera la correction à apporter?

Il est beaucoup plus efficace d’identifier la cause réelle du problème que d’essayer bêtement un traitement, sans être sûr qu’il ne causera pas de dégâts plus importants. Tout traitement, tout médicament est potentiellement dangereux. Un redémarrage est aussi dangereux: des serveurs n’ont jamais voulu redémarrer (panne d’alimentation, crash disque définitif) après une tentative de redémarrage.

 

## « Je suis assez intelligent pour savoir ce que j’ignore. »

L’un des dangers du personnel médical est de ne pas suivre l’évolution de leur métier. De nombreux médicaments sont considérés comme inefficaces aujourd’hui alors qu’ils étaient recommandés par le passé. Certains sont même considérés comme particulièrement dangereux dans certains cas précis. Ces cas n’étaient pas connus auparavant. Suivre l’évolution de son domaine d’activité est très important pour éviter de faire des erreurs. Une erreur médicale peut entraîner des ennuis de santé, voire des dégâts irréversibles. Parfois cela entraîne la mort. Cela est énormément dommageable lorsque de nombreux articles existent sur le sujet, tant pour la personne qui subit que celle qui a fait l’erreur. Une erreur informatique peut engendrer une perte de temps, une perte de données peu importante (perte d’un fichier d’analyse de données ; à refaire), une perte de données critiques (perte de boites emails de plusieurs commerciaux) voire un désastre informatique entraînant la faillite de la société (perte de l’intégralité du fichier client sans possibilité de recours, toute la facturation est perdue, …).

Il existe plusieurs catégories de médecin. Le médecin généraliste, qui soigne les maladies courantes, voit régulièrement ses patients. Le spécialiste, lui, est dédié à un domaine: il dispose d’une expertise élevée mais sur un domaine très spécifique. Le généraliste fera appel à un confrère spécialisé en envoyant son patient vers le spécialiste qui pourra l’aider. Le transfert pourra être purement informel lors que le sujet est courant: « allez voir un ophtalmo, votre vue baisse ». Le transfert sera plus formel lors de la détection de symptômes sans identification précise: « douleurs abdominales récurrentes et aigues, aucun traitement courant n’a pu diminuer la douleur dans la durée. Les traitements X, Y et Z ont été administrés, sans succès. Propose de faire l’examen X ou tout autre examen que vous conseillerez. » L’administrateur généraliste, ayant sous sa responsabilité un système d’information étendu, devra faire appel à des spécialistes pour des cas particuliers, notamment sur des incidents complexes impliquant un haut niveau d’expertise. Il devra aussi faire appel à des experts lors de la mise en place de solution avancée, où le besoin d’obtenir un niveau de performance très élevé est nécessaire. Un administrateur généraliste ne peut pas connaître parfaitement toutes les technologies. Il doit donc savoir qu’il devra se faire aider sur des sujets très complexes. Son intelligence est là: savoir qu’il ne peut pas gérer tout sous SI seul. Il devra donc discuter avec les experts, les mettre dans les meilleures conditions possibles pour obtenir le résultat qu’il attend.

 

## « On ne risque pas d’échouer dans la vie, si on ne tente rien. »

Certains cas sont « désespérés ». Il faut agir rapidement, sans présence de l’expert pour sortir ce cas désespéré de la situation dramatique dans laquelle il se trouve. L’une des réactions régulièrement constatée est la paralysie complète. L’administrateur qui doit agir en est totalement incapable. La peur le bloque complètement. Il réfléchit beaucoup plus aux possibles conséquences négatives de ses actions plutôt qu’aux bénéfices de celles-ci. Concentré sur les conséquences négatives, il ne réussit plus à réfléchir ni à prendre une décision. Il est totalement bloqué dans l’inaction.

Or, on apprend énormément de ses échecs. Il faut, autant que possible éviter les échecs (évidemment). Cependant, on retient beaucoup plus les choses après un échec qu’après une parfaite réussite. Rester bloqué sans pouvoir agir alors qu’un problème s’aggrave de minutes en minutes ne vous apprendra strictement rien. Tenter des actions, analyser les logs, vérifier des statuts, lire les documentations vous apprendront énormément d’éléments, en peu de temps. Ne pas bouger alors que tout s’écroule vous fera passer pour un incompétent et plus personne n’aura confiance en vous.

 

## « On ne réfléchit à sa vie que quand on fait des erreurs. »

Après un échec, une erreur, il est nécessaire de faire une analyse la plus objective possible. Elle peut se réaliser formellement, par une revue des actions, par une discussion avec des personnes extérieures, par une expertise. Dans tous les cas, il ne faut jamais se voiler la face. Faire des erreurs est humain et normal. Ne faire aucune erreur démontre que vous n’êtes pas utilisé à votre meilleur potentiel. Vous êtes probablement beaucoup plus compétent que votre poste ne le requiert. Vous devez probablement vous ennuyer. Vous n’apprenez plus. Vous n’évoluez plus. Vous vous sclérosez. Ce n’est bon ni pour votre structure ni pour vous. Vous allez assurément partir dans quelques semaines ou quelques mois.

Il ne faut jamais se mentir lorsqu’on a fait une erreur. C’est le meilleur moyen pour ne pas retenir les leçons de celle-ci. Le processus de réflexion interne, de ruminer son erreur pour identifier les causes de celle-ci et les actions que l’on aurait du entreprendre est important. Il permet d’analyser en différentes étapes ses réflexions, ses décisions (agir vite? appeler une aide externe? demander de l’aide pour un diagnostique différentiel?), ses influences externes ou internes, ses actions, ses sentiments (peur, stress interne, stress externe, …). Ce processus va prendre du temps. Deux étapes se produisent généralement : une première analyse à chaud, qui dure plusieurs jours, durant lesquels l’auteur de l’erreur rumine son erreur. La deuxième phase se produit quelques semaines ou quelques mois après. Elle est une réflexion beaucoup plus distante, beaucoup plus objective et beaucoup plus profonde. Cette 2e phase permet d’avoir une analyse beaucoup plus large et inclus des éléments qui n’ont pas été pris en compte lors de la 1ère phase (« mon fils m’a empêché de dormir plusieurs jours, j’étais épuisé », « un ami est décédé, il était jeune, cela m’a beaucoup plus perturbée que je ne le pensais »).

Il faut profiter de ces phases de doute, de questionnement personnel pour pouvoir se remettre en cause et évoluer. Il ne faut pas hésiter à demander des conseils.
