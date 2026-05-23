package org.example.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    public static Connection getConnection() throws SQLException {
        // ĐỌC TÊN BIẾN (KEY) TRÊN RENDER - KHÔNG ĐƯỢC SỬA 3 DÒNG NÀY
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        // Nếu chạy ở Local (url sẽ null), dùng thông số máy cá nhân
        if (url == null || url.isEmpty()) {
            url = "jdbc:mysql://localhost:3306/resume_db";
            user = "root";
            pass = "1234";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found!", e);
        }
    }

    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("--- KẾT NỐI THÀNH CÔNG ---");
                System.out.println("Đang kết nối tới: " + conn.getMetaData().getURL());
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("--- KẾT NỐI THẤT BẠI ---");
            e.printStackTrace();
        }
    }
}