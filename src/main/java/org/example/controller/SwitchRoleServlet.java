package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.TripDAO;
import org.example.dao.UserDAO;
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

@WebServlet("/api/switch-role")
public class SwitchRoleServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
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
            result.put("message", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        try {
            Map<String, Object> body = gson.fromJson(request.getReader(), Map.class);
            if (body == null || !body.containsKey("newRole")) {
                result.put("success", false);
                result.put("message", "Dữ liệu không hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            String newRole = (String) body.get("newRole");
            String oldRole = loggedInUser.getRole();

            if (newRole.equals(oldRole)) {
                result.put("success", true);
                result.put("message", "Đã ở vai trò này.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Hủy toàn bộ chuyến xe ở vai trò cũ
            tripDAO.cancelAllTripsForUser(loggedInUser.getId(), oldRole);

            // Cập nhật vai trò mới vào database
            boolean updated = userDAO.updateRole(loggedInUser.getId(), newRole);

            if (updated) {
                // Cập nhật session
                loggedInUser.setRole(newRole);
                session.setAttribute("loggedInUser", loggedInUser);

                result.put("success", true);
                result.put("message", "Chuyển đổi vai trò thành công. Các chuyến xe cũ đã bị hủy.");
            } else {
                result.put("success", false);
                result.put("message", "Lỗi server khi cập nhật vai trò.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
