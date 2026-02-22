# Script PowerShell pour tester la configuration Docker Hub
# Usage: .\test-docker-config.ps1

Write-Host "=== Test Docker Hub Configuration ===" -ForegroundColor Cyan
Write-Host ""

# Vérifier que Docker est installé
Write-Host "Vérification de Docker..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker est installé" -ForegroundColor Green

# Demander les identifiants Docker Hub
$dockerUsername = Read-Host "Entrez votre nom d'utilisateur Docker Hub"
if ([string]::IsNullOrEmpty($dockerUsername)) {
    Write-Host "❌ Nom d'utilisateur requis" -ForegroundColor Red
    exit 1
}

$dockerPassword = Read-Host "Entrez votre token Docker Hub (ou password)" -AsSecureString
$dockerPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($dockerPassword))

Write-Host ""
Write-Host "Test de connexion à Docker Hub..." -ForegroundColor Yellow

# Tester la connexion
$dockerLoginResult = echo $dockerPasswordPlain | docker login -u $dockerUsername --password-stdin

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Connexion réussie à Docker Hub!" -ForegroundColor Green
    Write-Host ""
    
    # Récupérer les informations Docker
    Write-Host "Récupération des informations..." -ForegroundColor Yellow
    docker info | Select-String "Username|Registries" | Write-Host -ForegroundColor White
    
    Write-Host ""
    Write-Host "=== Secrets à ajouter sur GitHub ===" -ForegroundColor Cyan
    Write-Host "DOCKER_USERNAME: $dockerUsername" -ForegroundColor White
    Write-Host "DOCKER_PASSWORD: (votre token/password)" -ForegroundColor White
    
    Write-Host ""
    Write-Host "Instructions pour GitHub:" -ForegroundColor Yellow
    Write-Host "1. Allez sur votre dépôt GitHub" -ForegroundColor White
    Write-Host "2. Settings → Secrets and variables → Actions" -ForegroundColor White
    Write-Host "3. Créez 'DOCKER_USERNAME' avec la valeur: $dockerUsername" -ForegroundColor White
    Write-Host "4. Créez 'DOCKER_PASSWORD' avec votre token/password" -ForegroundColor White
    
    Write-Host ""
    Write-Host "Pour générer un token sur Docker Hub:" -ForegroundColor Yellow
    Write-Host "1. Allez sur https://hub.docker.com/settings/security" -ForegroundColor White
    Write-Host "2. Cliquez sur 'New Access Token'" -ForegroundColor White
    Write-Host "3. Donnez-lui un nom (ex: 'GitHub Actions')" -ForegroundColor White
    Write-Host "4. Copiez le token et utilisez-le comme DOCKER_PASSWORD" -ForegroundColor White
    
} else {
    Write-Host "❌ Erreur de connexion à Docker Hub" -ForegroundColor Red
    Write-Host "Vérifiez vos identifiants" -ForegroundColor Red
    exit 1
}

# Logout
docker logout | Out-Null
Write-Host ""
Write-Host "✅ Session Docker fermée (logout effectué)" -ForegroundColor Green
