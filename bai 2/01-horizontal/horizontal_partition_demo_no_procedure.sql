/*
Bai 2 - Horizontal partition (MariaDB) ban tuong thich cao
Khong dung PROCEDURE/DELIMITER de tranh loi tren mot so SQL client.
*/

CREATE DATABASE IF NOT EXISTS partition_demo_db;

DROP VIEW IF EXISTS partition_demo_db.vw_users_all;
DROP TABLE IF EXISTS partition_demo_db.table_user_01;
DROP TABLE IF EXISTS partition_demo_db.table_user_02;

CREATE TABLE partition_demo_db.table_user_01 (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender CHAR(1) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_table_user_01_gender CHECK (gender = 'M')
);

CREATE TABLE partition_demo_db.table_user_02 (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender CHAR(1) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_table_user_02_gender CHECK (gender = 'F')
);

/*
Route logic tuong duong Spring Boot:
- Nam -> table_user_01
- Nu -> table_user_02
Ban insert truc tiep de demo.
*/
INSERT INTO partition_demo_db.table_user_01(full_name, gender)
VALUES ('Nguyen Van Nam', 'M'),
       ('Le Van A', 'M');

INSERT INTO partition_demo_db.table_user_02(full_name, gender)
VALUES ('Tran Thi Nu', 'F');

CREATE VIEW partition_demo_db.vw_users_all AS
SELECT user_id, full_name, gender, created_at, 'table_user_01' AS source_table
FROM partition_demo_db.table_user_01
UNION ALL
SELECT user_id, full_name, gender, created_at, 'table_user_02' AS source_table
FROM partition_demo_db.table_user_02;

SELECT 'table_user_01 (Nam)' AS info, user_id, full_name, gender, created_at
FROM partition_demo_db.table_user_01;

SELECT 'table_user_02 (Nu)' AS info, user_id, full_name, gender, created_at
FROM partition_demo_db.table_user_02;

SELECT * FROM partition_demo_db.vw_users_all ORDER BY created_at DESC;
