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
-- Bảng: trips
-- Mô tả: Lưu trữ thông tin chuyến đi của hành khách và tài xế
-- ========================================================
CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT DEFAULT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    trip_type ENUM('ON_DEMAND', 'PRE_BOOK') NOT NULL,
    scheduled_time TIMESTAMP NULL,
    match_status ENUM('PENDING', 'MATCHED', 'CANCELLED') DEFAULT 'PENDING',
    completion_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED') DEFAULT 'NOT_STARTED',
    note_for_driver VARCHAR(500) DEFAULT NULL,
    price DECIMAL(10,2) DEFAULT NULL,
    distance DECIMAL(10,2) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Bổ sung cột vehicle_type sau này (Chạy lệnh này vào DB hiện tại)
-- ALTER TABLE trips ADD COLUMN vehicle_type ENUM('MOTORBIKE', 'CAR') DEFAULT 'CAR';
