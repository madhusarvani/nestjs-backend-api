Write-Host "This script will create the 'nestjs_api' database and update the project's .env file." -ForegroundColor Cyan

# Prompt for postgres password
$securePwd = Read-Host -AsSecureString "Enter postgres user password" 
$pw = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))

# Set PGPASSWORD for psql commands in this session
$env:PGPASSWORD = $pw

# Check connection
try {
    $check = & psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_database WHERE datname='nestjs_api';" 2>&1
} catch {
    Write-Host "Error connecting to PostgreSQL: $_" -ForegroundColor Red
    exit 1
}

if ($check -and $check.Trim() -eq '1') {
    Write-Host "Database 'nestjs_api' already exists." -ForegroundColor Yellow
} else {
    Write-Host "Creating database 'nestjs_api'..." -ForegroundColor Cyan
    & psql -U postgres -h localhost -c "CREATE DATABASE nestjs_api;"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Database 'nestjs_api' created." -ForegroundColor Green
    } else {
        Write-Host "Failed to create database (exit code: $LASTEXITCODE)." -ForegroundColor Red
    }
}

# Update .env file in project root
$envPath = Join-Path -Path (Get-Location) -ChildPath ".env"
$envContent = @"
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=$pw
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

try {
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Host ".env updated at $envPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to write .env: $_" -ForegroundColor Red
}

# Clear sensitive variables
$env:PGPASSWORD = ''
Remove-Variable pw -ErrorAction SilentlyContinue
Remove-Variable securePwd -ErrorAction SilentlyContinue

Write-Host "Setup script finished." -ForegroundColor Cyan
