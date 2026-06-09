package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.UserDAO;
import org.example.model.User;
import org.example.service.EmailService;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    private static final SecureRandom RANDOM = new SecureRandom();

    private String generateRandomPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, String> body = gson.fromJson(request.getReader(), Map.class);
            String email = body != null ? body.get("email") : null;

            if (email == null || email.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập email hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            User user = userDAO.findByEmail(email);
            if (user == null) {
                result.put("success", false);
                result.put("message", "Email không tồn tại trong hệ thống.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Generate new random password
            String randomPassword = generateRandomPassword(8);
            String hashedPwd = BCrypt.hashpw(randomPassword, BCrypt.gensalt(12));

            // Update DB with new password and status = REQUIRE_RESET
            boolean updated = userDAO.updatePasswordAndStatus(user.getId(), hashedPwd, "REQUIRE_RESET");

            if (updated) {
                boolean emailSent = EmailService.sendForgotPasswordEmail(email, randomPassword);
                if (emailSent) {
                    result.put("success", true);
                    result.put("message", "Mật khẩu mới đã được gửi vào email của bạn.");
                } else {
                    // Cố gắng khôi phục nếu gửi email thất bại (thực tế nên dùng transaction, nhưng ở đây rollback manual)
                    userDAO.updatePasswordAndStatus(user.getId(), user.getPasswordHash(), user.getStatus());
                    result.put("success", false);
                    result.put("message", "Lỗi khi gửi email. Vui lòng thử lại sau.");
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
