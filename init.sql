CREATE DATABASE IF NOT EXISTS otus
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE otus;

CREATE TABLE IF NOT EXISTS categories (
    category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (category_id)
);

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    PRIMARY KEY (supplier_id)
);

CREATE TABLE IF NOT EXISTS manufacturers (
    manufacturer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    PRIMARY KEY (manufacturer_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    attributes JSON,
    category_id INT UNSIGNED NOT NULL,
    supplier_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (product_id),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_products_manufacturer
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS prices (
    price_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (price_id),
    CONSTRAINT fk_prices_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS purchases (
    purchase_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    price_id INT UNSIGNED NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL,
    purchase_date DATETIME NOT NULL,
    PRIMARY KEY (purchase_id),
    CONSTRAINT fk_purchases_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
        CONSTRAINT fk_purchases_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_purchases_price
        FOREIGN KEY (price_id) REFERENCES prices(price_id)
);

INSERT INTO categories (name) VALUES
('Ноутбуки'),
('Периферия'),
('Мониторы');

INSERT INTO suppliers (name, email, phone) VALUES
('Tech Supply', 'supply@example.com', '+79990000001'),
('Office Trade', 'office@example.com', '+79990000002');

INSERT INTO manufacturers (name, email, phone) VALUES
('Lenovo', 'lenovo@example.com', '+79990000003'),
('Logitech', 'logitech@example.com', '+79990000004');

INSERT INTO products (name, description, attributes, category_id, supplier_id, manufacturer_id) VALUES
(
  'Lenovo ThinkBook',
  'Ноутбук для офиса',
  JSON_OBJECT(
    'cpu', 'Intel Core i5',
    'ram_gb', 16,
    'storage_gb', 512,
    'color', 'gray',
    'warranty_months', 24
  ),
  1, 1, 1
),
(
  'Logitech M185',
  'Беспроводная мышь',
  JSON_OBJECT(
    'dpi', 1600,
    'wireless', true,
    'battery', 'AA',
    'color', 'black'
  ),
  2, 2, 2
),
(
  'Dell Monitor 24',
  'Монитор 24 дюйма',
  JSON_OBJECT(
    'diagonal', 24,
    'resolution', '1920x1080',
    'panel', 'IPS',
    'ports', JSON_ARRAY('HDMI', 'DisplayPort'),
    'color', 'black'
  ),
  3, 1, 1
);

INSERT INTO customers (name, email, phone) VALUES
('Иван Петров', 'ivan@example.com', '+79990000005'),
('Мария Соколова', 'maria@example.com', '+79990000006');

INSERT INTO prices (product_id, price, start_date, end_date) VALUES
(1, 79990.00, '2026-01-01', '2026-12-31'),
(2, 1990.00, '2026-01-01', '2026-12-31'),
(3, 15990.00, '2026-01-01', '2026-12-31');

INSERT INTO purchases (customer_id, product_id, price_id, quantity, purchase_date) VALUES
(1, 1, 1, 1, '2026-04-01 10:15:00'),
(2, 2, 2, 2, '2026-04-02 14:30:00'),
(1, 3, 3, 1, '2026-04-03 16:45:00');
