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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - OTP Verification Code");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #0f172a; font-size: 24px;\">TransCake Account Verification</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Hello,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Thank you for choosing <strong>TransCake</strong>! To complete your request, please use the 6-digit OTP code below:</p>"
                    + "            <div style=\"text-align: center; margin: 30px 0;\">"
                    + "                <span style=\"display: inline-block; font-size: 36px; font-weight: bold; color: #6200EE; letter-spacing: 10px; background-color: #f3e8ff; padding: 15px 30px; border-radius: 12px; border: 2px dashed #c084fc;\">" + otpCode + "</span>"
                    + "            </div>"
                    + "            <p style=\"font-size: 14px; color: #64748b; line-height: 1.6; text-align: center;\">This verification code is valid for <strong>5 minutes</strong>.<br>For security reasons, please do not share this code with anyone.</p>"
                    + "        </div>"
                    + "        <div style=\"background-color: #f8fafc; padding: 20px; text-align: center; border-top: 1px solid #f1f5f9;\">"
                    + "            <p style=\"margin: 0; font-size: 13px; color: #94a3b8;\">© 2026 TransCake. The #1 ride-sharing platform.</p>"
                    + "            <p style=\"margin: 5px 0 0; font-size: 13px; color: #94a3b8;\">If you didn't request this code, please ignore this email.</p>"
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("TransCake - Your New Temporary Password");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #0f172a; font-size: 24px;\">TransCake Password Recovery</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Hello,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">We received a request to reset your password for your <strong>TransCake</strong> account. Below is your temporary password:</p>"
                    + "            <div style=\"text-align: center; margin: 30px 0;\">"
                    + "                <span style=\"display: inline-block; font-size: 32px; font-weight: bold; color: #FF6B00; letter-spacing: 4px; background-color: #fff7ed; padding: 15px 30px; border-radius: 12px; border: 2px dashed #fdba74;\">" + newPassword + "</span>"
                    + "            </div>"
                    + "            <p style=\"font-size: 14px; color: #64748b; line-height: 1.6; text-align: center;\">Please use the password above to log in.<br>You will be required to <strong>set a new password</strong> immediately after a successful login.</p>"
                    + "        </div>"
                    + "        <div style=\"background-color: #f8fafc; padding: 20px; text-align: center; border-top: 1px solid #f1f5f9;\">"
                    + "            <p style=\"margin: 0; font-size: 13px; color: #94a3b8;\">© 2026 TransCake. The #1 ride-sharing platform.</p>"
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
            message.setSubject("TransCake - Partner Application Update Required");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #dc2626; font-size: 24px;\">Action Required: Update Your Application</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Hello <strong>" + driverName + "</strong>,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Thank you for applying to become a TransCake Partner.</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Unfortunately, your application and verification images did not meet our requirements or the information provided did not match. Your current application has been temporarily rejected.</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6; font-weight: bold;\">Please log in to the system, navigate to the Driver tab, and resubmit the Partner Registration form with clear and accurate images.</p>"
                    + "            <p style=\"font-size: 14px; color: #64748b; margin-top: 30px; border-top: 1px solid #e2e8f0; padding-top: 20px;\">If you need further assistance, please reply to this email.</p>"
                    + "            <p style=\"margin-bottom: 0; font-size: 14px; font-weight: bold;\">Best regards,<br>The TransCake Team</p>"
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
            message.setSubject("TransCake - Congratulations! Partner Application Approved");
            
            String htmlContent = "<div style=\"font-family: Arial, sans-serif; background-color: #f8fafc; padding: 40px 20px; color: #334155;\">"
                    + "    <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);\">"
                    + "        <div style=\"text-align: center; padding: 30px 20px; background-color: #ffffff; border-bottom: 1px solid #f1f5f9;\">"
                    + "            <h2 style=\"margin: 0; color: #16a34a; font-size: 24px;\">Application Approved</h2>"
                    + "        </div>"
                    + "        <div style=\"padding: 40px 30px;\">"
                    + "            <p style=\"margin-top: 0; font-size: 16px; line-height: 1.6;\">Hello <strong>" + driverName + "</strong>,</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">Congratulations! Your application to become a Partner (Driver) has been successfully verified.</p>"
                    + "            <p style=\"font-size: 16px; line-height: 1.6;\">You can now access the features to post trips, accept rides, and begin your journey with TransCake.</p>"
                    + "            <p style=\"font-size: 14px; color: #64748b; margin-top: 30px; border-top: 1px solid #e2e8f0; padding-top: 20px;\">Thank you for trusting and joining our platform.</p>"
                    + "            <p style=\"margin-bottom: 0; font-size: 14px; font-weight: bold;\">Best regards,<br>The TransCake Team</p>"
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
