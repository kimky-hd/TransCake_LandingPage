CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    dropoff_location VARCHAR(255) NOT NULL,
    trip_type ENUM('ON_DEMAND', 'PRE_BOOK') NOT NULL,
    scheduled_time DATETIME NULL,
    match_status ENUM('PENDING', 'MATCHED', 'CANCELLED') DEFAULT 'PENDING',
    completion_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED') DEFAULT 'NOT_STARTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES users(id),
    FOREIGN KEY (driver_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS trip_blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
);
