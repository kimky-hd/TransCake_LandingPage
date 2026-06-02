<%@ page import="org.example.utils.DBContext" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Test Insert</title></head>
<body>
<%
    String sql = "INSERT INTO trips (passenger_id, pickup_location, pickup_lat, pickup_lng, dropoff_location, dropoff_lat, dropoff_lng, trip_type, scheduled_time, match_status, completion_status, note_for_driver, price, distance, vehicle_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         
        ps.setInt(1, 1); // assume passenger 1 exists
        ps.setString(2, "Test Pickup");
        ps.setNull(3, java.sql.Types.DECIMAL);
        ps.setNull(4, java.sql.Types.DECIMAL);
        ps.setString(5, "Test Dropoff");
        ps.setNull(6, java.sql.Types.DECIMAL);
        ps.setNull(7, java.sql.Types.DECIMAL);
        ps.setString(8, "ON_DEMAND");
        ps.setNull(9, java.sql.Types.TIMESTAMP);
        ps.setString(10, "PENDING");
        ps.setString(11, "NOT_STARTED");
        ps.setNull(12, java.sql.Types.VARCHAR);
        ps.setNull(13, java.sql.Types.DECIMAL);
        ps.setNull(14, java.sql.Types.DECIMAL);
        ps.setString(15, "CAR");
        
        int rows = ps.executeUpdate();
        out.println("<h2>Thành công! Rows affected: " + rows + "</h2>");
    } catch (Exception e) {
        out.println("<h2>Lỗi: " + e.getMessage() + "</h2>");
    }
%>
</body>
</html>
