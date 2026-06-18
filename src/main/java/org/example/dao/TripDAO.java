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
     * Lấy trạng thái match_status của một chuyến đi theo ID
     * @return match_status string, hoặc null nếu không tìm thấy
     */
    public String getTripMatchStatus(int tripId) {
        String sql = "SELECT match_status FROM trips WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("match_status");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getTripMatchStatus: " + e.getMessage());
        }
        return null;
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
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getActiveOnDemandTrip: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy chuyến đi duy nhất đang IN_PROGRESS của Tài xế
     */
    public Trip getInProgressTripForDriver(int driverId) {
        String sql = "SELECT t.*, u.full_name, u.phone_number, u.gender FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.driver_id = ? AND t.completion_status = 'IN_PROGRESS' ORDER BY t.id DESC LIMIT 1";
        return fetchSingleTripForDriver(sql, driverId, "getInProgressTripForDriver");
    }

    /**
     * Lấy chuyến đi ON_DEMAND mà tài xế đã nhận (NOT_STARTED hoặc IN_PROGRESS)
     */
    public Trip getActiveOnDemandTripForDriver(int driverId) {
        String sql = "SELECT t.*, u.full_name, u.phone_number, u.gender FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.driver_id = ? AND t.trip_type = 'ON_DEMAND' AND t.match_status = 'MATCHED' AND t.completion_status IN ('NOT_STARTED', 'IN_PROGRESS') ORDER BY t.id DESC LIMIT 1";
        return fetchSingleTripForDriver(sql, driverId, "getActiveOnDemandTripForDriver");
    }

    /**
     * Lấy chuyến đi PRE_BOOK mà tài xế đã nhận (NOT_STARTED hoặc IN_PROGRESS)
     */
    public Trip getActivePreBookTripForDriver(int driverId) {
        String sql = "SELECT t.*, u.full_name, u.phone_number, u.gender FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.driver_id = ? AND t.trip_type = 'PRE_BOOK' AND t.match_status = 'MATCHED' AND t.completion_status IN ('NOT_STARTED', 'IN_PROGRESS') ORDER BY t.id DESC LIMIT 1";
        return fetchSingleTripForDriver(sql, driverId, "getActivePreBookTripForDriver");
    }

    // Helper method to avoid code duplication
    private Trip fetchSingleTripForDriver(String sql, int driverId, String methodName) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
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
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    trip.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    
                    trip.setPassengerName(rs.getString("full_name"));
                    trip.setPassengerPhone(rs.getString("phone_number"));
                    trip.setPassengerGender(rs.getString("gender"));
                    
                    return trip;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi " + methodName + ": " + e.getMessage());
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
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
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
        String sql = "SELECT t.*, u.full_name, u.phone_number, u.gender FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.match_status = 'PENDING' AND t.vehicle_type = ? ORDER BY t.id DESC";
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
                    trip.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Passenger details
                    trip.setPassengerName(rs.getString("full_name"));
                    trip.setPassengerPhone(rs.getString("phone_number"));
                    trip.setPassengerGender(rs.getString("gender"));
                    
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
        // Chỉ áp dụng cho ON_DEMAND: set IN_PROGRESS ngay lập tức
        String sql = "UPDATE trips SET match_status = 'MATCHED', completion_status = 'IN_PROGRESS', driver_id = ? WHERE id = ? AND match_status = 'PENDING' AND driver_id IS NULL AND trip_type = 'ON_DEMAND'";
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

    /**
     * Tài xế nhận chuyến đặt trước (PRE_BOOK): chỉ set MATCHED + NOT_STARTED
     * Không khóa tài xế, cho phép nhận nhiều chuyến PRE_BOOK cùng lúc
     */
    public boolean acceptPreBookTrip(int tripId, int driverId) {
        String sql = "UPDATE trips SET match_status = 'MATCHED', driver_id = ? WHERE id = ? AND match_status = 'PENDING' AND driver_id IS NULL AND trip_type = 'PRE_BOOK'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi acceptPreBookTrip: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy danh sách chuyến đặt trước mà tài xế đã nhận (MATCHED + NOT_STARTED)
     */
    public List<Trip> getUpcomingTripsForDriver(int driverId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.phone_number, u.gender FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.driver_id = ? AND t.trip_type = 'PRE_BOOK' AND t.match_status = 'MATCHED' AND t.completion_status = 'NOT_STARTED' ORDER BY t.scheduled_time ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
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
                    trip.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    trip.setPassengerName(rs.getString("full_name"));
                    trip.setPassengerPhone(rs.getString("phone_number"));
                    trip.setPassengerGender(rs.getString("gender"));
                    trips.add(trip);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getUpcomingTripsForDriver: " + e.getMessage());
        }
        return trips;
    }

    /**
     * Lấy danh sách chuyến đặt trước của hành khách (PENDING hoặc MATCHED, chưa bắt đầu)
     */
    public List<Trip> getUpcomingTripsForPassenger(int passengerId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT t.*, COALESCE(u2.full_name, '') AS driver_name, COALESCE(u2.phone_number, '') AS driver_phone FROM trips t LEFT JOIN users u2 ON t.driver_id = u2.id WHERE t.passenger_id = ? AND t.trip_type = 'PRE_BOOK' AND t.match_status IN ('PENDING', 'MATCHED') AND t.completion_status = 'NOT_STARTED' ORDER BY t.scheduled_time ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
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
                    trip.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setNoteForDriver(rs.getString("note_for_driver"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    if (rs.getObject("driver_id") != null) trip.setDriverId(rs.getInt("driver_id"));
                    // Store driver info in passengerName/Phone fields (reuse for display)
                    trip.setPassengerName(rs.getString("driver_name"));
                    trip.setPassengerPhone(rs.getString("driver_phone"));
                    trips.add(trip);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getUpcomingTripsForPassenger: " + e.getMessage());
        }
        return trips;
    }

    /**
     * Hủy tất cả các chuyến đi của người dùng dựa trên vai trò cũ.
     * @param userId ID của người dùng
     * @param oldRole Vai trò cũ (passenger hoặc driver)
     * @return true nếu thực thi SQL không bị lỗi (có thể không có dòng nào bị ảnh hưởng)
     */
    public boolean cancelAllTripsForUser(int userId, String oldRole) {
        String sql;
        if ("driver".equalsIgnoreCase(oldRole)) {
            // Hủy các chuyến mà tài xế đã nhận
            sql = "UPDATE trips SET match_status = 'CANCELLED' WHERE driver_id = ? AND match_status IN ('PENDING', 'MATCHED')";
        } else {
            // Hủy các chuyến mà hành khách đã đặt
            sql = "UPDATE trips SET match_status = 'CANCELLED' WHERE passenger_id = ? AND match_status IN ('PENDING', 'MATCHED')";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("Lỗi cancelAllTripsForUser: " + e.getMessage());
        }
        return false;
    }

    public boolean startTripByDriver(int tripId, int driverId) {
        String sql = "UPDATE trips SET completion_status = 'IN_PROGRESS' WHERE id = ? AND driver_id = ? AND match_status = 'MATCHED' AND completion_status = 'NOT_STARTED'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.setInt(2, driverId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi startTripByDriver: " + e.getMessage());
        }
        return false;
    }

    public java.util.List<Trip> getTripHistoryByPassenger(int passengerId) {
        java.util.List<Trip> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM trips WHERE passenger_id = ? AND (completion_status = 'COMPLETED' OR match_status = 'CANCELLED') ORDER BY id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(trip);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getTripHistoryByPassenger: " + e.getMessage());
        }
        return list;
    }

    public java.util.List<Trip> getTripHistoryByDriver(int driverId) {
        java.util.List<Trip> list = new java.util.ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.phone_number FROM trips t JOIN users u ON t.passenger_id = u.id WHERE t.driver_id = ? AND (t.completion_status = 'COMPLETED' OR t.match_status = 'CANCELLED') ORDER BY t.id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    trip.setPassengerName(rs.getString("full_name"));
                    trip.setPassengerPhone(rs.getString("phone_number"));
                    list.add(trip);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getTripHistoryByDriver: " + e.getMessage());
        }
        return list;
    }
    public boolean completeTripByDriver(int tripId, int driverId) {
        String sql = "UPDATE trips SET completion_status = 'COMPLETED' WHERE id = ? AND driver_id = ? AND completion_status = 'IN_PROGRESS'";
        try (Connection c = DBContext.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.setInt(2, driverId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi completeTripByDriver: " + e.getMessage());
            return false;
        }
    }

    public Trip getTripById(int id) {
        String sql = "SELECT * FROM trips WHERE id = ?";
        try (Connection c = DBContext.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Trip trip = new Trip();
                    trip.setId(rs.getInt("id"));
                    trip.setPassengerId(rs.getInt("passenger_id"));
                    trip.setPickupLocation(rs.getString("pickup_location"));
                    trip.setDropoffLocation(rs.getString("dropoff_location"));
                    trip.setTripType(rs.getString("trip_type"));
                    trip.setMatchStatus(rs.getString("match_status"));
                    trip.setCompletionStatus(rs.getString("completion_status"));
                    trip.setVehicleType(rs.getString("vehicle_type"));
                    if (rs.getObject("price") != null) trip.setPrice(rs.getDouble("price"));
                    if (rs.getObject("distance") != null) trip.setDistance(rs.getDouble("distance"));
                    trip.setCreatedAt(rs.getTimestamp("created_at"));
                    trip.setDriverId(rs.getInt("driver_id"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi getTripById: " + e.getMessage());
        }
        return null;
    }

    public boolean cancelTripByDriver(int tripId, int driverId, String cancelReason) {
        String sql = "UPDATE trips SET match_status = 'CANCELLED', completion_status = 'FAILED', cancel_reason = ? WHERE id = ? AND driver_id = ?";
        try (Connection c = DBContext.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, cancelReason);
            ps.setInt(2, tripId);
            ps.setInt(3, driverId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cancelTripByDriver: " + e.getMessage());
            return false;
        }
    }
}
