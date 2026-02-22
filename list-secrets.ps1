# Script PowerShell pour lister tous les secrets à configurer
# Usage: .\list-secrets.ps1

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configuration des Secrets GitHub - Guide Complet          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

$secrets = @(
    @{
        Name = "DOCKER_USERNAME"
        Type = "String"
        Required = $true
        Description = "Nom d'utilisateur Docker Hub"
        Example = "mon_username"
        HowToGet = "https://hub.docker.com/settings/general"
    },
    @{
        Name = "DOCKER_PASSWORD"
        Type = "Secret"
        Required = $true
        Description = "Token/Password Docker Hub"
        Example = "dckr_pat_XXXXXXXXXXXXX"
        HowToGet = "https://hub.docker.com/settings/security → New Access Token"
    },
    @{
        Name = "DEPLOY_KEY"
        Type = "Secret"
        Required = $false
        Description = "Clé SSH privée pour le déploiement"
        Example = "-----BEGIN RSA PRIVATE KEY-----"
        HowToGet = "Exécutez: .\setup-deploy-keys.ps1"
    },
    @{
        Name = "DEPLOY_HOST"
        Type = "String"
        Required = $false
        Description = "Adresse du serveur de production"
        Example = "production.example.com"
        HowToGet = "Votre fournisseur d'hébergement"
    },
    @{
        Name = "DEPLOY_USER"
        Type = "String"
        Required = $false
        Description = "Utilisateur SSH du serveur"
        Example = "deployer"
        HowToGet = "Configuré sur votre serveur"
    },
    @{
        Name = "DEPLOY_PATH"
        Type = "String"
        Required = $false
        Description = "Chemin absolu du projet sur le serveur"
        Example = "/var/www/symfony"
        HowToGet = "Configuré lors du setup du serveur"
    }
)

Write-Host ""
Write-Host "📋 SECRETS REQUIS POUR LES WORKFLOWS" -ForegroundColor Yellow
Write-Host ""

# Afficher les secrets requis
$secrets | Where-Object { $_.Required } | ForEach-Object {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "🔑 $($_.Name)" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Type:        $($_.Type)" -ForegroundColor White
    Write-Host "Description: $($_.Description)" -ForegroundColor White
    Write-Host "Exemple:     $($_.Example)" -ForegroundColor Gray
    Write-Host "Source:      $($_.HowToGet)" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "📋 SECRETS OPTIONNELS (pour le déploiement)" -ForegroundColor Yellow
Write-Host ""

# Afficher les secrets optionnels
$secrets | Where-Object { -not $_.Required } | ForEach-Object {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "🔑 $($_.Name)" -ForegroundColor Blue
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Type:        $($_.Type)" -ForegroundColor White
    Write-Host "Description: $($_.Description)" -ForegroundColor White
    Write-Host "Exemple:     $($_.Example)" -ForegroundColor Gray
    Write-Host "Source:      $($_.HowToGet)" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  ETAPES DE CONFIGURATION                                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host ""
Write-Host "✅ ETAPE 1: Configuration de Docker Hub (requis)" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "1. Exécutez: .\test-docker-config.ps1" -ForegroundColor White
Write-Host "2. Entrez vos identifiants Docker Hub" -ForegroundColor White
Write-Host ""

Write-Host ""
Write-Host "✅ ETAPE 2: Configuration du Déploiement (optionnel)" -ForegroundColor Blue
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "1. Exécutez: .\setup-deploy-keys.ps1" -ForegroundColor White
Write-Host "2. Copier la clé privée (elle sera dans le presse-papiers)" -ForegroundColor White
Write-Host ""

Write-Host ""
Write-Host "✅ ETAPE 3: Ajouter les secrets sur GitHub" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "1. Allez sur: https://github.com/[user]/[repo]/settings/secrets/actions" -ForegroundColor White
Write-Host "2. Cliquez sur 'New repository secret'" -ForegroundColor White
Write-Host "3. Pour chaque secret de la liste ci-dessus:" -ForegroundColor White
Write-Host "   - Name: [nom du secret]" -ForegroundColor White
Write-Host "   - Value: [valeur du secret]" -ForegroundColor White
Write-Host "   - Click 'Add secret'" -ForegroundColor White
Write-Host ""

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  INFORMATIONS UTILES                                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host ""
Write-Host "📖 Documentation:" -ForegroundColor Cyan
Write-Host "   • GITHUB_SECRETS_SETUP.md - Guide détaillé" -ForegroundColor White
Write-Host "   • CI_CD_README.md - Documentation des workflows" -ForegroundColor White
Write-Host ""

Write-Host "🔗 Liens utiles:" -ForegroundColor Cyan
Write-Host "   • Docker Hub: https://hub.docker.com/settings/general" -ForegroundColor White
Write-Host "   • GitHub Secrets: https://github.com/[user]/[repo]/settings/secrets" -ForegroundColor White
Write-Host ""

Write-Host ""
Write-Host "✨ Pour commencer, exécutez d'abord:" -ForegroundColor Cyan
Write-Host "   .\test-docker-config.ps1" -ForegroundColor Yellow
Write-Host ""
