package org.example.service;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import java.io.File;

import java.util.Properties;

public class EmailService {

    // Default configuration (the user will provide the real email later)
    private static final String SENDER_EMAIL = System.getenv("SMTP_EMAIL") != null ? System.getenv("SMTP_EMAIL") : "transcake.contact@gmail.com";
    private static final String SENDER_PASSWORD = System.getenv("SMTP_PASSWORD") != null ? System.getenv("SMTP_PASSWORD") : "ekoqckbbzzqhcsai";

    public static boolean sendOtpEmail(String recipientEmail, String otpCode) {

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Mã OTP Xác Minh");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #0f172a; font-size: 24px;\">Xác Thực Tài Khoản TransCake</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Xin chào,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Cảm ơn bạn đã lựa chọn <strong>TransCake</strong>! Để hoàn tất, vui lòng sử dụng mã OTP gồm 6 chữ số dưới đây:</p>"
                    + "            <div style=\"text-align: center; margin: 30px 0;\">"
                    + "                <span style=\"display: inline-block; font-size: 36px; font-weight: bold; color: #6200EE; letter-spacing: 10px; background-color: #f3e8ff; padding: 15px 30px; border-radius: 12px; border: 2px dashed #c084fc;\">" + otpCode + "</span>"
                    + "            </div>"
                    + "            <p style=\"font-size: 14px; color: #64748b; line-height: 1.6; text-align: center;\">Mã xác thực này có hiệu lực trong vòng <strong>5 phút</strong>.<br>Vì lý do bảo mật, vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "        </div>"
                    + "        <div style=\"background-color: #f8fafc; padding: 20px; text-align: center; border-top: 1px solid #f1f5f9;\">"
                    + "            <p style=\"margin: 0; font-size: 13px; color: #94a3b8;\">© 2026 TransCake. Nền tảng kết nối chuyến đi số 1.</p>"
                    + "            <p style=\"margin: 5px 0 0; font-size: 13px; color: #94a3b8;\">Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email.</p>"
                    + "        </div>"
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean sendForgotPasswordEmail(String recipientEmail, String newPassword) {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Mat Khau Tam Thoi Moi");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #0f172a; font-size: 24px;\">Khôi Phục Mật Khẩu TransCake</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Xin chào,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Chúng tôi đã nhận được yêu cầu cấp lại mật khẩu cho tài khoản của bạn tại <strong>TransCake</strong>. Dưới đây là mật khẩu tạm thời của bạn:</p>"
                    + "            <div style=\"text-align: center; margin: 30px 0;\">"
                    + "                <span style=\"display: inline-block; font-size: 32px; font-weight: bold; color: #FF6B00; letter-spacing: 4px; background-color: #fff7ed; padding: 15px 30px; border-radius: 12px; border: 2px dashed #fdba74;\">" + newPassword + "</span>"
                    + "            </div>"
                    + "            <p style=\"font-size: 14px; color: #64748b; line-height: 1.6; text-align: center;\">Vui lòng sử dụng mật khẩu trên để đăng nhập.<br>Bạn sẽ được yêu cầu <strong>thiết lập mật khẩu mới</strong> ngay sau khi đăng nhập thành công.</p>"
                    + "        </div>"
                    + "        <div style=\"background-color: #f8fafc; padding: 20px; text-align: center; border-top: 1px solid #f1f5f9;\">"
                    + "            <p style=\"margin: 0; font-size: 13px; color: #94a3b8;\">© 2026 TransCake. Nền tảng kết nối chuyến đi số 1.</p>"
                    + "        </div>"
                    + "    </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
