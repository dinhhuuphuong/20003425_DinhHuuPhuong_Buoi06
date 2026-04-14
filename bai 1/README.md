# BAI 1 - Image optimize + image save data

Muc tieu:
- Lam 4 lan toi uu Docker image (4 stage -> 3 stage -> 2 stage -> 1 stage)
- Minh chung Postgres: insert data trong container -> commit thanh image -> run container moi van con data

## Cau truc
- 01-image-optimize: 4 Dockerfile va script build so sanh size
- 02-postgres-save-data: script demo commit data Postgres thanh image

## Yeu cau
- Da cai Docker Desktop
- Docker Desktop dang RUNNING (daemon san sang)
- Mo terminal tai thu muc nay

## Chay bai 1.1 - 4 lan toi uu image
```powershell
cd .\01-image-optimize
.\build-and-compare.ps1
```

Ban chup man hinh:
- Log build 4 image
- `docker image ls bai1-go`
- Ket qua response cua 4 container

## Chay bai 1.2 - Save data Postgres vao image
```powershell
cd ..\02-postgres-save-data
.\create-commit-demo.ps1
```

Ban chup man hinh:
- Data trong container Postgres goc
- Lenh commit tao image moi
- Data trong container chay lai tu image moi

## Don dep sau khi chup hinh
```powershell
docker rm -f bai1_v1 bai1_v2 bai1_v3 bai1_v4 pg_verify_demo 2>$null
docker image rm bai1-go:v1 bai1-go:v2 bai1-go:v3 bai1-go:v4 postgres:16-alpine-seeded 2>$null
```
