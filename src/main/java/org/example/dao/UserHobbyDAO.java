package org.example.dao;

import org.example.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class UserHobbyDAO {

    // Thêm danh sách sở thích vào CSDL
    public boolean saveHobbies(int userId, List<String> tags) {
        if (tags == null || tags.isEmpty()) return true;

        String sql = "INSERT IGNORE INTO user_hobbies (user_id, hobby_tag) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Dùng Batch để insert nhiều dòng cùng lúc cho tối ưu
            for (String tag : tags) {
                ps.setInt(1, userId);
                ps.setString(2, tag);
                ps.addBatch();
            }
            
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            System.err.println("Lỗi lưu user_hobbies: " + e.getMessage());
            return false;
        }
    }
}
