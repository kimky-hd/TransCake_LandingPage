CREATE TABLE IF NOT EXISTS driver_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_type ENUM('MOTORBIKE', 'CAR') NOT NULL,
    vehicle_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT NULL,
    driver_vehicle_id INT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    pickup_lat DECIMAL(10,8) DEFAULT NULL,
    pickup_lng DECIMAL(11,8) DEFAULT NULL,
    dropoff_lat DECIMAL(10,8) DEFAULT NULL,
    dropoff_lng DECIMAL(11,8) DEFAULT NULL,
    trip_type ENUM('ON_DEMAND', 'PRE_BOOK') NOT NULL,
    scheduled_time DATETIME NULL,
    match_status ENUM('PENDING', 'MATCHED', 'CANCELLED') DEFAULT 'PENDING',
    completion_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED') DEFAULT 'NOT_STARTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES users(id),
    FOREIGN KEY (driver_id) REFERENCES users(id),
    FOREIGN KEY (driver_vehicle_id) REFERENCES driver_vehicles(id) ON DELETE SET NULL,
    INDEX idx_trips_match_status (match_status),
    INDEX idx_trips_trip_type (trip_type)
);

CREATE TABLE IF NOT EXISTS trip_blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
);
