#!/bin/bash
# Kịch bản cài đặt tự động VPS Ubuntu 22.04/24.04 cho TransCake

echo "1. Cập nhật hệ thống..."
apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "2. Xóa bỏ Apache2 (nếu có) để tránh xung đột port 80 với Nginx..."
systemctl stop apache2
apt remove apache2 -y

echo "3. Cài đặt MySQL Server 8.0..."
DEBIAN_FRONTEND=noninteractive apt install mysql-server -y

echo "4. Cấu hình Database và mật khẩu root..."
# Đặt pass root là 1234 để khớp với code DBContext.java
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';"
mysql -e "FLUSH PRIVILEGES;"

echo "5. Import dữ liệu ban đầu..."
mysql -u root -p1234 < /root/database.sql
mysql -u root -p1234 transcake_db < /root/database_trip_schema.sql

echo "5.1. Đồng bộ các cột mới thêm..."
mysql -e "USE transcake_db; ALTER TABLE trips ADD COLUMN IF NOT EXISTS vehicle_type ENUM('MOTORBIKE', 'CAR') DEFAULT 'CAR';"
mysql -e "USE transcake_db; ALTER TABLE trips ADD COLUMN IF NOT EXISTS cancel_reason VARCHAR(255) DEFAULT NULL;"

echo "6. Cài đặt Java JDK 17..."
DEBIAN_FRONTEND=noninteractive apt install openjdk-17-jdk -y

echo "7. Cài đặt Apache Tomcat 10..."
DEBIAN_FRONTEND=noninteractive apt install tomcat10 -y

echo "8. Triển khai code (Deploy WAR)..."
systemctl stop tomcat10
rm -rf /var/lib/tomcat10/webapps/ROOT
rm -f /var/lib/tomcat10/webapps/ROOT.war
cp /root/ROOT.war /var/lib/tomcat10/webapps/
chown tomcat:tomcat /var/lib/tomcat10/webapps/ROOT.war
systemctl start tomcat10

echo "9. Cài đặt Nginx làm Proxy ngược (Chặn port 80 đưa vào port 8080)..."
DEBIAN_FRONTEND=noninteractive apt install nginx -y
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF
systemctl restart nginx

echo "=========================================================="
echo "CÀI ĐẶT THÀNH CÔNG!"
echo "Bạn có thể mở trình duyệt và truy cập thẳng vào địa chỉ IP."
echo "=========================================================="
