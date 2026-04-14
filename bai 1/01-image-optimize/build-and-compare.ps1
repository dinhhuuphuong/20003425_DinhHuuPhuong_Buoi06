$ErrorActionPreference = "Stop"

function Test-DockerReady {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Host "Khong tim thay lenh 'docker' trong terminal hien tai." -ForegroundColor Red
        Write-Host "Thu mo PowerShell moi hoac chay trong Docker Desktop terminal." -ForegroundColor Yellow
        return $false
    }

    try {
        docker version *> $null
        return $true
    } catch {
        Write-Host "Docker CLI ton tai nhung khong ket noi duoc Docker Engine." -ForegroundColor Red
        Write-Host "Chi tiet: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
}

if (-not (Test-DockerReady)) {
    Write-Host "Hay kiem tra Docker Desktop dang Running va thu mo terminal moi roi chay lai." -ForegroundColor Red
    exit 1
}

Write-Host "=== Build 4 lan toi uu image ===" -ForegroundColor Cyan

$builds = @(
    @{ tag = "bai1-go:v1"; file = "Dockerfile.v1" },
    @{ tag = "bai1-go:v2"; file = "Dockerfile.v2" },
    @{ tag = "bai1-go:v3"; file = "Dockerfile.v3" },
    @{ tag = "bai1-go:v4"; file = "Dockerfile.v4" }
)

foreach ($b in $builds) {
    Write-Host "\n[BUILD] $($b.tag) using $($b.file)" -ForegroundColor Yellow
    docker build -f $b.file -t $b.tag .
    if ($LASTEXITCODE -ne 0) {
        throw "Build that bai voi $($b.tag)"
    }
}

Write-Host "\n=== Kich thuoc image ===" -ForegroundColor Cyan
docker image ls bai1-go --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"

Write-Host "\n=== Test nhanh container ===" -ForegroundColor Cyan
for ($i = 1; $i -le 4; $i++) {
    $name = "bai1_v$i"
    $tag = "bai1-go:v$i"
    $port = 8080 + $i

    $existing = docker ps -a --filter "name=^/$name$" --format "{{.Names}}"
    if ($existing -eq $name) {
        docker rm -f $name | Out-Null
    }
    docker run -d --name $name -p "$port`:8080" $tag | Out-Null
    Start-Sleep -Seconds 2

    Write-Host "Container $name -> http://localhost:$port" -ForegroundColor Green
    try {
        $resp = Invoke-WebRequest -Uri "http://localhost:$port/hello" -UseBasicParsing -TimeoutSec 5
        Write-Host "Response: $($resp.Content.Trim())"
    } catch {
        Write-Host "Khong goi duoc API tren port $port" -ForegroundColor Red
    }
}

Write-Host "\nScreenshot goi y:" -ForegroundColor Magenta
Write-Host "1) Ket qua build 4 image"
Write-Host "2) docker image ls bai1-go"
Write-Host "3) curl/Invoke-WebRequest 4 container"
