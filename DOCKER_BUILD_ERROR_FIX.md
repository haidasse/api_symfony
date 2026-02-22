# Guide de Dépannage - Docker Build Error

## ❌ Erreur : `invalid tag "/symfony-myfirst-project:sha-2a6e39c"`

### Cause
Le secret `DOCKER_USERNAME` n'était pas configuré sur GitHub, donc le tag Docker était mal formaté :
```
/symfony-myfirst-project:sha-2a6e39c   ❌ WRONG (pas de username)
username/api-symfony:sha-2a6e39c       ✅ CORRECT
```

### ✅ Solution

#### Étape 1: Générer un token Docker Hub

1. Allez sur **https://hub.docker.com/settings/security**
2. Cliquez sur **"New Access Token"**
3. Donnez un nom: `GitHub Actions`
4. Cliquez sur **"Generate"**
5. **Copiez le token** (vous ne pourrez pas le voir après)

#### Étape 2: Ajouter les secrets GitHub

1. Allez sur votre dépôt: **https://github.com/haidasse/api_symfony**
2. Cliquez sur **Settings** → **Secrets and variables** → **Actions**
3. Cliquez sur **"New repository secret"**

**Créez deux secrets:**

**Secret 1:**
```
Name:  DOCKER_USERNAME
Value: votre_username_docker
```

**Secret 2:**
```
Name:  DOCKER_PASSWORD
Value: votre_token_docker
```

#### Étape 3: Vérifier la configuration

Avant de relancer le workflow:

```bash
# Testez Docker Hub localement
docker login -u votre_username_docker
# Entrez votre token quand demandé
```

#### Étape 4: Relancer le workflow

1. Allez sur **Actions** dans votre dépôt
2. Sélectionnez le workflow **"Docker Build & Push"**
3. Cliquez sur **"Run workflow"** → **"Run workflow"**

### 📋 Checklist

- [ ] Token Docker Hub créé
- [ ] Secret `DOCKER_USERNAME` ajouté sur GitHub
- [ ] Secret `DOCKER_PASSWORD` ajouté sur GitHub  
- [ ] Secrets vérifiés dans Settings → Secrets
- [ ] Workflow relancé
- [ ] Image générée sur Docker Hub

### 🔍 Vérifier le succès

Allez sur **https://hub.docker.com/r/votre_username/api-symfony** et vous devriez voir:
- L'image Docker construite
- Les tags (sha-xxx, latest, etc.)
- La taille et les informations

### 🆘 Si cela ne fonctionne toujours pas

```bash
# Vérifier la syntaxe du workflow
docker run --rm -i ghcr.io/rhysd/actionlint < .github/workflows/docker.yml

# Vérifier les logs GitHub Actions
# Allez sur Actions et consultez les logs détaillés du workflow
```

### 📚 Ressources

- [Docker Hub - New Access Token](https://hub.docker.com/settings/security)
- [GitHub Actions - Secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
