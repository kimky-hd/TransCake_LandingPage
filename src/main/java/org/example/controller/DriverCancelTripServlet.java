package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.TripDAO;
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

@WebServlet("/api/driver/cancel-trip")
public class DriverCancelTripServlet extends HttpServlet {
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
        if (!"driver".equals(loggedInUser.getRole())) {
            result.put("success", false);
            result.put("message", "Chỉ tài xế mới có quyền hủy chuyến đi.");
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
            String cancelReason = body.containsKey("cancelReason") ? (String) body.get("cancelReason") : "Không có lý do cụ thể";

            boolean success = tripDAO.cancelTripByDriver(tripId, loggedInUser.getId(), cancelReason);
            
            if (success) {
                org.example.model.Trip tripInfo = tripDAO.getTripById(tripId);
                if (tripInfo != null) {
                    // Chuyến đi đã quay về PENDING → thông báo hành khách để UI reset về "Đang tìm tài xế"
                    org.example.websocket.TripWebSocketEndpoint.sendMessageToUser("passenger", (long) tripInfo.getPassengerId(), "TRIP_DRIVER_RELEASED", null);
                    // Broadcast cho tất cả tài xế để cập nhật danh sách đề xuất (chuyến đi vừa trống)
                    org.example.websocket.TripWebSocketEndpoint.broadcastToAllDrivers("NEW_TRIP_PROPOSAL", null);
                    
                    // Gửi email báo cho hành khách (bất đồng bộ)
                    org.example.dao.UserDAO userDAO = new org.example.dao.UserDAO();
                    org.example.model.User passenger = userDAO.getUserById(tripInfo.getPassengerId());
                    if (passenger != null) {
                        org.example.service.EmailService.sendTripCancelledAsync(passenger.getEmail(), passenger.getFullName(), loggedInUser.getFullName(), tripInfo);
                    }
                }
                result.put("success", true);
                result.put("message", "Hủy chuyến đi thành công! Chuyến đi sẽ được chuyển cho tài xế khác.");
            } else {
                result.put("success", false);
                result.put("message", "Không thể hủy chuyến đi. Chuyến đi đã bắt đầu hoặc bạn không phải là tài xế của chuyến này.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
