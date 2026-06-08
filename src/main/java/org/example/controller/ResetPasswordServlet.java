package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.UserDAO;
import org.example.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("loggedInUser") == null) {
                result.put("success", false);
                result.put("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            User user = (User) session.getAttribute("loggedInUser");

            Map<String, String> body = gson.fromJson(request.getReader(), Map.class);
            String newPassword = body != null ? body.get("newPassword") : null;
            String confirmPassword = body != null ? body.get("confirmPassword") : null;

            if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập đầy đủ mật khẩu mới.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                result.put("success", false);
                result.put("message", "Mật khẩu xác nhận không khớp.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Update DB with new password and status = ACTIVE
            String hashedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            boolean updated = userDAO.updatePasswordAndStatus(user.getId(), hashedPwd, "ACTIVE");
            
            if (updated) {
                // Update session user status
                user.setStatus("ACTIVE");
                session.setAttribute("loggedInUser", user);

                result.put("success", true);
                result.put("message", "Cập nhật mật khẩu thành công!");
                
                // Trả về luồng bình thường sau khi đổi pass (có thể cần onboarding)
                if (user.getRole() == null || user.getRole().trim().isEmpty()) {
                    result.put("needsOnboarding", true);
                }
            } else {
                result.put("success", false);
                result.put("message", "Lỗi server khi cập nhật mật khẩu.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server.");
        }

        response.getWriter().write(gson.toJson(result));
    }
}
