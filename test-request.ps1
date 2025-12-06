
$Uri = 'http://127.0.0.1:3000/users'
$Body = @{
    email = "test@example.com"
    fullName = "Test User"
    password = "TestPass1"
    phoneNumber = "555-1234"
} | ConvertTo-Json

Write-Host "Sending request to $Uri"
Write-Host "Body: $Body"

try {
    $response = Invoke-WebRequest -Uri $Uri -Method POST -ContentType 'application/json' -Body $Body -TimeoutSec 10 -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)"
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $body = $reader.ReadToEnd()
        Write-Host "Response Body: $body"
    }
}
