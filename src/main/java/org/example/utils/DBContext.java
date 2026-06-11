package org.example.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBContext {
    private static final HikariDataSource dataSource;

    static {
        // ĐỌC TÊN BIẾN (KEY) TRÊN RENDER - KHÔNG ĐƯỢC SỬA 3 DÒNG NÀY
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        // Nếu chạy ở Local (url sẽ null), dùng thông số máy cá nhân
        if (url == null || url.isEmpty()) {
            url = "jdbc:mysql://localhost:3306/transcake_db";
            user = "root";
            pass = "1234";
        }

        HikariConfig config = new HikariConfig();
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setJdbcUrl(url);
        config.setUsername(user);
        config.setPassword(pass);

        // Pool Optimization Config
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(5);

        // MySQL standard cache optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
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