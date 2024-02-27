# Plateforme de Collaboration Sécurisée

## Introduction

Notre plateforme de collaboration sécurisée offre un environnement complet pour la collaboration d'équipe, la communication, et la gestion de projets. Utilisant Docker Compose pour orchestrer plusieurs services, notre solution garantit une expérience utilisateur sécurisée et intégrée, en se basant sur l'authentification OIDC avec Keycloak.

> Attention, cette version n'est pas prête pour la production et des changements importants sont prévus.
> Ce projet en général est principalement un projet de recherche, et ne doit a priori pas être utilisé dans un contexte où la perte de données n'est pas jugée acceptable.

## Architecture

La plateforme se compose des services suivants :

- **Nginx** : Agit comme reverse proxy principal, fournissant un point de communication sécurisé entre l'environnement interne et le monde extérieur.
- **Keycloak** : Centralise la gestion des utilisateurs, offrant des fonctionnalités de création de comptes, IAM, et authentification OIDC.
- **JupyterHub** : Permet une gestion multi-utilisateur de Jupyter, avec Docker Spawner pour attribuer à chaque utilisateur sa propre instance JupyterLab.
- **GitLab** : Service de gestion de code source, intégré avec Jupyter pour une collaboration et gestion de projet efficace.
- **Element Matrix** : Serveur de chat sécurisé, offrant des communications internes protégées.
- **Jitsi** : Solution de vidéoconférence pour les réunions en ligne.
- **Seafile + OnlyOffice** : Services de gestion de documents et de collaboration en temps réel sur des documents, feuilles de calcul, et présentations.

## Prérequis

- Docker et Docker Compose installés sur votre système.
- Connaissances de base de Docker et de la configuration de services web.
- Nom de domaine valide configuré, certificats SSL pour HTTPS
- Gestion des sous-domaines : les services seront configurés pour utiliser chacun leur sous-domaine par rapport à `EDS_DOMAIN` (par exemple jupyter.domain-name.example pour le service jupyter). Notez que `EDS_DOMAIN` peut lui-même être constitué de sous-domaine, et par exemple si vous souhaitez servir ce service à partir de eds.truc.mon-domaine.net, alors eds.truc.mon-domaine.net servira la page d'accueil du site, et jupyter.eds.truc.mon-domaine.net servira le service jupyter.
Les noms de service à utiliser sont ceux servis par le reverse proxy : [](nginx/nginx_template.conf).
NB les certificats SSL devront être valides pour ces sous-domaines.


## Installation

### Note

Le fichier principal qui sert de configuration est le fichier `./.env` à la racine de ce dépôt.

Les éléments dans `./config` sont créés automatiquement par le processus d'installation, en s'appuyant sur les informations du `.env` que vous aurez configuré. Vous pouvez modifier ces fichiers librement, mais ils pourraient être écrasés si un script d'installation est exécuté par la suite (par exemple pour mettre à jour les configurations suite à une mise à jour de ce dépôt).
Si vous avez une copie de sauvegarde de votre .env, vous ne devriez pas avoir besoin de sauvegarder les éléments du dossier `config/` car vous pourrez en générer le contenu à nouveau en rejouant le script d'installation après avoir cloné ce dépôt.

Les éléments dans `./data/` ne sont jamais modifiés par des scripts d'installation, et correspondent à l'ensemble des fichiers / dossiers qui sont montés par docker et persistent les données créées lors de l'utilisation du système (soit des données des utilisateurs, soit des données qui doivent être conservées d'un lancement à l'autre pour le bon fonctionnement des applications).
Ces données sont celles dont vous devez vous assurer de conserver une sauvegarde.

Enfin, les espaces utilisateur des instances Jupyter créées par JupyterLab sont gérées par des volumes docker et ne sont donc pas disponible dans le système de fichiers. Un changement prochain pour un stockage dans ./data sera réalisé.

### Processus d'installation

Clonez le dépôt de la plateforme. Naviguez à la racine du projet, et créez un fichier '.env' en copiant le '.env.template'.
Adaptez ce fichier à vos besoins, en configurant notamment le nom de domaine et le chemin vers les certificats SSL à utiliser.

Exécutez `./install.sh` pour réaliser la configuration initiale.
Ce script :

    - crée des certificats SSL auto-signés pour les communications entre les services à l'intérieur de la bulle sécurisée
    - crée des mots de passe aléatoire forts pour les différents services qui le nécessitent
    - configure chaque service en instanciant les éventuels fichiers gabarits (afin d'y insérer les noms de domaine et secrets à utiliser) (voir le Readme et install.sh de chaque service qui en possède un) :
        - nginx : instancie nginx_template.conf en nginx.conf en insérant le nom de domaine à utiliser, si aucun certificat SSL n'est fourni, crée des certificats auto-signés permettant de réaliser des tests en phase de développement (bientôt gestion automatisée avec Letsencrypt pour créer automatiquement des certificats de production)
        - Keycloak : réalise une première configuration en créant le(s) client(s) fournisseurs d'authentification, et les éventuels utilisateurs listés dans [](./config/keycloak/user.yml) (fichier patron à utiliser dans le répertoire [](./keycloak) )
        - Jupyter : construit l'image docker du jupyterlab à instancier pour les utilisateurs
        - Matrix/Element : instancie les fichiers de configuration

Ce script d'installation peut être lancé autant de fois que nécessaire, et n'altère pas les données persistées des différents services.
Par exemple, les configurations éventuellement réalisées dans Keycloak ne sont pas écrasées, aussi si vous souhaitez que le script d'installation remplace les données existentes il vous faudra d'abord les supprimer manuellement depuis l'interface d'administration de Keycloak. 

