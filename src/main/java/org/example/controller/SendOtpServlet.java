package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.OtpDAO;
import org.example.model.OtpCode;
import org.example.service.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@WebServlet("/api/send-otp")
public class SendOtpServlet extends HttpServlet {
    private OtpDAO otpDAO = new OtpDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            // Đọc JSON body
            Map<String, String> body = gson.fromJson(request.getReader(), Map.class);
            String phoneNumber = body != null ? body.get("phoneNumber") : null;
            String email = body != null ? body.get("email") : null;

            if (phoneNumber == null || !phoneNumber.matches("^(0[3|5|7|8|9])+([0-9]{8})$")) {
                result.put("success", false);
                result.put("message", "Số điện thoại không hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                result.put("success", false);
                result.put("message", "Email không hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Sinh mã OTP 6 số
            String otpCode = String.format("%06d", new Random().nextInt(999999));
            
            // Hạn sử dụng 5 phút
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (5 * 60 * 1000));
            
            // Xóa các OTP cũ của email này
            otpDAO.deleteOtpsByEmail(email);
            
            OtpCode otp = new OtpCode(phoneNumber, email, otpCode, expiresAt);
            if (otpDAO.saveOtp(otp)) {
                // Gửi OTP qua Email
                boolean emailSent = EmailService.sendOtpEmail(email, otpCode);

                if (emailSent) {
                    result.put("success", true);
                    result.put("message", "Mã OTP đã được gửi đến email của bạn.");
                } else {
                    result.put("success", false);
                    result.put("message", "Lỗi gửi email. Vui lòng thử lại sau.");
                }
            } else {
                result.put("success", false);
                result.put("message", "Lỗi khi lưu OTP vào hệ thống.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server.");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
}
