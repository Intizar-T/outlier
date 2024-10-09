-- Create tables
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE subcategories (
    subcategory_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    subcategory_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id INTEGER NOT NULL,
    subcategory_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id)
);

CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    gender CHAR(1) NOT NULL,
    date_of_birth DATE NOT NULL,
    region_id INTEGER NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_code VARCHAR(20) NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL,
    coupon_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create indices
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_subcategory ON products(subcategory_id);
CREATE INDEX idx_customers_region ON customers(region_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_coupon ON orders(coupon_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Insert sample data
INSERT INTO categories (category_name) VALUES ('Electronics'), ('Clothing');
INSERT INTO subcategories (category_id, subcategory_name) VALUES (1, 'Smartphones'), (1, 'Laptops'), (2, 'T-Shirts'), (2, 'Jeans');
INSERT INTO products (product_name, category_id, subcategory_id) VALUES 
    ('iPhone 12', 1, 1),
    ('Samsung Galaxy S21', 1, 1),
    ('MacBook Pro', 1, 2),
    ('Dell XPS', 1, 2),
    ('Plain White Tee', 2, 3),
    ('Levi''s 501', 2, 4);

INSERT INTO regions (region_name) VALUES ('North'), ('South'), ('East'), ('West');
INSERT INTO customers (gender, date_of_birth, region_id) VALUES 
    ('M', '1990-01-01', 1),
    ('F', '1985-05-15', 2),
    ('M', '2000-12-31', 3),
    ('F', '1975-07-20', 4);

INSERT INTO coupons (coupon_code, discount_percent) VALUES ('SUMMER10', 10.00), ('WELCOME20', 20.00);

INSERT INTO orders (customer_id, order_date, coupon_id) VALUES 
    (1, CURRENT_DATE, 1),
    (2, CURRENT_DATE - INTERVAL '1 day', 2),
    (3, CURRENT_DATE - INTERVAL '2 days', NULL),
    (4, CURRENT_DATE - INTERVAL '3 days', NULL);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
    (1, 1, 1, 999.99),
    (1, 5, 2, 19.99),
    (2, 3, 1, 1499.99),
    (2, 6, 1, 59.99),
    (3, 2, 1, 899.99),
    (3, 4, 1, 1299.99),
    (4, 5, 3, 19.99),
    (4, 6, 2, 59.99);

-- Your colleague's query can be run after this point