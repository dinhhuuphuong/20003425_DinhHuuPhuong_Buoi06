/*
Bai 2 - Vi du Function partition (logic partition) cho MariaDB
Y tuong: tach theo chuc nang nghiep vu (auth / sales / reporting).
De demo don gian trong 1 DB, dung ten bang theo module.
*/

USE partition_demo_db;

DROP TABLE IF EXISTS reporting_daily_order_summary;
DROP TABLE IF EXISTS sales_order_item;
DROP TABLE IF EXISTS sales_order_header;
DROP TABLE IF EXISTS auth_app_user;

CREATE TABLE auth_app_user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(200) NOT NULL,
    role_name VARCHAR(30) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales_order_header (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(18,2) NOT NULL,
    CONSTRAINT fk_order_header_user FOREIGN KEY (user_id) REFERENCES auth_app_user(user_id)
);

CREATE TABLE sales_order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    qty INT NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    CONSTRAINT fk_order_item_order_header FOREIGN KEY (order_id) REFERENCES sales_order_header(order_id)
);

CREATE TABLE reporting_daily_order_summary (
    report_date DATE PRIMARY KEY,
    order_count INT NOT NULL,
    total_revenue DECIMAL(18,2) NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO auth_app_user(username, password_hash, role_name)
VALUES ('admin', 'hash-admin', 'ADMIN'),
       ('user01', 'hash-user01', 'USER');

INSERT INTO sales_order_header(user_id, order_date, total_amount)
VALUES (2, CURDATE(), 250000),
       (2, CURDATE(), 180000);

INSERT INTO sales_order_item(order_id, product_name, qty, price)
VALUES (1, 'Ban phim', 1, 250000),
       (2, 'Chuot', 2, 90000);

/* Tong hop bao cao theo ngay cho module reporting */
INSERT INTO reporting_daily_order_summary(report_date, order_count, total_revenue)
SELECT order_date AS report_date,
       COUNT(*) AS order_count,
       SUM(total_amount) AS total_revenue
FROM sales_order_header
GROUP BY order_date
ON DUPLICATE KEY UPDATE
    order_count = VALUES(order_count),
    total_revenue = VALUES(total_revenue),
    updated_at = CURRENT_TIMESTAMP;

SELECT * FROM auth_app_user;
SELECT * FROM sales_order_header;
SELECT * FROM reporting_daily_order_summary;
