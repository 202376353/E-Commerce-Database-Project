
CREATE DATABASE IF NOT EXISTS ecommerce_db;


USE ecommerce_db;

CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

CREATE TABLE product_category (
    product_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand_id INT,
    base_price DECIMAL(10, 2) NOT NULL,
    product_category_id INT,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (product_category_id) REFERENCES product_category(product_category_id)
);

CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(10) NOT NULL
);

CREATE TABLE size_option (
    size_option_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_name VARCHAR(255) NOT NULL,
    size_name VARCHAR(50) NOT NULL
);

CREATE TABLE product_variation (
    product_variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    variation_type ENUM('size', 'color', 'material', 'style') NOT NULL,
    variation_value VARCHAR(255) NOT NULL,
    size_option_id INT NULL,
    color_id INT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(size_option_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

CREATE TABLE product_item (
    product_item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    product_variation_id INT NULL,
    sku VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (product_variation_id) REFERENCES product_variation(product_variation_id)
);

CREATE TABLE product_image (
    product_image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NULL,
    product_item_id INT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(product_item_id),
    CONSTRAINT chk_image_reference CHECK (product_id IS NOT NULL OR product_item_id IS NOT NULL)
);

CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    attribute_category_id INT,
    type_name VARCHAR(255) NOT NULL,
    data_type ENUM('text', 'number', 'boolean') NOT NULL,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id)
);

CREATE TABLE product_attribute (
    product_attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    attribute_type_id INT,
    text_value VARCHAR(255) NULL,
    number_value DECIMAL(10,2) NULL,
    boolean_value TINYINT(1) NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
);

-- This is Random sample data to test the relationships of the tables, all limited to 5 records.

 Insert brands
INSERT INTO brand (brand_name) VALUES
('Nike'), ('Adidas'), ('Apple'), ('Samsung'), ('Levi''s');


INSERT INTO product_category (category_name) VALUES
('Shoes'), ('Electronics'), ('Clothing'), ('Accessories'), ('Sports Equipment');


INSERT INTO color (color_name, color_code) VALUES
('Red', '#FF0000'), ('Blue', '#0000FF'), ('Black', '#000000'),
('White', '#FFFFFF'), ('Green', '#00FF00');


INSERT INTO size_option (size_category_name, size_name) VALUES
('Clothing', 'S'), ('Clothing', 'M'), ('Clothing', 'L'),
('Shoes', '9'), ('Shoes', '10');

-- Insert products
INSERT INTO product (name, brand_id, base_price, product_category_id) VALUES
('Air Max', 1, 120.00, 1),       
('iPhone 13', 3, 799.00, 2),     
('T-Shirt', 5, 29.99, 3),        
('Galaxy Buds', 4, 129.99, 4),   
('Football', 2, 25.50, 5);       


INSERT INTO product_variation (product_id, variation_type, variation_value, size_option_id, color_id) VALUES
(1, 'size', '9', 4, NULL),       
(1, 'color', 'Red', NULL, 1),    
(3, 'size', 'M', 2, NULL),       
(3, 'color', 'Blue', NULL, 2),   
(5, 'color', 'Black', NULL, 3);  


INSERT INTO product_item (product_id, product_variation_id, sku, price, quantity) VALUES
(1, 1, 'NIKE-AIR-9-RED', 120.00, 50),   
(1, NULL, 'NIKE-AIR-DEFAULT', 120.00, 30), 
(3, 3, 'LEVI-TS-M-BLUE', 29.99, 100),    
(4, NULL, 'SAMSUNG-BUDS', 129.99, 75),    
(5, 5, 'ADIDAS-FB-BLACK', 25.50, 40);   


INSERT INTO product_image (product_id, product_item_id, image_url) VALUES
(1, NULL, 'nike_air_max.jpg'),           
(1, 1, 'nike_air_red_size9.jpg'),        
(3, 3, 'levis_tshirt_blue_m.jpg'),       
(4, NULL, 'samsung_buds_main.jpg'),      
(5, 5, 'adidas_football_black.jpg');     


INSERT INTO attribute_category (category_name) VALUES
('Physical'), ('Technical'), ('Material'), ('Style'), ('Performance');


INSERT INTO attribute_type (attribute_category_id, type_name, data_type) VALUES
(1, 'Weight', 'number'),     
(2, 'Battery Life', 'text'), 
(3, 'Fabric', 'text'),       
(4, 'Fit', 'text'),          
(5, 'Waterproof', 'boolean');


INSERT INTO product_attribute (product_id, attribute_type_id, text_value, number_value, boolean_value) VALUES
(1, 1, NULL, 0.5, NULL),             
(2, 2, 'Up to 19 hours', NULL, NULL),
(3, 3, '100% Cotton', NULL, NULL),    
(1, 4, 'Regular fit', NULL, NULL),   
(5, 5, NULL, NULL, 1);               

-- These are some sample queries to test the relationships of the tables.

SELECT p.name, b.brand_name, pc.category_name
FROM product p
JOIN brand b ON p.brand_id = b.brand_id
JOIN product_category pc ON p.product_category_id = pc.product_category_id;


SELECT p.name, pv.variation_type,
       COALESCE(so.size_name, c.color_name, pv.variation_value) AS value
FROM product_variation pv
JOIN product p ON pv.product_id = p.product_id
LEFT JOIN size_option so ON pv.size_option_id = so.size_option_id
LEFT JOIN color c ON pv.color_id = c.color_id
WHERE p.product_id = 1; 

