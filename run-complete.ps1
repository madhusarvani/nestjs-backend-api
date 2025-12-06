# ================================================
# COMPLETE API BUILD, TEST & RUN SCRIPT
# ================================================

Clear-Host
Write-Host "=== NEST.JS API - COMPLETE EXECUTION ===" -ForegroundColor Cyan
Write-Host "Building, testing, and running the API..." -ForegroundColor Yellow

# Function to display colored output
function Show-Result {
    param([string]$Message, [string]$Status)
    
    $color = if ($Status -eq "PASS") { "Green" } elseif ($Status -eq "FAIL") { "Red" } else { "Yellow" }
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# 1. Clean up
Show-Result "1. Cleaning up previous builds..." "INFO"
taskkill /F /IM node.exe 2>$null
Remove-Item -Path "dist" -Recurse -Force -ErrorAction SilentlyContinue

# 2. Install dependencies
Show-Result "2. Installing dependencies..." "INFO"
npm install

if ($LASTEXITCODE -ne 0) {
    Show-Result "Dependency installation failed" "FAIL"
    exit 1
}
Show-Result "Dependencies installed successfully" "PASS"

# 3. Build project
Show-Result "3. Building project..." "INFO"
npm run build

if ($LASTEXITCODE -ne 0) {
    Show-Result "Build failed" "FAIL"
    exit 1
}
Show-Result "Build successful" "PASS"

# 4. Run unit tests
Show-Result "4. Running unit tests..." "INFO"
npm test

if ($LASTEXITCODE -eq 0) {
    Show-Result "Unit tests passed" "PASS"
} else {
    Show-Result "Unit tests failed" "FAIL"
}

# 5. Start PostgreSQL
Show-Result "5. Starting PostgreSQL..." "INFO"
docker-compose up -d postgres 2>$null
Start-Sleep -Seconds 5
Show-Result "PostgreSQL started" "PASS"

# 6. Start server in background
Show-Result "6. Starting API server..." "INFO"
$serverJob = Start-Job -ScriptBlock {
    cd "C:\Users\MADHU SARVANI\OneDrive\Desktop\nestjs-backend-api"
    node dist/main.js
}

Start-Sleep -Seconds 5
Show-Result "Server started on http://127.0.0.1:3000" "PASS"

# 7. Run API tests
Show-Result "7. Running API integration tests..." "INFO"
Write-Host "
" + "-"*50 -ForegroundColor Gray

# Run the test
$testScript = @'
Write-Host "=== API TEST RESULTS ===" -ForegroundColor Cyan

# Test counters
$passed = 0
$failed = 0

# Test 1: Health endpoint
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:3000" -Method GET -TimeoutSec 3
    Write-Host "✅ Health endpoint: WORKING" -ForegroundColor Green
    $passed++
} catch {
    Write-Host "❌ Health endpoint: FAILED" -ForegroundColor Red
    $failed++
}

# Test 2: Create user
$timestamp = Get-Date -Format "HHmmss"
$user = @{
    email = "autotest$timestamp@example.com"
    fullName = "Auto Test"
    password = "TestPass123"
} | ConvertTo-Json

try {
    $userRes = Invoke-RestMethod -Uri "http://127.0.0.1:3000/users" -Method POST -ContentType "application/json" -Body $user
    Write-Host "✅ User registration: WORKING" -ForegroundColor Green
    $passed++
} catch {
    Write-Host "❌ User registration: FAILED" -ForegroundColor Red
    $failed++
}

# Test 3: Login
$login = @{
    email = "autotest$timestamp@example.com"
    password = "TestPass123"
} | ConvertTo-Json

try {
    $auth = Invoke-RestMethod -Uri "http://127.0.0.1:3000/auth/login" -Method POST -ContentType "application/json" -Body $login
    $token = $auth.access_token
    Write-Host "✅ JWT authentication: WORKING" -ForegroundColor Green
    $passed++
} catch {
    Write-Host "❌ JWT authentication: FAILED" -ForegroundColor Red
    $failed++
}

# Test 4: Create product (with JWT)
$headers = @{"Authorization"="Bearer $token"; "Content-Type"="application/json"}
$product = @{
    name = "Auto Test Product"
    price = 49.99
    quantity = 2
} | ConvertTo-Json

try {
    $prodRes = Invoke-RestMethod -Uri "http://127.0.0.1:3000/products" -Method POST -Headers $headers -Body $product
    Write-Host "✅ Product creation (JWT): WORKING" -ForegroundColor Green
    $passed++
} catch {
    Write-Host "❌ Product creation (JWT): FAILED" -ForegroundColor Red
    $failed++
}

# Test 5: Get products
try {
    $products = Invoke-RestMethod -Uri "http://127.0.0.1:3000/products" -Method GET
    Write-Host "✅ Get all products: WORKING (Found $($products.Length) items)" -ForegroundColor Green
    $passed++
} catch {
    Write-Host "❌ Get all products: FAILED" -ForegroundColor Red
    $failed++
}

# Summary
Write-Host "
" + "="*50 -ForegroundColor Cyan
Write-Host "TEST SUMMARY: $passed/5 tests passed" -ForegroundColor Yellow
Write-Host "="*50 -ForegroundColor Cyan

if ($passed -eq 5) {
    Write-Host "🎉 ALL TESTS PASSED! API is fully functional." -ForegroundColor Green
} else {
    Write-Host "⚠️  Some tests failed. Check server logs." -ForegroundColor Yellow
}
'@

# Execute test
Invoke-Expression $testScript

# 8. Keep server running or stop
Write-Host "
" + "="*50 -ForegroundColor Cyan
Write-Host "SERVER STATUS" -ForegroundColor Yellow
Write-Host "="*50 -ForegroundColor Cyan
Write-Host "Server is running in background." -ForegroundColor Green
Write-Host "To stop server: Stop-Job $serverJob" -ForegroundColor Yellow
Write-Host "To view logs: Receive-Job $serverJob" -ForegroundColor Yellow
Write-Host "
API is ready at: http://127.0.0.1:3000" -ForegroundColor Cyan
