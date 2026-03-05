Write-Host "Logging in to GitHub..." -ForegroundColor Cyan

# Login using token
$env:GH_TOKEN = ""

# Try to login
gh auth login --hostname github.com --git-protocol https --web

if ($LASTEXITCODE -eq 0) {
    Write-Host "Login successful!" -ForegroundColor Green
} else {
    Write-Host "Login failed or cancelled" -ForegroundColor Red
}
