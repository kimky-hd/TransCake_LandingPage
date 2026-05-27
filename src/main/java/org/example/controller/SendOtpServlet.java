package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.OtpDAO;
import org.example.model.OtpCode;

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

            if (phoneNumber == null || !phoneNumber.matches("^(0[3|5|7|8|9])+([0-9]{8})$")) {
                result.put("success", false);
                result.put("message", "Số điện thoại không hợp lệ.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Sinh mã OTP 6 số
            String otpCode = String.format("%06d", new Random().nextInt(999999));
            
            // Hạn sử dụng 5 phút
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (5 * 60 * 1000));
            
            // Xóa các OTP cũ của số điện thoại này
            otpDAO.deleteOtpsByPhone(phoneNumber);

            OtpCode otp = new OtpCode(phoneNumber, otpCode, expiresAt);
            if (otpDAO.saveOtp(otp)) {
                // In ra màn hình console của IDE theo yêu cầu
                System.out.println("==================================================");
                System.out.println("OTP of number " + phoneNumber + " is: " + otpCode);
                System.out.println("==================================================");

                result.put("success", true);
                result.put("message", "Mã OTP đã được gửi thành công.");
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
