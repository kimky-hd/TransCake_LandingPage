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

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, String> body = gson.fromJson(request.getReader(), Map.class);
            String phoneNumber = body.get("phoneNumber");
            String password = body.get("password");

            if (phoneNumber == null || password == null) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập đủ số điện thoại và mật khẩu.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Tìm user
            User user = userDAO.findByPhoneNumber(phoneNumber);
            if (user == null || !BCrypt.checkpw(password, user.getPasswordHash())) {
                result.put("success", false);
                result.put("message", "Số điện thoại hoặc mật khẩu không chính xác.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            result.put("success", true);
            String displayUser = (user.getFullName() != null && !user.getFullName().trim().isEmpty()) ? user.getFullName() : "Người dùng mới";
            result.put("userName", displayUser);
            
            if (user.getRole() == null || user.getRole().trim().isEmpty()) {
                result.put("needsOnboarding", true);
                result.put("message", "Đăng nhập thành công! Vui lòng hoàn tất hồ sơ.");
            } else {
                result.put("message", "Đăng nhập thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server.");
        }

        response.getWriter().write(gson.toJson(result));
    }
}
