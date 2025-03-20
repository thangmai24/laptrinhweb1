-- File: database/solution_b.sql
-- Truy vấn đơn hàng

-- Tạo bảng products
CREATE TABLE IF NOT EXISTS products (
    product_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price DOUBLE NOT NULL,
    product_description TEXT NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- Tạo bảng orders
CREATE TABLE IF NOT EXISTS orders (
    order_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng order_details
CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    order_id INT(11) NOT NULL,
    product_id INT(11) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Thêm dữ liệu mẫu vào bảng products
INSERT INTO products (product_name, product_price, product_description, created_at) VALUES
('Samsung Galaxy S21', 500.00, 'Smartphone Samsung', NOW()),
('Apple iPhone 14', 800.00, 'Smartphone Apple', NOW()),
('Samsung TV 55"', 600.00, 'Smart TV Samsung', NOW()),
('Apple MacBook Pro', 1200.00, 'Laptop Apple', NOW()),
('Headphones Sony', 100.00, 'Headphones', NOW());

-- Thêm dữ liệu mẫu vào bảng orders
INSERT INTO orders (user_id, created_at) VALUES
(1, NOW()), -- anna
(1, NOW()), -- anna
(2, NOW()), -- mike
(2, NOW()), -- mike
(3, NOW()), -- linda
(4, NOW()), -- mark
(5, NOW()), -- sophia
(6, NOW()), -- david
(7, NOW()), -- emily
(8, NOW()), -- john
(9, NOW()), -- mia
(10, NOW()); -- tom

-- Thêm dữ liệu mẫu vào bảng order_details
INSERT INTO order_details (order_id, product_id, created_at) VALUES
(1, 1, NOW()), -- anna mua Samsung Galaxy S21
(1, 2, NOW()), -- anna mua Apple iPhone 14
(2, 3, NOW()), -- anna mua Samsung TV
(2, 4, NOW()), -- anna mua Apple MacBook Pro
(3, 4, NOW()), -- mike mua Apple MacBook Pro
(4, 1, NOW()), -- mike mua Samsung Galaxy S21
(5, 5, NOW()), -- linda mua Headphones Sony
(6, 1, NOW()), -- mark mua Samsung Galaxy S21
(7, 2, NOW()), -- sophia mua Apple iPhone 14
(8, 3, NOW()), -- david mua Samsung TV
(9, 4, NOW()), -- emily mua Apple MacBook Pro
(10, 5, NOW()), -- john mua Headphones Sony
(11, 1, NOW()), -- mia mua Samsung Galaxy S21
(12, 2, NOW()); -- tom mua Apple iPhone 14

-- 1. Liệt kê các hóa đơn của khách hàng: mã user, tên user, mã hóa đơn
SELECT u.user_id, u.user_name, o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id
ORDER BY u.user_id, o.order_id;

-- 2. Liệt kê số lượng các hóa đơn của khách hàng: mã user, tên user, số đơn hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;

-- 3. Liệt kê thông tin hóa đơn: mã đơn hàng, số sản phẩm
SELECT o.order_id, COUNT(od.product_id) AS so_san_pham
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_id;

-- 4. Liệt kê thông tin mua hàng của người dùng: mã user, tên user, mã đơn hàng, tên sản phẩm
-- Nhóm theo đơn hàng, tránh xen kẽ các đơn hàng
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id, u.user_id;

-- 5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất: mã user, tên user, số lượng đơn hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_luong_don_hang
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY so_luong_don_hang DESC
LIMIT 7;

-- 6. Liệt kê 7 người dùng mua sản phẩm có tên 'Samsung' hoặc 'Apple': mã user, tên user, mã đơn hàng, tên sản phẩm
SELECT DISTINCT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%'
LIMIT 7;

-- 7. Liệt kê danh sách mua hàng của user, bao gồm giá tiền mỗi đơn hàng: mã user, tên user, mã đơn hàng, tổng tiền
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY u.user_id, u.user_name, o.order_id
ORDER BY u.user_id, o.order_id;

-- 8. Liệt kê danh sách mua hàng của user, mỗi user chỉ chọn 1 đơn hàng có giá tiền lớn nhất
-- Thông tin: mã user, tên user, mã đơn hàng, tổng tiền
WITH RankedOrders AS (
    SELECT u.user_id, u.user_name, o.order_id, 
           SUM(p.product_price) AS tong_tien,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) DESC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT user_id, user_name, order_id, tong_tien
FROM RankedOrders
WHERE rn = 1
ORDER BY user_id;

-- 9. Liệt kê danh sách mua hàng của user, mỗi user chỉ chọn 1 đơn hàng có giá tiền nhỏ nhất
-- Thông tin: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm
WITH RankedOrders AS (
    SELECT u.user_id, u.user_name, o.order_id, 
           SUM(p.product_price) AS tong_tien, 
           COUNT(od.product_id) AS so_san_pham,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) ASC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT user_id, user_name, order_id, tong_tien, so_san_pham
FROM RankedOrders
WHERE rn = 1
ORDER BY user_id;

-- 10. Liệt kê danh sách mua hàng của user, mỗi user chỉ chọn 1 đơn hàng có số sản phẩm nhiều nhất
-- Thông tin: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm
WITH RankedOrders AS (
    SELECT u.user_id, u.user_name, o.order_id, 
           SUM(p.product_price) AS tong_tien, 
           COUNT(od.product_id) AS so_san_pham,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY COUNT(od.product_id) DESC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
)
SELECT user_id, user_name, order_id, tong_tien, so_san_pham
FROM RankedOrders
WHERE rn = 1
ORDER BY user_id;