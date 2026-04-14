# Postgres save data vao image

Script `create-commit-demo.ps1` se:
1. Chay container tu `postgres:16-alpine`
2. Tao bang `students` va insert data mau
3. Commit container thanh image `postgres:16-alpine-seeded`
4. Chay container moi tu image commit
5. Query lai data de xac nhan data van con

Chay:
```powershell
.\create-commit-demo.ps1
```
