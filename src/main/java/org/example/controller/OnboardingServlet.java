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

        // Kiểm tra đăng nhập hoặc đăng ký tạm thời
        HttpSession session = request.getSession(false);
        if (session == null) {
            result.put("success", false);
            result.put("message", "Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String pendingPhone = (String) session.getAttribute("pendingUserPhone");
        String pendingPass = (String) session.getAttribute("pendingUserPass");

        if (loggedInUser == null && (pendingPhone == null || pendingPass == null)) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập hoặc đăng ký trước khi thực hiện.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

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
            boolean isSuccess = false;

            if (pendingPhone != null && pendingPass != null) {
                // Luồng Đăng ký mới
                isSuccess = userDAO.createUserWithOnboarding(pendingPhone, pendingPass, fullName, gender, role, joinedHobbies);
                if (isSuccess) {
                    User createdUser = userDAO.findByPhoneNumber(pendingPhone);
                    session.setAttribute("loggedInUser", createdUser);
                    session.removeAttribute("pendingUserPhone");
                    session.removeAttribute("pendingUserPass");
                }
            } else if (loggedInUser != null) {
                // Luồng đã Đăng nhập
                isSuccess = userDAO.updateOnboardingProfile(loggedInUser.getId(), fullName, gender, role, joinedHobbies);
                if (isSuccess) {
                    loggedInUser.setFullName(fullName);
                    loggedInUser.setGender(gender);
                    loggedInUser.setRole(role);
                    loggedInUser.setHobbies(joinedHobbies);
                    session.setAttribute("loggedInUser", loggedInUser);
                }
            }

            if (isSuccess) {
                result.put("success", true);
                result.put("message", "Hoàn tất hồ sơ thành công!");
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
