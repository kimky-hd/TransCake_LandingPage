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

@WebServlet("/api/driver/start-trip")
public class DriverStartTripServlet extends HttpServlet {
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
            result.put("message", "Chỉ tài xế mới được thao tác.");
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

            // Kiểm tra tài xế có đang có chuyến IN_PROGRESS nào không
            if (tripDAO.getInProgressTripForDriver(loggedInUser.getId()) != null) {
                result.put("success", false);
                result.put("message", "Bạn đang có một chuyến đi chưa hoàn thành. Hãy hoàn thành chuyến hiện tại trước.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            boolean success = tripDAO.startTripByDriver(tripId, loggedInUser.getId());
            
            if (success) {
                org.example.model.Trip tripInfo = tripDAO.getTripById(tripId);
                if (tripInfo != null) {
                    org.example.websocket.TripWebSocketEndpoint.sendMessageToUser("passenger", (long) tripInfo.getPassengerId(), "TRIP_STARTED", null);
                }
                result.put("success", true);
                result.put("message", "Bắt đầu chuyến đi thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể bắt đầu chuyến đi này. Vui lòng kiểm tra lại trạng thái chuyến đi.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
