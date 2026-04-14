BAI 3 - Mono -> Service-based architecture (1 DB)

Muc tieu:
- Tu mo hinh monolith (1 backend chua 3 function)
- Chuyen sang service-based (3 service rieng)
- Van dung 1 database chung
- Co day du code BE + FE + DB

Cau truc:
- 01-monolith/
  - backend (Node.js + Express)
  - frontend (nginx static)
  - db/init.sql (MariaDB)
  - docker-compose.yml
- 02-service-based/
  - user-service
  - product-service
  - order-service
  - frontend (nginx static)
  - db/init.sql
  - docker-compose.yml

====================
1) Chay MONOLITH
====================
cd "E:\GiaoTrinhDH\Nam4_HK2\KienTruc\ThucHanh\Tuan06\bai 3\01-monolith"
docker compose up -d --build

Kiem tra:
- API health: http://localhost:5000/api/health
- Frontend: http://localhost:8088

3 function trong 1 backend:
- /api/users
- /api/products
- /api/orders

====================
2) Chay SERVICE-BASED
====================
cd "E:\GiaoTrinhDH\Nam4_HK2\KienTruc\ThucHanh\Tuan06\bai 3\02-service-based"
docker compose up -d --build

Kiem tra:
- User service: http://localhost:6001/api/health
- Product service: http://localhost:6002/api/health
- Order service: http://localhost:6003/api/health
- Frontend: http://localhost:8089

3 function tach thanh 3 service:
- user-service -> /api/users
- product-service -> /api/products
- order-service -> /api/orders

====================
3) Anh minh chung nen chup
====================
- Monolith:
  1) docker compose ps (3 container: db/backend/frontend)
  2) Frontend 8088 hien thi du lieu 3 function
- Service-based:
  3) docker compose ps (5 container: db + 3 service + frontend)
  4) 3 health endpoint 6001/6002/6003
  5) Frontend 8089 hien thi du lieu

====================
4) Don dep
====================
- Monolith:
  cd 01-monolith
  docker compose down -v

- Service-based:
  cd 02-service-based
  docker compose down -v
