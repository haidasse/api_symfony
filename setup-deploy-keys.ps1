# Script PowerShell pour générer les clés SSH pour le déploiement
# Usage: .\setup-deploy-keys.ps1

param(
    [string]$KeyName = "deploy_key",
    [string]$KeyPath = "$env:USERPROFILE\.ssh"
)

Write-Host "=== GitHub Secrets Setup Script ===" -ForegroundColor Cyan
Write-Host ""

# Créer le répertoire .ssh s'il n'existe pas
if (-not (Test-Path $KeyPath)) {
    Write-Host "Création du répertoire $KeyPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $KeyPath -Force | Out-Null
}

# Générer la clé SSH
$PrivateKeyPath = "$KeyPath\$KeyName"
$PublicKeyPath = "$KeyPath\$KeyName.pub"

if ((Test-Path $PrivateKeyPath) -or (Test-Path $PublicKeyPath)) {
    Write-Host "⚠️  Les clés SSH existent déjà!" -ForegroundColor Red
    $response = Read-Host "Voulez-vous les régénérer? (oui/non)"
    if ($response -ne "oui") {
        Write-Host "Opération annulée." -ForegroundColor Yellow
        exit
    }
    Remove-Item $PrivateKeyPath -Force -ErrorAction SilentlyContinue
    Remove-Item $PublicKeyPath -Force -ErrorAction SilentlyContinue
}

Write-Host "Génération de la clé SSH..." -ForegroundColor Cyan
ssh-keygen -t rsa -b 4096 -f $PrivateKeyPath -N ""

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Clés SSH générées avec succès!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Fichiers créés:" -ForegroundColor Cyan
    Write-Host "  Private: $PrivateKeyPath" -ForegroundColor White
    Write-Host "  Public:  $PublicKeyPath" -ForegroundColor White
    Write-Host ""
    
    # Afficher la clé privée pour GitHub
    Write-Host "=== CLE PRIVEE (pour GitHub Secret DEPLOY_KEY) ===" -ForegroundColor Yellow
    Write-Host "Copier tout le contenu ci-dessous:" -ForegroundColor White
    Write-Host ("=" * 50) -ForegroundColor Yellow
    Get-Content $PrivateKeyPath | Write-Host
    Write-Host ("=" * 50) -ForegroundColor Yellow
    Write-Host ""
    
    # Afficher la clé publique pour le serveur
    Write-Host "=== CLE PUBLIQUE (pour le serveur) ===" -ForegroundColor Yellow
    Write-Host "Copier tout le contenu ci-dessous dans ~/.ssh/authorized_keys sur votre serveur:" -ForegroundColor White
    Write-Host ("=" * 50) -ForegroundColor Yellow
    Get-Content $PublicKeyPath | Write-Host
    Write-Host ("=" * 50) -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "✅ Clés prêtes à être utilisées!" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de la génération des clés" -ForegroundColor Red
    exit 1
}

# Copier la clé privée dans le presse-papiers
Write-Host "Copie de la clé privée dans le presse-papiers..." -ForegroundColor Cyan
Get-Content $PrivateKeyPath | Set-Clipboard

Write-Host "✅ Clé privée copiée dans le presse-papiers!" -ForegroundColor Green
Write-Host ""
Write-Host "Prochaines étapes:" -ForegroundColor Cyan
Write-Host "1. Allez sur GitHub → Settings → Secrets and variables → Actions" -ForegroundColor White
Write-Host "2. Créez un nouveau secret 'DEPLOY_KEY' et collez la clé privée" -ForegroundColor White
Write-Host "3. Sur votre serveur, ajoutez la clé publique à ~/.ssh/authorized_keys" -ForegroundColor White
