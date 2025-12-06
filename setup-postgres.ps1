# PostgreSQL Setup Script for Windows
# This script sets up PostgreSQL for the NestJS Backend API

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "PostgreSQL Setup for NestJS Backend API" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if PostgreSQL is installed
Write-Host "Checking if PostgreSQL is installed..." -ForegroundColor Yellow

$pgPath = Get-Command psql -ErrorAction SilentlyContinue

if ($null -eq $pgPath) {
    Write-Host "PostgreSQL not found. Attempting to download installer..." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please follow these steps:" -ForegroundColor Cyan
    Write-Host "1. Go to: https://www.postgresql.org/download/windows/" -ForegroundColor White
    Write-Host "2. Download PostgreSQL 15 or latest" -ForegroundColor White
    Write-Host "3. Run the installer" -ForegroundColor White
    Write-Host "4. Remember the 'postgres' user password" -ForegroundColor Yellow
    Write-Host "5. Keep default port: 5432" -ForegroundColor White
    Write-Host "6. Run this script again after installation" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host "✓ PostgreSQL found at: $($pgPath.Source)" -ForegroundColor Green
Write-Host ""

# Get database credentials from user
Write-Host "Enter PostgreSQL Credentials:" -ForegroundColor Cyan
Write-Host ""

$postgresPassword = Read-Host "Enter postgres user password (from installation)" -AsSecureString
$postgresPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($postgresPassword))

Write-Host ""
Write-Host "Creating database 'nestjs_api'..." -ForegroundColor Yellow

# Set environment variable for password
$env:PGPASSWORD = $postgresPasswordPlain

try {
    # Create database
    & psql -U postgres -h localhost -c "CREATE DATABASE nestjs_api;" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Database created successfully" -ForegroundColor Green
    } else {
        Write-Host "Database may already exist (this is OK)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Updating .env file..." -ForegroundColor Yellow

# Update .env file with credentials
$envContent = @"
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=$postgresPasswordPlain
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_here_change_in_production
JWT_EXPIRATION=3600

# App Configuration
APP_PORT=3000
NODE_ENV=development
"@

$envPath = "$PSScriptRoot\.env"
Set-Content -Path $envPath -Value $envContent -Encoding UTF8

Write-Host "✓ .env file updated" -ForegroundColor Green
Write-Host ""

# Clear password from memory
Remove-Variable postgresPasswordPlain
$env:PGPASSWORD = ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: npm run build" -ForegroundColor White
Write-Host "2. Run: npm start" -ForegroundColor White
Write-Host ""
Write-Host "Expected output:" -ForegroundColor Cyan
Write-Host "[Nest] XXXX  - XX/XX/XXXX, XX:XX:XX am LOG [TypeOrmModule] Initialized database connection" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"
