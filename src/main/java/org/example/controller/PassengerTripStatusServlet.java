package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.DriverVehicleDAO;
import org.example.dao.TripDAO;
import org.example.dao.UserDAO;
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
import java.util.Map;

@WebServlet("/api/passenger/trip-status")
public class PassengerTripStatusServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private UserDAO userDAO = new UserDAO();
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

        try {
            String tripIdParam = request.getParameter("tripId");
            Trip activeTrip = null;
            
            // Nếu có truyền tripId từ client lên, ưu tiên tìm đích danh cuốc đó
            if (tripIdParam != null && !tripIdParam.trim().isEmpty()) {
                try {
                    int tripId = Integer.parseInt(tripIdParam);
                    Trip t = tripDAO.getTripById(tripId);
                    if (t != null && t.getPassengerId() == loggedInUser.getId()) {
                        activeTrip = t;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid tripId param: " + tripIdParam);
                }
            }
            
            // Nếu không truyền hoặc không tìm thấy, fallback về query cũ
            if (activeTrip == null) {
                activeTrip = tripDAO.getActiveOnDemandTrip(loggedInUser.getId());
                if (activeTrip == null) {
                    activeTrip = tripDAO.getActivePreBookTrip(loggedInUser.getId());
                }
            }

            if (activeTrip != null) {
                result.put("success", true);
                
                // Trả về trạng thái cụ thể để UI hiển thị đúng thông báo
                if ("COMPLETED".equals(activeTrip.getCompletionStatus())) {
                    result.put("status", "COMPLETED");
                } else if ("CANCELLED".equals(activeTrip.getMatchStatus())) {
                    result.put("status", "CANCELLED");
                } else {
                    result.put("status", activeTrip.getMatchStatus());
                }
                
                if ("MATCHED".equals(activeTrip.getMatchStatus()) && activeTrip.getDriverId() != null) {
                    User driver = userDAO.getUserById(activeTrip.getDriverId());
                    DriverVehicle vehicle = vehicleDAO.getVehicleByUserId(activeTrip.getDriverId());
                    
                    if (driver != null) {
                        Map<String, String> driverInfo = new HashMap<>();
                        driverInfo.put("fullName", driver.getFullName());
                        driverInfo.put("phoneNumber", driver.getPhoneNumber());
                        driverInfo.put("hobbies", driver.getHobbies());
                        
                        if (vehicle != null) {
                            driverInfo.put("vehicleType", vehicle.getVehicleType());
                            driverInfo.put("vehicleName", vehicle.getVehicleName());
                            driverInfo.put("licensePlate", vehicle.getLicensePlate());
                        }
                        result.put("driver", driverInfo);
                    }
                }
            } else {
                result.put("success", true);
                result.put("status", "NO_ACTIVE_TRIP");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
