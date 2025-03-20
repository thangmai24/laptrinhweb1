-- File: database/solution_a.sql
-- Truy vấn người dùng

-- Tạo bảng users
CREATE TABLE IF NOT EXISTS users (
    user_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_email VARCHAR(55) NOT NULL,
    user_pass VARCHAR(255) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- Thêm dữ liệu mẫu vào bảng users
INSERT INTO users (user_name, user_email, user_pass, created_at) VALUES
('anna', 'anna@gmail.com', 'pass123', NOW()),
('mike', 'mike@gmail.com', 'pass456', NOW()),
('linda', 'linda@yahoo.com', 'pass789', NOW()),
('mark', 'mark@gmail.com', 'pass101', NOW()),
('sophia', 'sophia@gmail.com', 'pass202', NOW()),
('david', 'david@gmail.com', 'pass303', NOW()),
('emily', 'emily@gmail.com', 'pass404', NOW()),
('john', 'john@yahoo.com', 'pass505', NOW()),
('mia', 'mia@gmail.com', 'pass606', NOW()),
('tom', 'tom@gmail.com', 'pass707', NOW()),
('kelly', 'kellyi@gmail.com', 'pass808', NOW()),
('jim', 'jimmi@gmail.com', 'pass909', NOW());

-- 1. Lấy danh sách người dùng theo thứ tự tên Alphabet (A->Z)
SELECT * 
FROM users 
ORDER BY user_name ASC;

-- 2. Lấy 07 người dùng theo thứ tự tên Alphabet (A->Z)
SELECT * 
FROM users 
ORDER BY user_name ASC 
LIMIT 7;

-- 3. Lấy danh sách người dùng theo thứ tự tên Alphabet (A->Z), tên có chữ 'a'
SELECT * 
FROM users 
WHERE user_name LIKE '%a%' 
ORDER BY user_name ASC;

-- 4. Lấy danh sách người dùng, tên bắt đầu bằng chữ 'm'
SELECT * 
FROM users 
WHERE user_name LIKE 'm%' 
ORDER BY user_name ASC;

-- 5. Lấy danh sách người dùng, tên kết thúc bằng chữ 'i'
SELECT * 
FROM users 
WHERE user_name LIKE '%i' 
ORDER BY user_name ASC;

-- 6. Lấy danh sách người dùng có email là Gmail (ví dụ: example@gmail.com)
SELECT * 
FROM users 
WHERE user_email LIKE '%@gmail.com' 
ORDER BY user_name ASC;

-- 7. Lấy danh sách người dùng có email là Gmail, tên bắt đầu bằng chữ 'm'
SELECT * 
FROM users 
WHERE user_email LIKE '%@gmail.com' 
AND user_name LIKE 'm%' 
ORDER BY user_name ASC;

-- 8. Lấy danh sách người dùng có email là Gmail, tên có chữ 'i', và tên có chiều dài lớn hơn 5
SELECT * 
FROM users 
WHERE user_email LIKE '%@gmail.com' 
AND user_name LIKE '%i%' 
AND LENGTH(user_name) > 5 
ORDER BY user_name ASC;

-- 9. Lấy danh sách người dùng có chữ 'a', chiều dài tên từ 5 đến 9, email dùng Gmail, trong tên email có chữ 'i'
SELECT * 
FROM users 
WHERE user_name LIKE '%a%' 
AND LENGTH(user_name) BETWEEN 5 AND 9 
AND user_email LIKE '%@gmail.com' 
AND user_email LIKE '%i%@gmail.com' 
ORDER BY user_name ASC;

-- 10. Lấy danh sách người dùng có chữ 'a', chiều dài từ 5 đến 9 HOẶC tên có chữ 'i', chiều dài nhỏ hơn 9 HOẶC email dùng Gmail, trong tên email có chữ 'i'
SELECT * 
FROM users 
WHERE (user_name LIKE '%a%' AND LENGTH(user_name) BETWEEN 5 AND 9) 
   OR (user_name LIKE '%i%' AND LENGTH(user_name) < 9) 
   OR (user_email LIKE '%@gmail.com' AND user_email LIKE '%i%@gmail.com') 
ORDER BY user_name ASC;