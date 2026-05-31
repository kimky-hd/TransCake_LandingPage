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
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=not_logged_in");
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
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=missing_location");
            return;
        }

        Timestamp scheduledTimestamp = null;

        if ("PRE_BOOK".equals(tripType)) {
            if (date == null || date.isEmpty() || time == null || time.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=missing_datetime");
                return;
            }
            try {
                String dateTimeStr = date + " " + time;
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                LocalDateTime localDateTime = LocalDateTime.parse(dateTimeStr, formatter);
                scheduledTimestamp = Timestamp.valueOf(localDateTime);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=invalid_datetime");
                return;
            }
        } else {
            tripType = "ON_DEMAND"; // default or fallback
        }

        // Create Trip Object
        Trip trip = new Trip(loggedInUser.getId(), pickup, dropoff, tripType, scheduledTimestamp);
        
        // Save to Database
        int tripId = tripDAO.insertTrip(trip);
        
        if (tripId > 0) {
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
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?success=trip_created");
        } else {
            if ("true".equals(request.getParameter("ajax"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=db_error");
        }
    }
}
