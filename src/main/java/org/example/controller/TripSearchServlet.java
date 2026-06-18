package org.example.controller;

import org.example.dao.TripDAO;
import org.example.model.Trip;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/trip-search")
public class TripSearchServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        // Ensure user is logged in
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=not_logged_in");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        String pickup = request.getParameter("pickup");
        String dropoff = request.getParameter("dropoff");
        String tripType = request.getParameter("tripType");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String shareToBlog = request.getParameter("shareToBlog");

        // Basic validation
        if (pickup == null || pickup.trim().isEmpty() || dropoff == null || dropoff.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=missing_location");
            return;
        }

        Timestamp scheduledTimestamp = null;

        if ("PRE_BOOK".equals(tripType)) {
            if (date == null || date.isEmpty() || time == null || time.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=missing_datetime");
                return;
            }
            try {
                String dateTimeStr = date + " " + time;
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                LocalDateTime localDateTime = LocalDateTime.parse(dateTimeStr, formatter);
                scheduledTimestamp = Timestamp.valueOf(localDateTime);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=invalid_datetime");
                return;
            }
            // Kiểm tra trùng PRE_BOOK
            if (tripDAO.getActivePreBookTrip(loggedInUser.getId()) != null) {
                if ("true".equals(request.getParameter("ajax"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Bạn đã có chuyến Đặt trước. Vui lòng hủy trước khi tạo mới!\"}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/dashboard?error=limit_exceeded");
                return;
            }
        } else {
            tripType = "ON_DEMAND"; // default or fallback
            // Kiểm tra trùng ON_DEMAND
            if (tripDAO.getActiveOnDemandTrip(loggedInUser.getId()) != null) {
                if ("true".equals(request.getParameter("ajax"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Bạn đang tìm chuyến Đặt ngay. Vui lòng hủy trước khi tạo mới!\"}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/dashboard?error=limit_exceeded");
                return;
            }
        }

        String note = request.getParameter("note");
        Double price = null;
        Double distance = null;
        try {
            if (request.getParameter("price") != null && !request.getParameter("price").isEmpty()) {
                price = Double.parseDouble(request.getParameter("price"));
            }
            if (request.getParameter("distance") != null && !request.getParameter("distance").isEmpty()) {
                distance = Double.parseDouble(request.getParameter("distance"));
            }
        } catch (NumberFormatException e) {
            System.err.println("Error parsing price/distance: " + e.getMessage());
        }

        String vehicleType = request.getParameter("vehicleType");
        if (vehicleType == null || vehicleType.isEmpty()) vehicleType = "CAR";

        Double pickupLat = null, pickupLng = null, dropoffLat = null, dropoffLng = null;
        try {
            if (request.getParameter("pickupLat") != null && !request.getParameter("pickupLat").isEmpty()) pickupLat = Double.parseDouble(request.getParameter("pickupLat"));
            if (request.getParameter("pickupLng") != null && !request.getParameter("pickupLng").isEmpty()) pickupLng = Double.parseDouble(request.getParameter("pickupLng"));
            if (request.getParameter("dropoffLat") != null && !request.getParameter("dropoffLat").isEmpty()) dropoffLat = Double.parseDouble(request.getParameter("dropoffLat"));
            if (request.getParameter("dropoffLng") != null && !request.getParameter("dropoffLng").isEmpty()) dropoffLng = Double.parseDouble(request.getParameter("dropoffLng"));
        } catch (NumberFormatException e) {
            System.err.println("Error parsing coordinates: " + e.getMessage());
        }

        // Create Trip Object (truyền đầy đủ dữ liệu)
        Trip trip = new Trip(loggedInUser.getId(), pickup, pickupLat, pickupLng, dropoff, dropoffLat, dropoffLng, tripType, scheduledTimestamp, note, price, distance, vehicleType);
        
        // Save to Database
        int tripId = tripDAO.insertTrip(trip);
        
        if (tripId > 0) {
            // Broadcast via WebSocket
            if ("PRE_BOOK".equals(tripType)) {
                org.example.websocket.TripWebSocketEndpoint.broadcastToAllDrivers("NEW_PRE_BOOK_TRIP", null);
            } else {
                org.example.websocket.TripWebSocketEndpoint.broadcastToAllDrivers("NEW_ON_DEMAND_TRIP", null);
            }

            // Hybrid Logic: Automatically generate blog post for PRE_BOOK if requested
            if ("PRE_BOOK".equals(tripType) && "true".equals(shareToBlog)) {
                String title = "Tìm bạn đường từ " + pickup + " đến " + dropoff;
                String content = "Mình có chuyến đi từ " + pickup + " đến " + dropoff + " vào lúc " + 
                                 scheduledTimestamp.toString() + ". Ai có nhu cầu đi chung thì liên hệ nhé!";
                tripDAO.createBlogForTrip(tripId, title, content);
            }
            if ("true".equals(request.getParameter("ajax"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"tripId\": " + tripId + "}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?success=trip_created");
        } else {
            if ("true".equals(request.getParameter("ajax"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?error=db_error");
        }
    }
}
