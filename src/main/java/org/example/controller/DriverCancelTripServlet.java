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
                    org.example.websocket.TripWebSocketEndpoint.sendMessageToUser("passenger", (long) tripInfo.getPassengerId(), "TRIP_CANCELLED_BY_DRIVER", null);
                    // Có thể broadcast cho các tài xế khác nếu chuyến này chuyển về trạng thái tìm kiếm (tùy logic backend hiện tại, nhưng hiện tại ta có thể broadcast để refresh map)
                    org.example.websocket.TripWebSocketEndpoint.broadcastToAllDrivers("TRIP_CANCELLED", null);
                }
                result.put("success", true);
                result.put("message", "Hủy chuyến đi thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể hủy chuyến đi này. Chuyến đi không tồn tại hoặc bạn không phải là tài xế của chuyến đi.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
