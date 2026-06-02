package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.DriverVehicleDAO;
import org.example.dao.TripDAO;
import org.example.model.DriverVehicle;
import org.example.model.Trip;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/driver/proposals")
public class DriverProposalsServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private DriverVehicleDAO vehicleDAO = new DriverVehicleDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"driver".equals(loggedInUser.getRole())) {
            result.put("success", false);
            result.put("message", "Chỉ tài xế mới được xem đề xuất chuyến đi.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            // Get driver vehicle
            DriverVehicle vehicle = vehicleDAO.getVehicleByUserId(loggedInUser.getId());
            if (vehicle == null) {
                result.put("success", false);
                result.put("message", "Tài xế chưa đăng ký phương tiện.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Get pending trips matching vehicle type
            List<Trip> pendingTrips = tripDAO.getPendingTripsByVehicleType(vehicle.getVehicleType());
            
            // Get driver coordinates from request (if available)
            Double driverLat = null;
            Double driverLng = null;
            try {
                if (request.getParameter("lat") != null) driverLat = Double.parseDouble(request.getParameter("lat"));
                if (request.getParameter("lng") != null) driverLng = Double.parseDouble(request.getParameter("lng"));
            } catch (NumberFormatException e) {
                System.err.println("Invalid driver coordinates passed to proposals api.");
            }

            // Rank trips using TripMatchingService
            org.example.service.TripMatchingService matchingService = new org.example.service.TripMatchingService();
            List<Trip> rankedTrips = matchingService.rankTripsForDriver(loggedInUser, pendingTrips, driverLat, driverLng);
            
            result.put("success", true);
            result.put("trips", rankedTrips);
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
