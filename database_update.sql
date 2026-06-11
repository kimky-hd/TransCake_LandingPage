-- ========================================================
-- TransCake - Script cập nhật cơ sở dữ liệu (Database Update) - Bản Chuẩn MySQL
-- ========================================================

USE transcake_db;

-- Bước 1: Khôi phục lại trạng thái ban đầu của bảng (Xóa các cột nếu đã lỡ tạo trước đó)
-- Lưu ý: Nếu cột nào chưa có, MySQL báo lỗi ở bước này thì có thể bỏ qua và chạy tiếp Bước 2.
ALTER TABLE trips DROP COLUMN IF EXISTS pickup_lat; -- (Có thể báo lỗi cú pháp ở một số bản MySQL cũ, dùng câu lệnh dưới nếu lỗi)
-- ALTER TABLE trips DROP COLUMN pickup_lat;
-- ALTER TABLE trips DROP COLUMN pickup_lng;
-- ALTER TABLE trips DROP COLUMN dropoff_lat;
-- ALTER TABLE trips DROP COLUMN dropoff_lng;
-- ALTER TABLE trips DROP COLUMN driver_vehicle_id;

-- Dưới đây là các câu lệnh chuẩn 100% không dùng IF EXISTS cho ALTER TABLE:

-- --------------------------------------------------------
-- PHẦN A: TẠO MỚI CÁC CỘT TỌA ĐỘ GPS
-- --------------------------------------------------------
ALTER TABLE trips
ADD COLUMN pickup_lat DECIMAL(10,8) DEFAULT NULL COMMENT 'Vĩ độ điểm đón',
ADD COLUMN pickup_lng DECIMAL(11,8) DEFAULT NULL COMMENT 'Kinh độ điểm đón',
ADD COLUMN dropoff_lat DECIMAL(10,8) DEFAULT NULL COMMENT 'Vĩ độ điểm đến',
ADD COLUMN dropoff_lng DECIMAL(11,8) DEFAULT NULL COMMENT 'Kinh độ điểm đến';

-- --------------------------------------------------------
-- PHẦN B: LIÊN KẾT BẢNG XE TÀI XẾ
-- --------------------------------------------------------
ALTER TABLE trips
ADD COLUMN driver_vehicle_id INT DEFAULT NULL AFTER driver_id;

ALTER TABLE trips
ADD CONSTRAINT fk_trips_driver_vehicle 
    FOREIGN KEY (driver_vehicle_id) REFERENCES driver_vehicles(id) ON DELETE SET NULL;

-- --------------------------------------------------------
-- PHẦN C: TẠO CÁC INDEX TỐI ƯU HÓA TÌM KIẾM
-- --------------------------------------------------------
CREATE INDEX idx_trips_match_status ON trips(match_status);
CREATE INDEX idx_trips_trip_type ON trips(trip_type);
