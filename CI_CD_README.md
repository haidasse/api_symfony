# Symfony MyFirst Project - CI/CD Documentation

## GitHub Actions Workflows

Ce projet utilise GitHub Actions pour l'intégration continue et le déploiement continu.

### 1. **Tests Workflow** (`.github/workflows/tests.yml`)

- **Déclenché sur** : push et pull requests sur `main` et `develop`
- **Actions** :
  - Teste avec PHP 8.2 et 8.3
  - Installation des dépendances Composer
  - Création de la base de données de test
  - Exécution des migrations
  - Exécution de PHPUnit
  - Vérification du code avec PHP CodeSniffer
  - Analyse statique avec PHPStan

### 2. **Code Quality Workflow** (`.github/workflows/quality.yml`)

- **Déclenché sur** : push et pull requests sur `main` et `develop`
- **Actions** :
  - Analyse statique du code avec PHPStan
  - Vérification des standards de code (PSR-12)
  - Vérification des vulnérabilités de sécurité

### 3. **Docker Build Workflow** (`.github/workflows/docker.yml`)

- **Déclenché sur** : push et tags
- **Actions** :
  - Construction et push de l'image Docker
  - Création de tags automatiques (branch, version, SHA, latest)
  - Mise en cache des layers Docker

**Secrets requis** :
```
DOCKER_USERNAME    # Votre nom d'utilisateur Docker Hub
DOCKER_PASSWORD    # Votre token Docker Hub
```

### 4. **Deploy Workflow** (`.github/workflows/deploy.yml`)

- **Déclenché sur** : push sur `main` ou création de tags
- **Actions** :
  - SSH vers le serveur de déploiement
  - Pull du code
  - Installation des dépendances
  - Cache clear
  - Migrations de base de données

**Secrets requis** :
```
DEPLOY_KEY         # Clé SSH privée
DEPLOY_HOST        # Adresse du serveur
DEPLOY_USER        # Utilisateur SSH
DEPLOY_PATH        # Chemin du projet sur le serveur
```

## Configuration Locale

### .env.test
Avant de lancer les tests localement, créez un fichier `.env.test` :

```bash
cp .env .env.test
echo "DATABASE_URL=mysql://symfony:symfony@127.0.0.1:3306/symfony_test" >> .env.test
```

### Exécuter les tests localement

```bash
# PHPUnit
php bin/phpunit

# PHP CodeSniffer
php vendor/bin/phpcs --standard=PSR12 src/

# PHPStan
php vendor/bin/phpstan analyse src/
```

## Configuration des Secrets GitHub

1. Allez sur votre dépôt GitHub
2. Settings → Secrets and variables → Actions
3. Ajouter les secrets suivants selon vos besoins :

### Pour le Docker Build
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

### Pour le Déploiement
- `DEPLOY_KEY` (Contenu de votre clé SSH privée)
- `DEPLOY_HOST` (ex: example.com)
- `DEPLOY_USER` (ex: deployer)
- `DEPLOY_PATH` (ex: /var/www/symfony)

## Architecture Docker

Le projet inclut une configuration Docker complète :

- **PHP 8.2 FPM** - Conteneur d'application
- **Nginx** - Serveur web (port 80)
- **MySQL 8.0** - Base de données (port 3307)

Démarrer les conteneurs :
```bash
docker-compose up -d
```

Accéder à l'application : `http://localhost`

## Git Workflow

### Branches principales
- `main` - Production (protégée)
- `develop` - Développement

### Créer une branche feature
```bash
git checkout -b feature/ma-feature develop
```

### Créer une pull request
1. Push votre branche
2. Créez une PR vers `develop` ou `main`
3. Attendez la validation des CI/CD checks
4. Mergez après approbation

## Standards de Code

Le projet respecte les standards suivants :

- **PSR-12** : Standard de codage PHP
- **PHPStan Level 5** : Analyse statique
- **Symfony Best Practices** : Conventions Symfony

## Troubleshooting

### Tests qui échouent
- Vérifiez que `.env.test` existe
- Vérifiez la connexion à la base de données
- Consultez les logs : `docker-compose logs`

### Docker build qui échoue
- Vérifiez que Docker est lancé
- Nettoyer le cache : `docker system prune -a`
- Rebuildez : `docker-compose build --no-cache`

### Déploiement qui échoue
- Vérifiez la clé SSH dans les secrets
- Vérifiez les permissions sur le serveur
- Consultez les logs GitHub Actions
