/*
Bai 2 - Vi du Horizontal partition (MariaDB)
Y tuong: cung cau truc, chia du lieu theo dong (Nam/Nu)
*/

CREATE DATABASE IF NOT EXISTS partition_demo_db;

DROP VIEW IF EXISTS partition_demo_db.vw_users_all;
DROP PROCEDURE IF EXISTS partition_demo_db.usp_insert_user_by_gender;
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

DELIMITER $$

CREATE PROCEDURE partition_demo_db.usp_insert_user_by_gender(
    IN p_full_name VARCHAR(100),
    IN p_gender CHAR(1)
)
BEGIN
    IF p_gender = 'M' THEN
        INSERT INTO partition_demo_db.table_user_01(full_name, gender)
        VALUES (p_full_name, p_gender);
    ELSEIF p_gender = 'F' THEN
        INSERT INTO partition_demo_db.table_user_02(full_name, gender)
        VALUES (p_full_name, p_gender);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'gender chi nhan M hoac F';
    END IF;
END$$

DELIMITER ;

CREATE VIEW partition_demo_db.vw_users_all AS
SELECT user_id, full_name, gender, created_at, 'table_user_01' AS source_table
FROM partition_demo_db.table_user_01
UNION ALL
SELECT user_id, full_name, gender, created_at, 'table_user_02' AS source_table
FROM partition_demo_db.table_user_02;

CALL partition_demo_db.usp_insert_user_by_gender('Nguyen Van Nam', 'M');
CALL partition_demo_db.usp_insert_user_by_gender('Tran Thi Nu', 'F');
CALL partition_demo_db.usp_insert_user_by_gender('Le Van A', 'M');

SELECT 'table_user_01 (Nam)' AS info, user_id, full_name, gender, created_at FROM partition_demo_db.table_user_01;
SELECT 'table_user_02 (Nu)' AS info, user_id, full_name, gender, created_at FROM partition_demo_db.table_user_02;
SELECT * FROM partition_demo_db.vw_users_all ORDER BY created_at DESC;

/*
Goi y Spring Boot route logic:
- gender = M -> insert table_user_01
- gender = F -> insert table_user_02
*/
