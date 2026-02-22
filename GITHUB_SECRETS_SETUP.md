# Guide Configuration des Secrets GitHub

## 📋 Secrets Requis

### 1. Pour le Docker Build & Push
Ces secrets permettent de construire et pousser les images Docker.

```
DOCKER_USERNAME      # Votre nom d'utilisateur Docker Hub
DOCKER_PASSWORD      # Votre token/password Docker Hub
```

### 2. Pour le Déploiement en Production
Ces secrets permettent le déploiement automatisé sur votre serveur.

```
DEPLOY_KEY          # Clé SSH privée
DEPLOY_HOST         # Adresse IP ou domaine du serveur
DEPLOY_USER         # Utilisateur SSH sur le serveur
DEPLOY_PATH         # Chemin absolu du projet sur le serveur
```

---

## 🔧 Comment Configurer les Secrets

### Étape 1: Accéder aux Secrets GitHub

1. Allez sur votre dépôt GitHub
2. Cliquez sur **Settings** (Paramètres)
3. Dans le menu de gauche, allez à **Secrets and variables** → **Actions**

### Étape 2: Ajouter les Secrets

Cliquez sur **New repository secret** et ajoutez chaque secret.

---

## 🐳 Configuration Docker Hub

### Obtenir vos identifiants Docker Hub

1. Créez un compte sur [Docker Hub](https://hub.docker.com)
2. **DOCKER_USERNAME** : Votre nom d'utilisateur Docker Hub
3. **DOCKER_PASSWORD** : 
   - Allez sur Docker Hub → Account Settings → Security
   - Cliquez sur "New Access Token"
   - Générez un nouveau token
   - Copiez le token généré

### Ajouter les secrets Docker

```
Name: DOCKER_USERNAME
Value: votre_username_docker

---

Name: DOCKER_PASSWORD
Value: votre_token_docker
```

---

## 🚀 Configuration du Déploiement

### Générer une Clé SSH pour le Déploiement

**Sur votre machine locale (Windows PowerShell):**

```powershell
# Générer une clé SSH
ssh-keygen -t rsa -b 4096 -f C:\Users\lenovo\.ssh\deploy_key -N ""

# Afficher la clé privée (pour GitHub)
Get-Content C:\Users\lenovo\.ssh\deploy_key

# Afficher la clé publique (pour le serveur)
Get-Content C:\Users\lenovo\.ssh\deploy_key.pub
```

### Sur votre Serveur de Production

1. **SSH sur votre serveur**
```bash
ssh user@your-server.com
```

2. **Ajouter la clé publique**
```bash
mkdir -p ~/.ssh
cat >> ~/.ssh/authorized_keys << 'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... (coller la clé publique)
EOF

chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

3. **Créer le répertoire du projet**
```bash
sudo mkdir -p /var/www/symfony
sudo chown deployer:deployer /var/www/symfony
cd /var/www/symfony
git init --bare
```

### Ajouter les Secrets GitHub Deployment

```
Name: DEPLOY_KEY
Value: (Contenu de la clé privée générée)

---

Name: DEPLOY_HOST
Value: your-server.com (ou l'adresse IP)

---

Name: DEPLOY_USER
Value: deployer (l'utilisateur SSH)

---

Name: DEPLOY_PATH
Value: /var/www/symfony
```

---

## ✅ Vérification

### Tester la Connexion SSH

```powershell
# Remplacer par vos informations
ssh -i C:\Users\lenovo\.ssh\deploy_key deployer@your-server.com "echo 'SSH Connection OK'"
```

### Tester Docker Hub

```powershell
# Remplacer par votre username
docker login -u your_docker_username
# Entrez votre token quand demandé
```

---

## 🔐 Sécurité

- **Ne jamais commiter** les clés privées ou tokens
- Utilisez des secrets GitHub pour tous les tokens sensibles
- Régulièrement **rotationner les tokens/clés**
- Limite les permissions des tokens au minimum requis

---

## 📝 Résumé des Variables d'Environnement

| Secret | Type | Exemple |
|--------|------|---------|
| DOCKER_USERNAME | String | `mon_username` |
| DOCKER_PASSWORD | Secret | Token Docker Hub |
| DEPLOY_KEY | Secret | Clé SSH privée RSA |
| DEPLOY_HOST | String | `production.example.com` |
| DEPLOY_USER | String | `deployer` |
| DEPLOY_PATH | String | `/var/www/symfony` |

---

## 🚨 Troubleshooting

### Docker Push échoue
- Vérifiez que DOCKER_USERNAME et DOCKER_PASSWORD sont corrects
- Générez un nouveau token Docker Hub
- Assurez-vous que le repository Docker Hub existe

### Déploiement échoue
- Vérifiez que la clé SSH est valide
- Confirmez que le serveur est accessible
- Vérifiez les permissions de fichiers sur le serveur
- Consultez les logs GitHub Actions pour plus de détails

### Connexion SSH refuse
- Vérifiez que authorized_keys est bien configuré
- Vérifiez les permissions (600 pour authorized_keys, 700 pour .ssh)
- Essayez une connexion manuelle avec la clé
