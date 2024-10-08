-- Table: products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category_id INT,
    subcategory_id INT
);

-- Table: categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Table: subcategories
CREATE TABLE subcategories (
    subcategory_id SERIAL PRIMARY KEY,
    subcategory_name VARCHAR(255) NOT NULL,
    category_id INT REFERENCES categories(category_id)
);

-- Table: order_items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

-- Table: orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    coupon_id INT
);

-- Table: customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255),
    gender VARCHAR(10),
    date_of_birth DATE,
    region_id INT
);

-- Table: regions
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(255) NOT NULL
);

-- Table: coupons
CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_code VARCHAR(50),
    discount_percent NUMERIC(5, 2)
);

-- Adding Foreign Keys
ALTER TABLE products
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories (category_id),
ADD CONSTRAINT fk_subcategory FOREIGN KEY (subcategory_id) REFERENCES subcategories (subcategory_id);

ALTER TABLE orders
ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
ADD CONSTRAINT fk_coupon FOREIGN KEY (coupon_id) REFERENCES coupons (coupon_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders (order_id),
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE customers
ADD CONSTRAINT fk_region FOREIGN KEY (region_id) REFERENCES regions (region_id);

-- Adding indexes
CREATE INDEX idx_product_id ON order_items(product_id);
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Sample Data Insertions
-- Categories
INSERT INTO categories (category_name) VALUES ('Electronics'), ('Books'), ('Clothing');

-- Subcategories
INSERT INTO subcategories (subcategory_name, category_id) 
VALUES ('Mobile Phones', 1), ('Fiction', 2), ('T-Shirts', 3);

-- Regions
INSERT INTO regions (region_name) 
VALUES ('North America'), ('Europe');

-- Customers (after regions are inserted)
INSERT INTO customers (customer_name, gender, date_of_birth, region_id) 
VALUES 
('John Doe', 'Male', '1990-01-15', 1), 
('Jane Doe', 'Female', '1985-03-25', 2);

-- Products
INSERT INTO products (product_name, category_id, subcategory_id) 
VALUES 
('iPhone 14', 1, 1), 
('Samsung Galaxy', 1, 1), 
('The Catcher in the Rye', 2, 2), 
('Plain White T-Shirt', 3, 3);

-- Orders
INSERT INTO orders (customer_id, order_date, coupon_id) 
VALUES 
(1, '2024-01-10', NULL), 
(2, '2024-01-12', 1);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) 
VALUES 
(1, 1, 2, 999.99), 
(1, 3, 1, 19.99), 
(2, 2, 1, 899.99);

-- Coupons
INSERT INTO coupons (coupon_code, discount_percent) 
VALUES 
('NEWYEAR20', 20), 
('SUMMER15', 15);
