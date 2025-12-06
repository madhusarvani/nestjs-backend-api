Write-Host "=== JWT TOKEN DEBUG ===" -ForegroundColor Cyan

# First login to get token
$loginData = @{
    email = "user20251206112359@example.com"
    password = "TestPass123"
} | ConvertTo-Json

try {
    $auth = Invoke-RestMethod -Uri "http://127.0.0.1:3000/auth/login" -Method POST -ContentType "application/json" -Body $loginData
    $token = $auth.access_token
    
    Write-Host "✅ Token received!" -ForegroundColor Green
    Write-Host "Full token: $token" -ForegroundColor Gray
    Write-Host "
Token parts:" -ForegroundColor Yellow
    
    # Decode JWT (middle part is payload)
    $tokenParts = $token.Split('.')
    if ($tokenParts.Length -eq 3) {
        # Decode payload (middle part)
        $payload = $tokenParts[1]
        # Add padding if needed
        while ($payload.Length % 4) {
            $payload += "="
        }
        $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload))
        Write-Host "Payload: $decoded" -ForegroundColor Cyan
        
        $payloadObj = $decoded | ConvertFrom-Json
        Write-Host "
Decoded claims:" -ForegroundColor Green
        Write-Host "  User ID (sub): $($payloadObj.sub)" -ForegroundColor Cyan
        Write-Host "  Email: $($payloadObj.email)" -ForegroundColor Cyan
        Write-Host "  isAdmin: $($payloadObj.isAdmin)" -ForegroundColor Cyan
        Write-Host "  Expires: $($payloadObj.exp)" -ForegroundColor Cyan
    }
    
    # Test the token
    Write-Host "
Testing token with product creation..." -ForegroundColor Yellow
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $prodData = @{
        name = "Debug Test Product"
        description = "Testing token validation"
        price = 99.99
        quantity = 1
        status = "active"
    } | ConvertTo-Json
    
    try {
        $product = Invoke-RestMethod -Uri "http://127.0.0.1:3000/products" -Method POST -Headers $headers -Body $prodData
        Write-Host "✅ Product created with token! ID: $($product.id)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Product creation failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Response: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Login failed: $_" -ForegroundColor Red
}
