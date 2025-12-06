Write-Host "Starting Nest.js API..." -ForegroundColor Cyan

# Check if PostgreSQL connection string exists
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file..." -ForegroundColor Yellow
    @"
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_NAME=nestjs_api
DB_SYNC=true
DB_LOGGING=false
JWT_SECRET=test-secret-key-123
JWT_EXPIRES_IN=1h
PORT=3000
NODE_ENV=development
"@ | Out-File .env -Encoding UTF8
}

# Start server
Write-Host "Starting server on http://127.0.0.1:3000..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
node dist/main.js
