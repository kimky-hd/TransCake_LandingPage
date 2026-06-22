package org.example.controller;

import com.google.gson.Gson;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/driver/start-prebook-trip")
public class StartPreBookTripServlet extends HttpServlet {
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

        User user = (User) session.getAttribute("loggedInUser");
        if (!"driver".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "Chỉ tài xế mới được bắt đầu chuyến đi.");
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

            // Kiểm tra chuyến đi có phải PRE_BOOK không
            Trip trip = tripDAO.getTripById(tripId);
            if (trip == null || !"PRE_BOOK".equals(trip.getTripType())) {
                result.put("success", false);
                result.put("message", "Chuyến đi không hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kiểm tra tài xế có đang có chuyến IN_PROGRESS nào không
            if (tripDAO.getInProgressTripForDriver(user.getId()) != null) {
                result.put("success", false);
                result.put("message", "Bạn đang có một chuyến đi chưa hoàn thành. Hãy hoàn thành chuyến hiện tại trước.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Bắt đầu chuyến: chuyển NOT_STARTED -> IN_PROGRESS
            boolean success = tripDAO.startTripByDriver(tripId, user.getId());

            if (success) {
                org.example.websocket.TripWebSocketEndpoint.sendMessageToUser("passenger", (long) trip.getPassengerId(), "TRIP_STARTED", null);
                
                // Gửi email cho hành khách (bất đồng bộ)
                org.example.dao.UserDAO userDAO = new org.example.dao.UserDAO();
                org.example.model.User passenger = userDAO.getUserById(trip.getPassengerId());
                if (passenger != null) {
                    org.example.service.EmailService.sendTripStartedAsync(passenger, trip);
                }
                
                result.put("success", true);
                result.put("message", "Đã bắt đầu chuyến đi!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể bắt đầu chuyến đi. Chuyến có thể đã bị hủy.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
