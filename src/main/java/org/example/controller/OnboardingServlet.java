package org.example.controller;

import com.google.gson.Gson;
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
import java.util.List;
import java.util.Map;

@WebServlet("/api/onboarding")
public class OnboardingServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập trước khi cập nhật hồ sơ.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");

        try {
            // Đọc dữ liệu JSON
            Map<String, Object> body = gson.fromJson(request.getReader(), Map.class);
            if (body == null) {
                result.put("success", false);
                result.put("message", "Thiếu dữ liệu onboarding.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Lấy thông tin
            String fullName = (String) body.get("fullName");
            String gender = (String) body.get("gender");
            String role = (String) body.get("role");
            List<String> tags = (List<String>) body.get("tags");

            if (fullName == null || fullName.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập họ và tên.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (tags == null || tags.size() < 4) {
                result.put("success", false);
                result.put("message", "Vui lòng chọn ít nhất 4 sở thích.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kết hợp List tags thành chuỗi cách nhau bởi dấu phẩy
            String joinedHobbies = String.join(", ", tags);

            // Lưu dữ liệu vào CSDL
            boolean isProfileUpdated = userDAO.updateOnboardingProfile(loggedInUser.getId(), fullName, gender, role, joinedHobbies);

            if (isProfileUpdated) {
                // Cập nhật lại session
                loggedInUser.setFullName(fullName);
                loggedInUser.setGender(gender);
                loggedInUser.setRole(role);
                loggedInUser.setHobbies(joinedHobbies);
                session.setAttribute("loggedInUser", loggedInUser);

                result.put("success", true);
                result.put("message", "Cập nhật hồ sơ thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Lỗi server khi lưu thông tin.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
