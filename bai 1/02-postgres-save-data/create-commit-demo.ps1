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

$baseContainer = "pg_base_demo"
$finalImage = "postgres:16-alpine-seeded"
$verifyContainer = "pg_verify_demo"
$password = "123456"
$db = "demo"
$pgData = "/var/lib/postgresql/customdata"

Write-Host "=== Buoc 1: Chay postgres goc ===" -ForegroundColor Cyan
$existingBase = docker ps -a --filter "name=^/$baseContainer$" --format "{{.Names}}"
if ($existingBase -eq $baseContainer) {
    docker rm -f $baseContainer | Out-Null
}
docker run -d --name $baseContainer -e "POSTGRES_PASSWORD=$password" -e "POSTGRES_DB=$db" -e "PGDATA=$pgData" -p "55432:5432" postgres:16-alpine | Out-Null

Write-Host "Cho postgres khoi dong..." -ForegroundColor Yellow
$ready = $false
for ($i = 0; $i -lt 60; $i++) {
    $result = docker exec $baseContainer pg_isready -U postgres -d $db 2>$null
    if ($LASTEXITCODE -eq 0) {
        $ready = $true
        break
    }
    Start-Sleep -Seconds 1
}

if (-not $ready) {
    throw "Postgres khong san sang sau 60s"
}

Write-Host "=== Buoc 2: Tao bang va chen data ===" -ForegroundColor Cyan
$sql = @"
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    class_name TEXT NOT NULL
);

INSERT INTO students (full_name, class_name)
VALUES
('Nguyen Van A', 'KTPM1'),
('Tran Thi B', 'KTPM2');
"@

$sql | docker exec -i $baseContainer psql -U postgres -d $db

Write-Host "Du lieu trong container goc:" -ForegroundColor Green
docker exec $baseContainer psql -U postgres -d $db -c "SELECT * FROM students;"

Write-Host "=== Buoc 3: Commit container thanh image moi ===" -ForegroundColor Cyan
docker commit $baseContainer $finalImage

docker stop $baseContainer | Out-Null
docker rm $baseContainer | Out-Null

Write-Host "=== Buoc 4: Chay container tu image moi va kiem tra data ===" -ForegroundColor Cyan
$existingVerify = docker ps -a --filter "name=^/$verifyContainer$" --format "{{.Names}}"
if ($existingVerify -eq $verifyContainer) {
    docker rm -f $verifyContainer | Out-Null
}
docker run -d --name $verifyContainer -e "POSTGRES_PASSWORD=$password" -e "POSTGRES_DB=$db" -e "PGDATA=$pgData" -p "55433:5432" $finalImage | Out-Null

Start-Sleep -Seconds 5

$ready2 = $false
for ($i = 0; $i -lt 30; $i++) {
    $result2 = docker exec $verifyContainer pg_isready -U postgres -d $db 2>$null
    if ($LASTEXITCODE -eq 0) {
        $ready2 = $true
        break
    }
    Start-Sleep -Seconds 1
}

if (-not $ready2) {
    throw "Container verify khong san sang"
}

Write-Host "Du lieu khi chay lai tu image commit:" -ForegroundColor Green
docker exec $verifyContainer psql -U postgres -d $db -c "SELECT * FROM students;"

Write-Host "\nScreenshot goi y:" -ForegroundColor Magenta
Write-Host "1) bang students trong container goc"
Write-Host "2) lenh docker commit"
Write-Host "3) bang students trong container chay tu image commit"
