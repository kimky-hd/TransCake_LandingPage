CREATE DATABASE IF NOT EXISTS transcake_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE transcake_db;

-- ========================================================
-- Bảng: users
-- Mô tả: Lưu trữ thông tin tài khoản người dùng
-- ========================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) DEFAULT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE',
    gender ENUM('male', 'female', 'other') DEFAULT 'other',
    role ENUM('passenger', 'driver', 'none') DEFAULT 'none',
    hobbies VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- ========================================================
-- Bảng: otp_codes
-- Mô tả: Lưu trữ các mã xác thực OTP dùng một lần
-- ========================================================
CREATE TABLE IF NOT EXISTS otp_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_phone_number (phone_number)
);

-- ========================================================
-- Bảng: driver_vehicles
-- Mô tả: Lưu trữ thông tin xe của tài xế
-- ========================================================
CREATE TABLE IF NOT EXISTS driver_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_type ENUM('MOTORBIKE', 'CAR') NOT NULL,
    vehicle_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================================
-- Bảng: trips
-- Mô tả: Lưu trữ thông tin chuyến đi của hành khách và tài xế
-- ========================================================
CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT DEFAULT NULL,
    driver_vehicle_id INT DEFAULT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    pickup_lat DECIMAL(10,8) DEFAULT NULL,
    pickup_lng DECIMAL(11,8) DEFAULT NULL,
    dropoff_lat DECIMAL(10,8) DEFAULT NULL,
    dropoff_lng DECIMAL(11,8) DEFAULT NULL,
    trip_type ENUM('ON_DEMAND', 'PRE_BOOK') NOT NULL,
    scheduled_time TIMESTAMP NULL,
    match_status ENUM('PENDING', 'MATCHED', 'CANCELLED') DEFAULT 'PENDING',
    completion_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED') DEFAULT 'NOT_STARTED',
    note_for_driver VARCHAR(500) DEFAULT NULL,
    price DECIMAL(10,2) DEFAULT NULL,
    distance DECIMAL(10,2) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (driver_vehicle_id) REFERENCES driver_vehicles(id) ON DELETE SET NULL,
    INDEX idx_trips_match_status (match_status),
    INDEX idx_trips_trip_type (trip_type)
);

-- Bổ sung cột vehicle_type sau này (Chạy lệnh này vào DB hiện tại)
-- ALTER TABLE trips ADD COLUMN vehicle_type ENUM('MOTORBIKE', 'CAR') DEFAULT 'CAR';

-- ========================================================
-- Bảng: trip_blog_posts
-- Mô tả: Lưu bài đăng chia sẻ chuyến đi lên cộng đồng
-- ========================================================
CREATE TABLE IF NOT EXISTS trip_blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
);
