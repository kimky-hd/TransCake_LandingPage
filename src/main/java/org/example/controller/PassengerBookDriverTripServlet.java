package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.example.dao.TripDAO;
import org.example.model.Trip;
import org.example.model.User;
import org.example.websocket.TripWebSocketEndpoint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/passenger/book-driver-trip")
public class PassengerBookDriverTripServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        if (!"passenger".equals(loggedInUser.getRole())) {
            result.put("success", false);
            result.put("message", "Chỉ hành khách mới có thể đặt chuyến này.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            Map<String, Object> body = gson.fromJson(request.getReader(), Map.class);
            if (body == null || !body.containsKey("tripId")) {
                result.put("success", false);
                result.put("message", "Thiếu thông tin tripId.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int tripId = ((Double) body.get("tripId")).intValue();

            // Book the trip
            boolean success = tripDAO.bookDriverTrip(tripId, loggedInUser.getId());
            if (success) {
                // Lấy thông tin chuyến đi để gửi thông báo
                Trip trip = tripDAO.getTripById(tripId);
                if (trip != null && trip.getDriverId() != null) {
                    JsonObject payload = new JsonObject();
                    payload.addProperty("tripId", tripId);
                    payload.addProperty("passengerName", loggedInUser.getFullName());
                    TripWebSocketEndpoint.sendMessageToUser("driver", (long) trip.getDriverId(), "PASSENGER_BOOKED", payload);
                    
                    // Gửi email xác nhận cho hành khách
                    org.example.service.EmailService.sendTripBookingConfirmationAsync(loggedInUser, trip);
                }

                result.put("success", true);
                result.put("message", "Đặt chuyến thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Chuyến đi này đã được người khác đặt hoặc không còn khả dụng.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi xử lý dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
