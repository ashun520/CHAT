# 通过 GitHub API 触发 workflow

$repo = "ashun520/CHAT"
$workflow = "build-ios.yml"
$branch = "main"

Write-Host "Triggering workflow..." -ForegroundColor Cyan

# 使用 gh cli 获取 token
$token = gh auth token 2>&1

if ($token -match "^gh[po]_") {
    Write-Host "Got token: $($token.Substring(0,10))..." -ForegroundColor Green
    
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $body = @{
        "ref" = $branch
    } | ConvertTo-Json
    
    $url = "https://api.github.com/repos/$repo/actions/workflows/$workflow/dispatches"
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method POST -Headers $headers -Body $body -UseBasicParsing
        Write-Host "SUCCESS! Workflow triggered" -ForegroundColor Green
        Write-Host "Check: https://github.com/$repo/actions" -ForegroundColor Cyan
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Cannot get GitHub token. Please run: gh auth login" -ForegroundColor Red
}
