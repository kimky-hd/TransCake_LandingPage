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
import java.util.concurrent.CompletableFuture;

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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Mã xác thực OTP", "UTF-8");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                    + "    <h2 style=\"color: #6200EE; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Mã xác thực tài khoản</h2>"
                    + "    <p>Xin chào,</p>"
                    + "    <p>Cảm ơn bạn đã sử dụng <strong>TransCake</strong>! Dưới đây là mã OTP 6 số để hoàn tất yêu cầu của bạn:</p>"
                    + "    <div style=\"text-align: center; margin: 20px 0;\">"
                    + "        <span style=\"display: inline-block; font-size: 32px; font-weight: bold; color: #6200EE; letter-spacing: 5px; background-color: #f3e8ff; padding: 10px 20px; border-radius: 8px;\">" + otpCode + "</span>"
                    + "    </div>"
                    + "    <p style=\"font-size: 14px;\">Mã xác thực này có hiệu lực trong vòng <strong>5 phút</strong>. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Mật khẩu tạm thời", "UTF-8");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                    + "    <h2 style=\"color: #6200EE; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Khôi phục mật khẩu</h2>"
                    + "    <p>Xin chào,</p>"
                    + "    <p>Chúng tôi đã nhận được yêu cầu khôi phục mật khẩu cho tài khoản <strong>TransCake</strong> của bạn. Đây là mật khẩu tạm thời của bạn:</p>"
                    + "    <div style=\"text-align: center; margin: 20px 0;\">"
                    + "        <span style=\"display: inline-block; font-size: 24px; font-weight: bold; color: #FF6B00; background-color: #fff7ed; padding: 10px 20px; border-radius: 8px;\">" + newPassword + "</span>"
                    + "    </div>"
                    + "    <p style=\"font-size: 14px;\">Vui lòng sử dụng mật khẩu trên để đăng nhập và <strong>đổi mật khẩu mới</strong> ngay lập tức.</p>"
                    + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean sendDriverRejectionEmail(String recipientEmail, String driverName) {
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Cập nhật hồ sơ đối tác", "UTF-8");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                    + "    <h2 style=\"color: #dc2626; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Yêu cầu cập nhật hồ sơ</h2>"
                    + "    <p>Xin chào <strong>" + driverName + "</strong>,</p>"
                    + "    <p>Cảm ơn bạn đã đăng ký trở thành Đối tác của TransCake.</p>"
                    + "    <p>Rất tiếc, hồ sơ của bạn chưa đáp ứng đủ yêu cầu hoặc thông tin chưa trùng khớp. Hồ sơ hiện tại đã bị từ chối tạm thời.</p>"
                    + "    <p>Vui lòng đăng nhập vào hệ thống, vào mục Tài xế và gửi lại biểu mẫu đăng ký với hình ảnh rõ nét và thông tin chính xác.</p>"
                    + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendDriverApprovalEmail(String recipientEmail, String driverName) {
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Chúc mừng! Hồ sơ đối tác đã được duyệt", "UTF-8");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                    + "    <h2 style=\"color: #16a34a; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Hồ sơ đã được phê duyệt</h2>"
                    + "    <p>Xin chào <strong>" + driverName + "</strong>,</p>"
                    + "    <p>Chúc mừng! Hồ sơ đăng ký trở thành Đối tác (Tài xế) của bạn đã được xác minh thành công.</p>"
                    + "    <p>Bây giờ bạn đã có thể truy cập các tính năng nhận chuyến và bắt đầu hành trình cùng TransCake.</p>"
                    + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- ASYNC EMAIL METHODS FOR TRIP EVENTS ---

    private static final java.util.concurrent.ExecutorService EMAIL_EXECUTOR = 
        java.util.concurrent.Executors.newFixedThreadPool(2, r -> {
            Thread t = new Thread(r, "TransCake-EmailSender");
            t.setDaemon(false);
            return t;
        });


    private static String safe(String value) {
        return (value != null) ? value : "";
    }

    private static void sendEmailInBackground(String recipientEmail, String subject, String htmlContent) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("[EmailService] SKIPPED: recipientEmail is null or empty for subject: " + subject);
            return;
        }
        System.out.println("[EmailService] Queuing email to: " + recipientEmail + " | Subject: " + subject);
        EMAIL_EXECUTOR.submit(() -> {
            try {
                Properties properties = new Properties();
                properties.put("mail.smtp.auth", "true");
                properties.put("mail.smtp.starttls.enable", "true");
                properties.put("mail.smtp.host", "smtp.gmail.com");
                properties.put("mail.smtp.port", "587");
                properties.put("mail.smtp.connectiontimeout", "10000");
                properties.put("mail.smtp.timeout", "10000");
                properties.put("mail.smtp.writetimeout", "10000");

                Session session = Session.getInstance(properties, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                    }
                });

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SENDER_EMAIL));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                message.setSubject(subject, "UTF-8");
                message.setContent(htmlContent, "text/html; charset=utf-8");
                Transport.send(message);
                System.out.println("[EmailService] SUCCESS: Email sent to " + recipientEmail);
            } catch (Exception e) {
                System.err.println("[EmailService] FAILED: Could not send email to " + recipientEmail);
                e.printStackTrace();
            }
        });
    }

    // --- 1. Hành khách đặt chuyến ---
    public static void sendTripBookingConfirmationAsync(org.example.model.User passenger, org.example.model.Trip trip) {
        if (passenger == null || trip == null) return;
        String name = safe(passenger.getFullName());
        String pickup = safe(trip.getPickupLocation());
        String dropoff = safe(trip.getDropoffLocation());
        String type = "PRE_BOOK".equals(trip.getTripType()) ? "Đặt trước (Pre-book)" : "Đặt ngay (On Demand)";

        String subject = "TransCake - Xác nhận đặt chuyến thành công";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #6200EE; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Xác nhận đặt chuyến</h2>"
                + "    <p>Xin chào <strong>" + name + "</strong>,</p>"
                + "    <p>Yêu cầu đặt chuyến của bạn đã được tạo thành công. Chúng tôi đang tìm tài xế phù hợp cho bạn.</p>"
                + "    <div style=\"background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0;\">"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm đón:</strong> " + pickup + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm trả:</strong> " + dropoff + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>🚗 Loại chuyến:</strong> " + type + "</p>"
                + "    </div>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(passenger.getEmail(), subject, htmlContent);
    }

    // --- 2. Gửi cho tài xế khi có chuyến PRE_BOOK mới ---
    public static void sendNewTripAvailableAsync(org.example.model.User driver, org.example.model.Trip trip) {
        if (driver == null || trip == null) return;
        String name = safe(driver.getFullName());
        String pickup = safe(trip.getPickupLocation());
        String dropoff = safe(trip.getDropoffLocation());
        String scheduledTime = (trip.getScheduledTime() != null) ? trip.getScheduledTime().toString() : "Chưa xác định";

        String subject = "TransCake - Có chuyến đặt trước mới dành cho bạn!";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #FF6D00; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Chuyến đặt trước mới</h2>"
                + "    <p>Xin chào <strong>" + name + "</strong>,</p>"
                + "    <p>Có một chuyến đặt trước mới phù hợp với loại xe của bạn. Hãy mở ứng dụng để nhận chuyến!</p>"
                + "    <div style=\"background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0;\">"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm đón:</strong> " + pickup + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm trả:</strong> " + dropoff + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>🕐 Thời gian:</strong> " + scheduledTime + "</p>"
                + "    </div>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(driver.getEmail(), subject, htmlContent);
    }

    // --- 3. Hành khách nhận được tài xế ---
    public static void sendTripAcceptedAsync(org.example.model.User passenger, org.example.model.User driver, org.example.model.DriverVehicle vehicle, org.example.model.Trip trip) {
        if (passenger == null || driver == null) return;
        String vehicleInfo = (vehicle != null) ? safe(vehicle.getVehicleName()) + " - " + safe(vehicle.getLicensePlate()) : "N/A";
        
        String subject = "TransCake - Đã tìm thấy tài xế cho bạn!";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #10B981; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Đã tìm thấy tài xế</h2>"
                + "    <p>Xin chào <strong>" + safe(passenger.getFullName()) + "</strong>,</p>"
                + "    <p>Tin vui! Một tài xế đã nhận chuyến đi của bạn và đang chuẩn bị đón bạn.</p>"
                + "    <div style=\"background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0;\">"
                + "        <p style=\"margin: 5px 0;\"><strong>👤 Tài xế:</strong> " + safe(driver.getFullName()) + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>📞 Điện thoại:</strong> " + safe(driver.getPhoneNumber()) + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>🚗 Phương tiện:</strong> " + vehicleInfo + "</p>"
                + "    </div>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(passenger.getEmail(), subject, htmlContent);
    }

    // --- 4. Chuyến đi bắt đầu ---
    public static void sendTripStartedAsync(org.example.model.User passenger, org.example.model.Trip trip) {
        if (passenger == null) return;
        String subject = "TransCake - Chuyến đi của bạn đã bắt đầu!";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #3B82F6; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Chuyến đi bắt đầu</h2>"
                + "    <p>Xin chào <strong>" + safe(passenger.getFullName()) + "</strong>,</p>"
                + "    <p>Chuyến đi của bạn đã chính thức bắt đầu. Chúc bạn có một hành trình an toàn và thoải mái!</p>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(passenger.getEmail(), subject, htmlContent);
    }

    // --- 5. Hoàn thành chuyến - Biên lai ---
    public static void sendTripCompletedAsync(org.example.model.User passenger, org.example.model.Trip trip) {
        if (passenger == null || trip == null) return;
        String price = (trip.getPrice() != null) ? String.format("%,.0f VNĐ", trip.getPrice()) : "N/A";
        String distance = (trip.getDistance() != null) ? String.format("%.1f km", trip.getDistance()) : "N/A";
        
        String subject = "TransCake - Biên lai chuyến đi";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #10B981; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Biên lai chuyến đi</h2>"
                + "    <p>Xin chào <strong>" + safe(passenger.getFullName()) + "</strong>,</p>"
                + "    <p>Bạn đã đến nơi an toàn. Cảm ơn bạn đã sử dụng dịch vụ của TransCake!</p>"
                + "    <div style=\"background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0;\">"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm đón:</strong> " + safe(trip.getPickupLocation()) + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>📍 Điểm trả:</strong> " + safe(trip.getDropoffLocation()) + "</p>"
                + "        <p style=\"margin: 5px 0;\"><strong>📏 Khoảng cách:</strong> " + distance + "</p>"
                + "        <p style=\"margin: 10px 0 0;\"><strong>💰 Tổng cước:</strong> <span style=\"color:#EF4444; font-size:18px; font-weight:bold;\">" + price + "</span></p>"
                + "    </div>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(passenger.getEmail(), subject, htmlContent);
    }

    // --- 6. Hủy chuyến ---
    public static void sendTripCancelledAsync(String recipientEmail, String recipientName, String cancelledBy, org.example.model.Trip trip) {
        String subject = "TransCake - Chuyến đi đã bị hủy";
        String htmlContent = "<div style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;\">"
                + "    <h2 style=\"color: #EF4444; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-top: 0;\">Chuyến đi đã bị hủy</h2>"
                + "    <p>Xin chào <strong>" + safe(recipientName) + "</strong>,</p>"
                + "    <p>Rất tiếc, chuyến đi của bạn đã bị hủy bởi <strong>" + safe(cancelledBy) + "</strong>. Vui lòng đặt lại chuyến mới nếu cần.</p>"
                + "    <p style=\"font-size: 14px; color: #555; margin-top: 30px;\">Trân trọng,<br>Đội ngũ TransCake</p>"
                + "</div>";
        sendEmailInBackground(recipientEmail, subject, htmlContent);
    }
}
