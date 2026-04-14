CREATE DATABASE IF NOT EXISTS bai3db;
USE bai3db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  gender CHAR(1) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users(full_name, gender)
VALUES ('Nguyen Van Nam', 'M'), ('Tran Thi Nu', 'F');

INSERT INTO products(product_name, price)
VALUES ('Ban phim', 250000), ('Chuot', 120000);

INSERT INTO orders(user_id, product_id, quantity)
VALUES (1, 1, 1), (2, 2, 2);
