package org.example.dao;

import org.example.model.Trip;
import org.example.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TripDAO {

    /**
     * Thêm một chuyến đi mới và trả về ID được tạo tự động.
     * @param trip Thông tin chuyến đi
     * @return ID của chuyến đi nếu thành công, -1 nếu thất bại
     */
    public int insertTrip(Trip trip) {
        String sql = "INSERT INTO trips (passenger_id, pickup_location, dropoff_location, trip_type, scheduled_time, match_status, completion_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, trip.getPassengerId());
            ps.setString(2, trip.getPickupLocation());
            ps.setString(3, trip.getDropoffLocation());
            ps.setString(4, trip.getTripType());
            ps.setTimestamp(5, trip.getScheduledTime());
            ps.setString(6, trip.getMatchStatus());
            ps.setString(7, trip.getCompletionStatus());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        trip.setId(generatedId);
                        return generatedId;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi insertTrip: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Tạo bài đăng blog cho chuyến đi (loại PRE_BOOK)
     * @param tripId ID của chuyến đi
     * @param title Tiêu đề bài đăng
     * @param content Nội dung bài đăng
     * @return true nếu thành công
     */
    public boolean createBlogForTrip(int tripId, String title, String content) {
        String sql = "INSERT INTO trip_blog_posts (trip_id, title, content) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tripId);
            ps.setString(2, title);
            ps.setString(3, content);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi createBlogForTrip: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cập nhật trạng thái ghép xe và tài xế nhận cuốc
     * @param tripId ID của chuyến đi
     * @param status Trạng thái mới (MATCHED, CANCELLED...)
     * @param driverId ID của tài xế
     * @return true nếu thành công
     */
    public boolean updateMatchStatus(int tripId, String status, int driverId) {
        String sql = "UPDATE trips SET match_status = ?, driver_id = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, driverId);
            ps.setInt(3, tripId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi updateMatchStatus: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cập nhật trạng thái hoàn thành của chuyến đi
     * @param tripId ID của chuyến đi
     * @param status Trạng thái (IN_PROGRESS, COMPLETED, FAILED)
     * @return true nếu thành công
     */
    public boolean updateCompletionStatus(int tripId, String status) {
        String sql = "UPDATE trips SET completion_status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, tripId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi updateCompletionStatus: " + e.getMessage());
        }
        return false;
    }
}
