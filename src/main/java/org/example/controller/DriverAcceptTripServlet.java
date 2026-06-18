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

@WebServlet("/api/driver/accept-trip")
public class DriverAcceptTripServlet extends HttpServlet {
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
            result.put("message", "Chỉ tài xế mới được nhận chuyến đi.");
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

            // Kiểm tra loại chuyến đi để xử lý khác nhau
            org.example.model.Trip tripInfo = tripDAO.getTripById(tripId);
            if (tripInfo == null) {
                result.put("success", false);
                result.put("message", "Chuyến đi không tồn tại.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            boolean success;
            if ("PRE_BOOK".equals(tripInfo.getTripType())) {
                // Kiểm tra tài xế đã nhận 1 chuyến PRE_BOOK chưa
                if (tripDAO.getActivePreBookTripForDriver(loggedInUser.getId()) != null) {
                    result.put("success", false);
                    result.put("message", "Bạn đã nhận một chuyến hẹn trước. Bạn không thể nhận thêm chuyến hẹn trước nào khác.");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                // PRE_BOOK: Cho phép nhận mà KHÔNG khóa tài xế, giữ NOT_STARTED
                success = tripDAO.acceptPreBookTrip(tripId, loggedInUser.getId());
                if (success) {
                    result.put("success", true);
                    result.put("message", "Đã nhận chuyến đặt trước! Xem trong mục Lịch trình sắp tới.");
                } else {
                    result.put("success", false);
                    result.put("message", "Không thể nhận chuyến. Chuyến đã bị hủy hoặc đã có người khác nhận.");
                }
            } else {
                // ON_DEMAND: Kiểm tra tài xế có đang chạy chuyến ON_DEMAND nào không
                if (tripDAO.getActiveOnDemandTripForDriver(loggedInUser.getId()) != null) {
                    result.put("success", false);
                    result.put("message", "Bạn đang có một chuyến đi đặt ngay chưa hoàn thành. Không thể nhận thêm chuyến mới.");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                success = tripDAO.acceptTrip(tripId, loggedInUser.getId());
                if (success) {
                    result.put("success", true);
                    result.put("message", "Nhận chuyến thành công!");
                } else {
                    result.put("success", false);
                    result.put("message", "Không thể nhận chuyến đi này. Có thể chuyến đi đã bị hủy hoặc đã có người khác nhận.");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
