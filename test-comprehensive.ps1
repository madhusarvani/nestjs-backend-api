Write-Host "=== COMPREHENSIVE API TEST SUITE ===" -ForegroundColor Cyan
Write-Host "Testing all 15 endpoints`n" -ForegroundColor Yellow

$baseUrl = "http://127.0.0.1:3000"
$passed = 0
$failed = 0

# Test 1: GET /
Write-Host "1. GET /" -ForegroundColor Cyan
try {
    $r = Invoke-RestMethod "$baseUrl/" -Method GET
    if ($r.status -eq "OK") { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ } 
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 2: GET /health
Write-Host "2. GET /health" -ForegroundColor Cyan
try {
    $r = Invoke-RestMethod "$baseUrl/health" -Method GET
    if ($r.status -eq "healthy") { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 3: POST /users (Create user)
Write-Host "3. POST /users (Create)" -ForegroundColor Cyan
try {
    $body = @{email="test_$(Get-Random)@example.com"; fullName="Test User"; password="Pass@123"; phoneNumber="+1-555-0001"} | ConvertTo-Json
    $user = Invoke-RestMethod "$baseUrl/users" -Method POST -ContentType "application/json" -Body $body
    if ($user.id) { 
        Write-Host "   ✓ PASS (ID: $($user.id.substring(0,8))...)" -ForegroundColor Green; $passed++
        $testUserId = $user.id
    }
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 4: GET /users (List all)
Write-Host "4. GET /users (List all)" -ForegroundColor Cyan
try {
    $users = Invoke-RestMethod "$baseUrl/users" -Method GET
    if ($users.value -and $users.value.Count -gt 0) { 
        Write-Host "   ✓ PASS (Found $($users.value.Count) users)" -ForegroundColor Green; $passed++ 
    }
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 5: GET /users/:id (Get by ID)
Write-Host "5. GET /users/:id (Get by ID)" -ForegroundColor Cyan
try {
    if ($testUserId) {
        $user = Invoke-RestMethod "$baseUrl/users/$testUserId" -Method GET
        if ($user.id -eq $testUserId) { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP (No user to test)" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 6: PATCH /users/:id (Update user)
Write-Host "6. PATCH /users/:id (Update)" -ForegroundColor Cyan
try {
    if ($testUserId) {
        $updateBody = @{fullName="Updated Name"} | ConvertTo-Json
        $updated = Invoke-RestMethod "$baseUrl/users/$testUserId" -Method PATCH -ContentType "application/json" -Body $updateBody
        if ($updated.fullName -eq "Updated Name") { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 7: DELETE /users/:id (Delete user)
Write-Host "7. DELETE /users/:id (Delete)" -ForegroundColor Cyan
try {
    if ($testUserId) {
        $deleted = Invoke-RestMethod "$baseUrl/users/$testUserId" -Method DELETE
        Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++
    } else { Write-Host "   ⊘ SKIP" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 8: POST /auth/login (Login)
Write-Host "8. POST /auth/login (Login)" -ForegroundColor Cyan
try {
    $loginBody = @{email="endpoint_test_20251206120152@example.com"; password="Pass@123"} | ConvertTo-Json
    $loginResp = Invoke-RestMethod "$baseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody
    if ($loginResp.access_token) { 
        Write-Host "   ✓ PASS (Token issued)" -ForegroundColor Green; $passed++
        $testToken = $loginResp.access_token
    }
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 9: GET /auth/profile (Get profile with auth)
Write-Host "9. GET /auth/profile (Get profile)" -ForegroundColor Cyan
try {
    if ($testToken) {
        $profile = Invoke-RestMethod "$baseUrl/auth/profile" -Method GET -Headers @{"Authorization"="Bearer $testToken"}
        if ($profile.email) { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP (No token)" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 10: GET /products (List products)
Write-Host "10. GET /products (List all)" -ForegroundColor Cyan
try {
    $products = Invoke-RestMethod "$baseUrl/products" -Method GET
    if ($products.value) { 
        Write-Host "   ✓ PASS (Found $($products.value.Count) products)" -ForegroundColor Green; $passed++
        $testProductId = $products.value[0].id
    }
    else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 11: GET /products/:id (Get product by ID)
Write-Host "11. GET /products/:id (Get by ID)" -ForegroundColor Cyan
try {
    if ($testProductId) {
        $product = Invoke-RestMethod "$baseUrl/products/$testProductId" -Method GET
        if ($product.id -eq $testProductId) { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP (No product)" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 12: GET /products/my-products (Get user products)
Write-Host "12. GET /products/my-products (User products)" -ForegroundColor Cyan
try {
    if ($testToken) {
        $myProducts = Invoke-RestMethod "$baseUrl/products/my-products" -Method GET -Headers @{"Authorization"="Bearer $testToken"}
        Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++
    } else { Write-Host "   ⊘ SKIP (No token)" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 13: POST /products (Create product)
Write-Host "13. POST /products (Create)" -ForegroundColor Cyan
try {
    if ($testToken) {
        $prodBody = @{name="Test Prod $(Get-Random)"; description="Test"; price=99.99; quantity=5} | ConvertTo-Json
        $newProd = Invoke-RestMethod "$baseUrl/products" -Method POST -ContentType "application/json" -Headers @{"Authorization"="Bearer $testToken"} -Body $prodBody
        if ($newProd.id) { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++; $testProductId = $newProd.id }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP (No token)" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 14: PATCH /products/:id (Update product)
Write-Host "14. PATCH /products/:id (Update)" -ForegroundColor Cyan
try {
    if ($testToken -and $testProductId) {
        $updateProd = @{name="Updated Prod $(Get-Random)"} | ConvertTo-Json
        $updated = Invoke-RestMethod "$baseUrl/products/$testProductId" -Method PATCH -ContentType "application/json" -Headers @{"Authorization"="Bearer $testToken"} -Body $updateProd
        if ($updated.id) { Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++ }
        else { Write-Host "   ✗ FAIL" -ForegroundColor Red; $failed++ }
    } else { Write-Host "   ⊘ SKIP" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

# Test 15: DELETE /products/:id (Delete product)
Write-Host "15. DELETE /products/:id (Delete)" -ForegroundColor Cyan
try {
    if ($testToken -and $testProductId) {
        $deleted = Invoke-RestMethod "$baseUrl/products/$testProductId" -Method DELETE -Headers @{"Authorization"="Bearer $testToken"}
        Write-Host "   ✓ PASS" -ForegroundColor Green; $passed++
    } else { Write-Host "   ⊘ SKIP" -ForegroundColor Yellow }
} catch { Write-Host "   ✗ FAIL: $_" -ForegroundColor Red; $failed++ }

Write-Host "`n=== TEST SUMMARY ===" -ForegroundColor Yellow
Write-Host "✓ Passed: $passed" -ForegroundColor Green
Write-Host "✗ Failed: $failed" -ForegroundColor Red
Write-Host "Total: 15" -ForegroundColor Cyan
