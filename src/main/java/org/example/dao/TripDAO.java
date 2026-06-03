package org.example.dao;

import org.example.model.Trip;
import org.example.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.ArrayList;
import org.example.model.BlogPost;

public class TripDAO {

    /**
     * Thêm một chuyến đi mới và trả về ID được tạo tự động.
     * @param trip Thông tin chuyến đi
     * @return ID của chuyến đi nếu thành công, -1 nếu thất bại
     */
    public int insertTrip(Trip trip) {
        String sql = "INSERT INTO trips (passenger_id, pickup_location, pickup_lat, pickup_lng, dropoff_location, dropoff_lat, dropoff_lng, trip_type, scheduled_time, match_status, completion_status, note_for_driver, price, distance, vehicle_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, trip.getPassengerId());
            ps.setString(2, trip.getPickupLocation());
            if (trip.getPickupLat() != null) ps.setDouble(3, trip.getPickupLat()); else ps.setNull(3, java.sql.Types.DECIMAL);
            if (trip.getPickupLng() != null) ps.setDouble(4, trip.getPickupLng()); else ps.setNull(4, java.sql.Types.DECIMAL);
            ps.setString(5, trip.getDropoffLocation());
            if (trip.getDropoffLat() != null) ps.setDouble(6, trip.getDropoffLat()); else ps.setNull(6, java.sql.Types.DECIMAL);
            if (trip.getDropoffLng() != null) ps.setDouble(7, trip.getDropoffLng()); else ps.setNull(7, java.sql.Types.DECIMAL);
            ps.setString(8, trip.getTripType());
            ps.setTimestamp(9, trip.getScheduledTime());
            ps.setString(10, trip.getMatchStatus());
            ps.setString(11, trip.getCompletionStatus());
            ps.setString(12, trip.getNoteForDriver());
            if (trip.getPrice() != null) {
                ps.setDouble(13, trip.getPrice());
            } else {
                ps.setNull(13, java.sql.Types.DECIMAL);
            }
            if (trip.getDistance() != null) {
                ps.setDouble(14, trip.getDistance());
            } else {
                ps.setNull(14, java.sql.Types.DECIMAL);
            }
            if (trip.getVehicleType() != null) {
                ps.setString(15, trip.getVehicleType());
            } else {
                ps.setNull(15, java.sql.Types.VARCHAR);
            }
            
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

    /**
     * Hủy chuyến đi (Cập nhật match_status = CANCELLED)
     * @param tripId ID của chuyến đi
     * @return true nếu thành công
     */
    public boolean cancelTrip(int tripId) {
        String sql = "UPDATE trips SET match_status = 'CANCELLED' WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tripId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cancelTrip: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy chuyến đi ON_DEMAND đang trong trạng thái chờ (PENDING) hoặc đã được nhận (MATCHED)
     */
    public Trip getActiveOnDemandTrip(int passengerId) {
        String sql = "SELECT * FROM trips WHERE passenger_id = ? AND trip_type = 'ON_DEMAND' AND match_status IN ('PENDING', 'MATCHED') AND completion_status IN ('NOT_STARTED', 'IN_PROGRESS') ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    if (rs.getObject("pickup_lat") != null) trip.setPickupLat(rs.getDouble("pickup_lat"));
                    if (rs.getObject("pickup_lng") != null) trip.setPickupLng(rs.getDouble("pickup_lng"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    if (rs.getObject("dropoff_lat") != null) trip.setDropoffLat(rs.getDouble("dropoff_lat"));
                    if (rs.getObject("dropoff_lng") != null) trip.setDropoffLng(rs.getDouble("dropoff_lng"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    if (rs.getObject("driver_id") != null) trip.setDriverId(rs.getInt("driver_id"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getActiveOnDemandTrip: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy chuyến đi PRE_BOOK đang trong trạng thái chờ (PENDING) hoặc đã được nhận (MATCHED)
     */
    public Trip getActivePreBookTrip(int passengerId) {
        String sql = "SELECT * FROM trips WHERE passenger_id = ? AND trip_type = 'PRE_BOOK' AND match_status IN ('PENDING', 'MATCHED') AND completion_status IN ('NOT_STARTED', 'IN_PROGRESS') ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    if (rs.getObject("pickup_lat") != null) trip.setPickupLat(rs.getDouble("pickup_lat"));
                    if (rs.getObject("pickup_lng") != null) trip.setPickupLng(rs.getDouble("pickup_lng"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    if (rs.getObject("dropoff_lat") != null) trip.setDropoffLat(rs.getDouble("dropoff_lat"));
                    if (rs.getObject("dropoff_lng") != null) trip.setDropoffLng(rs.getDouble("dropoff_lng"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    if (rs.getObject("driver_id") != null) trip.setDriverId(rs.getInt("driver_id"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getActivePreBookTrip: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy danh sách các bài đăng blog từ database kèm theo thông tin chuyến đi và người đăng
     * @return Danh sách bài đăng
     */
    public List<BlogPost> getAllActiveBlogPosts() {
        List<BlogPost> posts = new ArrayList<>();
        String sql = "SELECT b.id, b.trip_id, b.title, b.content, b.is_active, " +
                     "u.full_name, t.created_at, t.pickup_location, t.dropoff_location " +
                     "FROM trip_blog_posts b " +
                     "JOIN trips t ON b.trip_id = t.id " +
                     "JOIN users u ON t.passenger_id = u.id " +
                     "WHERE b.is_active = TRUE " +
                     "ORDER BY b.id DESC";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                BlogPost post = new BlogPost(
                    rs.getInt("id"),
                    rs.getInt("trip_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getBoolean("is_active"),
                    rs.getString("full_name"),
                    rs.getTimestamp("created_at"),
                    rs.getString("pickup_location"),
                    rs.getString("dropoff_location")
                );
                posts.add(post);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getAllActiveBlogPosts: " + e.getMessage());
        }
        return posts;
    }

    /**
     * Lấy danh sách chuyến đi đang chờ theo loại phương tiện
     */
    public List<Trip> getPendingTripsByVehicleType(String vehicleType) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trips WHERE match_status = 'PENDING' AND vehicle_type = ? ORDER BY id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicleType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    if (rs.getObject("pickup_lat") != null) trip.setPickupLat(rs.getDouble("pickup_lat"));
                    if (rs.getObject("pickup_lng") != null) trip.setPickupLng(rs.getDouble("pickup_lng"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    if (rs.getObject("dropoff_lat") != null) trip.setDropoffLat(rs.getDouble("dropoff_lat"));
                    if (rs.getObject("dropoff_lng") != null) trip.setDropoffLng(rs.getDouble("dropoff_lng"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    trips.add(trip);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getPendingTripsByVehicleType: " + e.getMessage());
        }
        return trips;
    }

    /**
     * Tài xế nhận chuyến đi
     */
    public boolean acceptTrip(int tripId, int driverId) {
        // Sử dụng driver_id IS NULL để chống race condition (2 tài xế nhận cùng lúc)
        String sql = "UPDATE trips SET match_status = 'MATCHED', completion_status = 'IN_PROGRESS', driver_id = ? WHERE id = ? AND match_status = 'PENDING' AND driver_id IS NULL";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi acceptTrip: " + e.getMessage());
        }
        return false;
    }
}
