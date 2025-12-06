Write-Host "Testing API at http://localhost:3000..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000" -Method GET -ErrorAction Stop
    Write-Host "✅ Server Response:" -ForegroundColor Green
    Write-Host "   Status: $($response.status)" -ForegroundColor Green
    Write-Host "   Message: $($response.message)" -ForegroundColor Green
    Write-Host "   Endpoints: $($response.endpoints | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
