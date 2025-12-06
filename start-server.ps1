Write-Host "Starting NestJS Backend API..." -ForegroundColor Cyan

# Check if already running
$portCheck = netstat -ano | findstr :3000
if ($portCheck) {
    Write-Host "Server is already running on port 3000" -ForegroundColor Yellow
    Write-Host "Checking health..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:3000" -Method GET -ErrorAction Stop
        Write-Host "✅ Server is healthy: $($response.message)" -ForegroundColor Green
        exit 0
    } catch {
        Write-Host "⚠️  Port 3000 is occupied but server may not be responding" -ForegroundColor Yellow
        Write-Host "Trying to kill process on port 3000..." -ForegroundColor Yellow
        
        # Kill process on port 3000
        $pidToKill = (netstat -ano | findstr :3000 | select-string "LISTENING").ToString().Split()[-1]
        if ($pidToKill) {
            taskkill /PID $pidToKill /F
            Write-Host "Killed process $pidToKill" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
    }
}

# Install dependencies if needed
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Build the project
Write-Host "Building project..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Check for TypeScript errors." -ForegroundColor Red
    exit 1
}

# Start the server
Write-Host "Starting server on http://localhost:3000..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "
=== SERVER LOGS ===" -ForegroundColor Cyan
node dist/main.js
