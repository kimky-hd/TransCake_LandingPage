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

    // --- 7. Mời đi chơi (Timeline bí mật) ---
    public static void sendTimelineEmail(String recipientEmail) {
        String subject = "Điều bí mật dành riêng cho Khánh ✨💌";
        String htmlContent = "<div style=\"font-family: 'Arial', sans-serif; background-color: #FFF5F7; padding: 30px; text-align: center;\">"
                + "    <div style=\"max-width: 600px; margin: 0 auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(210, 94, 120, 0.15); border: 1px solid #FFC2D1;\">"
                + "        <div style=\"background: linear-gradient(135deg, #FF9A9E 0%, #FECFEF 100%); padding: 30px; color: #D25E78;\">"
                + "            <h1 style=\"margin: 0; font-size: 28px;\">Hẹn hò sinh nhật nha! 🎂</h1>"
                + "        </div>"
                + "        <div style=\"padding: 30px; color: #5A4A4A; line-height: 1.8; text-align: left;\">"
                + "            <p style=\"font-size: 16px;\">Chào em,</p>"
                + "            <p style=\"font-size: 16px;\">Anh rất vui vì em đã đồng ý tham gia hành trình nhỏ này. Đây là timeline bí mật của chúng mình nhé:</p>"
                + "            "
                + "            <div style=\"background: #FFF0F3; border-radius: 12px; padding: 20px; margin: 25px 0; border-left: 5px solid #FF9A9E;\">"
                + "                <h3 style=\"color: #D25E78; margin-top: 0;\">🗓 Ngày 09/07/2026</h3>"
                + "                <ul style=\"list-style-type: none; padding-left: 0; margin-bottom: 0;\">"
                + "                    <li style=\"margin-bottom: 10px;\"><strong>07:30</strong> - Anh qua đón em nha 🛵</li>"
                + "                    <li style=\"margin-bottom: 10px;\"><strong>08:00</strong> - Bí mật 1: Thưởng thức một chút buổi sáng thanh bình ☕️</li>"
                + "                    <li style=\"margin-bottom: 10px;\"><strong>09:30</strong> - Bí mật 2: Trải nghiệm nho nhỏ cùng nhau 🎨</li>"
                + "                    <li style=\"margin-bottom: 0;\"><strong>11:30</strong> - Bí mật 3: Món quà bất ngờ nhất 🎁</li>"
                + "                </ul>"
                + "            </div>"
                + "            "
                + "            <p style=\"font-size: 16px;\"><strong>👗 Dresscode nhỏ xinh:</strong> Em hãy chọn một bộ váy/áo màu <strong>trắng</strong> hoặc <strong>hồng nhạt</strong> thật xinh xắn nha (bất cứ bộ nào em thấy thoải mái nhất).</p>"
                + "            <p style=\"font-size: 16px;\">Hẹn gặp em vào ngày hôm đó! ❤️</p>"
                + "        </div>"
                + "    </div>"
                + "</div>";
        sendEmailInBackground(recipientEmail, subject, htmlContent);
    }

    // --- 8. Timeline bí mật (Dùng tài khoản cá nhân) ---
    public static void sendRomanticTimelineEmail(String recipientEmail) {
        String senderEmail = "kimkyvu2004hd@gmail.com";
        String senderPassword = "kceiudgtvydghfud";
        
        String subject = "Điều bí mật dành riêng cho em ✨💌";
        
        String htmlContent = "<div style=\"font-family: 'Quicksand', 'Arial', sans-serif; background-color: #FFF5F7; padding: 20px; text-align: center;\">"
            + "    <div style=\"max-width: 600px; margin: 0 auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(255, 154, 158, 0.2); border: 2px solid #FFE5EC;\">"
            + "        "
            + "        <!-- Header lãng mạn -->"
            + "        <div style=\"background: linear-gradient(135deg, #FF9A9E 0%, #FECFEF 100%); padding: 35px 20px; color: #D25E78;\">"
            + "            <h1 style=\"margin: 0; font-size: 32px; font-weight: bold;\">Chào Khánh nè, 🥰</h1>"
            + "        </div>"
            + "        "
            + "        <!-- Nội dung thư -->"
            + "        <div style=\"padding: 30px; color: #5A4A4A; line-height: 1.8; text-align: left;\">"
            + "            <p style=\"font-size: 17px; margin-top: 0;\">Anh đã nhận được tín hiệu đồng ý từ em rồi nha! Cảm ơn em vì đã gật đầu tham gia hành trình nhỏ này cùng anh.</p>"
            + "            <p style=\"font-size: 17px;\">Để em có thể chuẩn bị thật thư giãn và thoải mái nhất, anh gửi em timeline chi tiết cho buổi tối hôm đó của chúng mình nhé:</p>"
            + "            "
            + "            <!-- Timeline Box -->"
            + "            <div style=\"background: #FFF0F3; border-radius: 15px; padding: 25px; margin: 30px 0; border-left: 6px solid #FF9A9E;\">"
            + "                <ul style=\"list-style-type: none; padding-left: 0; margin: 0;\">"
            + "                    <li style=\"margin-bottom: 20px; font-size: 16px;\">"
            + "                        <strong style=\"color: #D25E78; font-size: 18px;\">⏰ 18:45 - Bắt đầu hành trình:</strong><br>"
            + "                        Anh sẽ có mặt trước cửa để đón em nha."
            + "                    </li>"
            + "                    <li style=\"margin-bottom: 20px; font-size: 16px;\">"
            + "                        <strong style=\"color: #D25E78; font-size: 18px;\">🍲 19:00 đến 20:15 - Nạp năng lượng:</strong><br>"
            + "                        Mình sẽ cùng nhau ghé Manwah Hà Đông ăn tối. Anh nhớ dạ dày em dạo này hơi yếu, nên anh đã dặn nhà hàng chuẩn bị sẵn combo thanh đạm, không cay nóng cho em rồi. Mình cứ thong thả thưởng thức nhé."
            + "                    </li>"
            + "                    <li style=\"margin-bottom: 20px; font-size: 16px;\">"
            + "                        <strong style=\"color: #D25E78; font-size: 18px;\">🎯 20:30 đến 21:45 - Chút vận động nhẹ nhàng:</strong><br>"
            + "                        Ăn no rồi thì mình sẽ cùng di chuyển lên khu vực Hoàng Cầu để tham gia một trò chơi nhỏ. Trò này sẽ cần chạy nhảy một chút xíu đó nha!"
            + "                    </li>"
            + "                    <li style=\"margin-bottom: 0; font-size: 16px;\">"
            + "                        <strong style=\"color: #D25E78; font-size: 18px;\">🎁 22:00 trở đi - Trạm dừng chân bí mật:</strong><br>"
            + "                        Đến lúc này sẽ là một địa điểm hoàn toàn bí mật. Chịu khó đợi đến lúc đó anh sẽ bật mí cho em nhé!"
            + "                    </li>"
            + "                </ul>"
            + "            </div>"
            + "            "
            + "            <!-- Dresscode Note -->"
            + "            <div style=\"background: #fdf2f8; border: 1px dashed #FFB7B2; border-radius: 15px; padding: 20px; margin-bottom: 25px;\">"
            + "                <h3 style=\"color: #D25E78; margin-top: 0; margin-bottom: 10px;\">👗 Một chút lưu ý về Dresscode cho em:</h3>"
            + "                <p style=\"margin: 0; font-size: 16px;\">Vì sau khi ăn xong mình sẽ chơi trò chơi có chút vận động, nên em cứ ưu tiên chọn những bộ đồ xinh xắn nhưng phải thật thoải mái, dễ di chuyển và nhớ mang một đôi giày thật êm chân nha.</p>"
            + "            </div>"
            + "            "
            + "            <p style=\"font-size: 17px; margin-bottom: 0;\">Anh rất mong chờ đến buổi đi chơi này. Hẹn gặp em sớm nhé! ❤️</p>"
            + "        </div>"
            + "    </div>"
            + "</div>";

        System.out.println("[EmailService] Sending romantic timeline from " + senderEmail + " to " + recipientEmail);
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
                        return new PasswordAuthentication(senderEmail, senderPassword);
                    }
                });

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(senderEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                message.setSubject(subject, "UTF-8");
                message.setContent(htmlContent, "text/html; charset=utf-8");
                
                Transport.send(message);
                System.out.println("[EmailService] SUCCESS: Romantic email sent to " + recipientEmail);
            } catch (Exception e) {
                System.err.println("[EmailService] FAILED: Could not send romantic email to " + recipientEmail);
                e.printStackTrace();
            }
        });
    }
}
