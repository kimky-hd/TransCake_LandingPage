package org.example.dao;

import org.example.model.User;
import org.example.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TestDBUpdate {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        User user = dao.findByEmail("kimkyvu2004hd@gmail.com");
        if (user != null) {
            System.out.println("Found user ID: " + user.getId());
            String sql = "UPDATE users SET password_hash = ?, status = ? WHERE id = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, "testHash123");
                ps.setString(2, "REQUIRE_RESET");
                ps.setInt(3, user.getId());

                int rows = ps.executeUpdate();
                System.out.println("Update success, rows affected: " + rows);
            } catch (SQLException e) {
                System.err.println("SQLException: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("User not found!");
        }
    }
}
