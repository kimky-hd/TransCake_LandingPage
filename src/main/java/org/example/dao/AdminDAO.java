package org.example.dao;

import org.example.model.AdminDashboardDTO;
import org.example.model.Trip;
import org.example.model.User;
import org.example.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminDAO {

    /**
     * Helper method: set date parameters on a PreparedStatement starting at the given index.
     * Returns the next available parameter index.
     */
    private int setDateParams(PreparedStatement ps, int startIdx, String startDate, String endDate) throws SQLException {
        ps.setString(startIdx, startDate);
        ps.setString(startIdx + 1, endDate);
        return startIdx + 2;
    }

    public AdminDashboardDTO getDashboardStats(String startDate, String endDate) {
        AdminDashboardDTO dto = new AdminDashboardDTO();

        boolean hasDate = (startDate != null && !startDate.trim().isEmpty()
                        && endDate != null && !endDate.trim().isEmpty());

        try (Connection conn = DBContext.getConnection()) {

            // ============ 1. User Stats ============
            StringBuilder sbUser = new StringBuilder();
            sbUser.append("SELECT ");
            sbUser.append("COUNT(*) as total_users, ");
            sbUser.append("SUM(CASE WHEN role = 'passenger' THEN 1 ELSE 0 END) as total_passengers, ");
            sbUser.append("SUM(CASE WHEN role = 'driver' THEN 1 ELSE 0 END) as total_drivers, ");
            sbUser.append("SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) as total_admins, ");
            sbUser.append("SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_users_today ");
            sbUser.append("FROM users");
            if (hasDate) {
                sbUser.append(" WHERE DATE(created_at) >= ? AND DATE(created_at) <= ?");
            }

            try (PreparedStatement ps = conn.prepareStatement(sbUser.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setTotalUsers(rs.getInt("total_users"));
                        dto.setTotalPassengers(rs.getInt("total_passengers"));
                        dto.setTotalDrivers(rs.getInt("total_drivers"));
                        dto.setTotalAdmins(rs.getInt("total_admins"));
                        dto.setNewUsersToday(rs.getInt("new_users_today"));
                    }
                }
            }

            // ============ 2. Trip Stats ============
            StringBuilder sbTrip = new StringBuilder();
            sbTrip.append("SELECT ");
            sbTrip.append("COUNT(*) as total_trips, ");
            sbTrip.append("SUM(CASE WHEN completion_status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_trips, ");
            sbTrip.append("SUM(CASE WHEN match_status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled_trips, ");
            sbTrip.append("SUM(CASE WHEN match_status = 'PENDING' THEN 1 ELSE 0 END) as pending_trips, ");
            sbTrip.append("SUM(CASE WHEN completion_status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_trips, ");
            sbTrip.append("SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as trips_today, ");
            sbTrip.append("SUM(CASE WHEN trip_type = 'ON_DEMAND' THEN 1 ELSE 0 END) as on_demand_trips, ");
            sbTrip.append("SUM(CASE WHEN trip_type = 'PRE_BOOK' THEN 1 ELSE 0 END) as pre_book_trips, ");
            sbTrip.append("SUM(CASE WHEN vehicle_type = 'MOTORBIKE' THEN 1 ELSE 0 END) as motorbike_trips, ");
            sbTrip.append("SUM(CASE WHEN vehicle_type = 'CAR' THEN 1 ELSE 0 END) as car_trips ");
            sbTrip.append("FROM trips");
            if (hasDate) {
                sbTrip.append(" WHERE DATE(created_at) >= ? AND DATE(created_at) <= ?");
            }

            try (PreparedStatement ps = conn.prepareStatement(sbTrip.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setTotalTrips(rs.getInt("total_trips"));
                        dto.setCompletedTrips(rs.getInt("completed_trips"));
                        dto.setCancelledTrips(rs.getInt("cancelled_trips"));
                        dto.setPendingTrips(rs.getInt("pending_trips"));
                        dto.setInProgressTrips(rs.getInt("in_progress_trips"));
                        dto.setTripsToday(rs.getInt("trips_today"));
                        dto.setOnDemandTrips(rs.getInt("on_demand_trips"));
                        dto.setPreBookTrips(rs.getInt("pre_book_trips"));
                        dto.setMotorbikeTrips(rs.getInt("motorbike_trips"));
                        dto.setCarTrips(rs.getInt("car_trips"));

                        int totalFinished = dto.getCompletedTrips() + dto.getCancelledTrips();
                        if (totalFinished > 0) {
                            dto.setCompletionRate((double) dto.getCompletedTrips() / totalFinished * 100.0);
                        } else {
                            dto.setCompletionRate(0);
                        }
                    }
                }
            }

            // ============ 3. Revenue Stats ============
            StringBuilder sbRev = new StringBuilder();
            sbRev.append("SELECT ");
            sbRev.append("COALESCE(SUM(price), 0) as total_revenue, ");
            sbRev.append("COALESCE(SUM(CASE WHEN DATE(COALESCE(completed_at, created_at)) = CURDATE() THEN price ELSE 0 END), 0) as revenue_today, ");
            sbRev.append("COALESCE(SUM(CASE WHEN YEARWEEK(COALESCE(completed_at, created_at), 1) = YEARWEEK(CURDATE(), 1) THEN price ELSE 0 END), 0) as revenue_week, ");
            sbRev.append("COALESCE(SUM(CASE WHEN MONTH(COALESCE(completed_at, created_at)) = MONTH(CURDATE()) AND YEAR(COALESCE(completed_at, created_at)) = YEAR(CURDATE()) THEN price ELSE 0 END), 0) as revenue_month, ");
            sbRev.append("COALESCE(AVG(price), 0) as avg_price, ");
            sbRev.append("COALESCE(SUM(distance), 0) as total_distance ");
            sbRev.append("FROM trips WHERE completion_status = 'COMPLETED'");
            if (hasDate) {
                sbRev.append(" AND DATE(COALESCE(completed_at, created_at)) >= ? AND DATE(COALESCE(completed_at, created_at)) <= ?");
            }

            try (PreparedStatement ps = conn.prepareStatement(sbRev.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setTotalRevenue(rs.getDouble("total_revenue"));
                        dto.setRevenueToday(rs.getDouble("revenue_today"));
                        dto.setRevenueThisWeek(rs.getDouble("revenue_week"));
                        dto.setRevenueThisMonth(rs.getDouble("revenue_month"));
                        dto.setAvgTripPrice(rs.getDouble("avg_price"));
                        dto.setTotalDistance(rs.getDouble("total_distance"));
                    }
                }
            }

            // ============ 4. Driver Application Stats ============
            StringBuilder sbApp = new StringBuilder();
            sbApp.append("SELECT ");
            sbApp.append("SUM(CASE WHEN verification_status = 'PENDING' THEN 1 ELSE 0 END) as pending_apps, ");
            sbApp.append("SUM(CASE WHEN verification_status = 'APPROVED' THEN 1 ELSE 0 END) as approved_apps, ");
            sbApp.append("SUM(CASE WHEN verification_status = 'REJECTED' THEN 1 ELSE 0 END) as rejected_apps ");
            sbApp.append("FROM driver_vehicles");
            if (hasDate) {
                sbApp.append(" WHERE DATE(created_at) >= ? AND DATE(created_at) <= ?");
            }

            try (PreparedStatement ps = conn.prepareStatement(sbApp.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setPendingDriverApps(rs.getInt("pending_apps"));
                        dto.setApprovedDriverApps(rs.getInt("approved_apps"));
                        dto.setRejectedDriverApps(rs.getInt("rejected_apps"));
                    }
                }
            }

            // ============ 5. Revenue Chart Data ============
            String sqlChart;
            if (hasDate) {
                sqlChart = "SELECT DATE(COALESCE(completed_at, created_at)) as trip_date, COALESCE(SUM(price), 0) as daily_amount " +
                           "FROM trips WHERE completion_status = 'COMPLETED' " +
                           "AND DATE(COALESCE(completed_at, created_at)) >= ? AND DATE(COALESCE(completed_at, created_at)) <= ? " +
                           "GROUP BY DATE(COALESCE(completed_at, created_at)) ORDER BY trip_date ASC";
            } else {
                sqlChart = "SELECT DATE(COALESCE(completed_at, created_at)) as trip_date, COALESCE(SUM(price), 0) as daily_amount " +
                           "FROM trips WHERE completion_status = 'COMPLETED' " +
                           "GROUP BY DATE(COALESCE(completed_at, created_at)) ORDER BY trip_date ASC";
            }

            List<Map<String, Object>> dailyRevenue = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sqlChart)) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> day = new HashMap<>();
                        java.sql.Date tripDate = rs.getDate("trip_date");
                        if (tripDate != null) {
                            // Format: DD/MM
                            java.util.Calendar cal = java.util.Calendar.getInstance();
                            cal.setTime(tripDate);
                            String formattedDate = String.format("%02d/%02d", cal.get(java.util.Calendar.DAY_OF_MONTH), cal.get(java.util.Calendar.MONTH) + 1);
                            
                            day.put("label", formattedDate);
                            day.put("date", tripDate.toString());
                        } else {
                            day.put("label", "N/A");
                            day.put("date", "N/A");
                        }
                        day.put("amount", rs.getDouble("daily_amount"));
                        dailyRevenue.add(day);
                    }
                }
            }
            dto.setDailyRevenue(dailyRevenue);

            // ============ 6. All Trips ============
            StringBuilder sbTrips = new StringBuilder();
            sbTrips.append("SELECT t.*, u.full_name as passenger_name, u.phone_number as passenger_phone ");
            sbTrips.append("FROM trips t JOIN users u ON t.passenger_id = u.id ");
            if (hasDate) {
                sbTrips.append("WHERE DATE(t.created_at) >= ? AND DATE(t.created_at) <= ? ");
            }
            sbTrips.append("ORDER BY t.id DESC");

            List<Trip> allTrips = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sbTrips.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Trip trip = new Trip();
                        trip.setId(rs.getInt("id"));
                        trip.setPassengerName(rs.getString("passenger_name"));
                        trip.setPassengerPhone(rs.getString("passenger_phone"));
                        trip.setPickupLocation(rs.getString("pickup_location"));
                        trip.setDropoffLocation(rs.getString("dropoff_location"));
                        trip.setTripType(rs.getString("trip_type"));
                        trip.setMatchStatus(rs.getString("match_status"));
                        trip.setCompletionStatus(rs.getString("completion_status"));
                        trip.setCreatedAt(rs.getTimestamp("created_at"));
                        double price = rs.getDouble("price");
                        trip.setPrice(rs.wasNull() ? null : price);
                        trip.setVehicleType(rs.getString("vehicle_type"));
                        allTrips.add(trip);
                    }
                }
            }
            dto.setAllTrips(allTrips);

            // ============ 7. All Users + Hobbies Stats ============
            StringBuilder sbUsers = new StringBuilder();
            sbUsers.append("SELECT * FROM users");
            if (hasDate) {
                sbUsers.append(" WHERE DATE(created_at) >= ? AND DATE(created_at) <= ?");
            }
            sbUsers.append(" ORDER BY id DESC");

            List<User> allUsers = new ArrayList<>();
            Map<String, Integer> hobbiesCount = new LinkedHashMap<>();

            try (PreparedStatement ps = conn.prepareStatement(sbUsers.toString())) {
                if (hasDate) setDateParams(ps, 1, startDate, endDate);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setFullName(rs.getString("full_name"));
                        user.setPhoneNumber(rs.getString("phone_number"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setStatus(rs.getString("status"));
                        user.setGender(rs.getString("gender"));
                        user.setCreatedAt(rs.getTimestamp("created_at"));

                        String hobbies = rs.getString("hobbies");
                        user.setHobbies(hobbies);

                        // Parse hobbies for SEO stats
                        if (hobbies != null && !hobbies.trim().isEmpty()) {
                            String[] parts = hobbies.split(",");
                            for (String p : parts) {
                                String hobby = p.trim();
                                if (!hobby.isEmpty()) {
                                    // Capitalize first letter
                                    hobby = hobby.substring(0, 1).toUpperCase() + hobby.substring(1).toLowerCase();
                                    hobbiesCount.put(hobby, hobbiesCount.getOrDefault(hobby, 0) + 1);
                                }
                            }
                        }

                        allUsers.add(user);
                    }
                }
            }
            dto.setAllUsers(allUsers);
            dto.setHobbiesStats(hobbiesCount);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dto;
    }
}
