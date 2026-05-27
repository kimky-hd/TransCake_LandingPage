package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.OtpDAO;
import org.example.dao.UserDAO;
import org.example.model.OtpCode;
import org.example.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private OtpDAO otpDAO = new OtpDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, String> body = gson.fromJson(request.getReader(), Map.class);
            String phoneNumber = body.get("phoneNumber");
            String otpCode = body.get("otpCode");
            String password = body.get("password");

            // Validate cơ bản
            if (phoneNumber == null || !phoneNumber.matches("^(0[3|5|7|8|9])+([0-9]{8})$") ||
                otpCode == null || otpCode.length() != 6 ||
                password == null || password.length() < 6) {
                
                result.put("success", false);
                result.put("message", "Vui lòng nhập đầy đủ thông tin hợp lệ (Mật khẩu ít nhất 6 ký tự).");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kiểm tra số điện thoại đã tồn tại chưa
            if (userDAO.findByPhoneNumber(phoneNumber) != null) {
                result.put("success", false);
                result.put("message", "Số điện thoại này đã được đăng ký.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kiểm tra mã OTP
            OtpCode latestOtp = otpDAO.getLatestValidOtp(phoneNumber);
            if (latestOtp == null || !latestOtp.getOtpCode().equals(otpCode)) {
                result.put("success", false);
                result.put("message", "Mã OTP không chính xác hoặc đã hết hạn.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Mã hóa mật khẩu
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

            // Đánh dấu OTP đã sử dụng
            otpDAO.markOtpAsUsed(latestOtp.getId());
            
            // Lưu tạm thông tin vào Session (không tạo User ngay lập tức)
            request.getSession().setAttribute("pendingUserPhone", phoneNumber);
            request.getSession().setAttribute("pendingUserPass", hashedPassword);
            
            // Trả về cờ yêu cầu onboarding
            result.put("success", true);
            result.put("needsOnboarding", true);
            result.put("message", "Xác thực thành công! Vui lòng hoàn tất hồ sơ.");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server.");
        }

        response.getWriter().write(gson.toJson(result));
    }
}
