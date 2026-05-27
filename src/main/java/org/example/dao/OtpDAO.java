package org.example.dao;

import org.example.model.OtpCode;
import org.example.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OtpDAO {

    public boolean saveOtp(OtpCode otpCode) {
        String sql = "INSERT INTO otp_codes (phone_number, otp_code, expires_at, is_used) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, otpCode.getPhoneNumber());
            ps.setString(2, otpCode.getOtpCode());
            ps.setTimestamp(3, otpCode.getExpiresAt());
            ps.setBoolean(4, otpCode.isUsed());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOtpsByPhone(String phoneNumber) {
        String sql = "DELETE FROM otp_codes WHERE phone_number = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phoneNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public OtpCode getLatestValidOtp(String phoneNumber) {
        String sql = "SELECT * FROM otp_codes WHERE phone_number = ? AND is_used = FALSE AND expires_at > NOW() ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phoneNumber);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                OtpCode otp = new OtpCode();
                otp.setId(rs.getInt("id"));
                otp.setPhoneNumber(rs.getString("phone_number"));
                otp.setOtpCode(rs.getString("otp_code"));
                otp.setExpiresAt(rs.getTimestamp("expires_at"));
                otp.setUsed(rs.getBoolean("is_used"));
                otp.setCreatedAt(rs.getTimestamp("created_at"));
                return otp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean markOtpAsUsed(int otpId) {
        String sql = "UPDATE otp_codes SET is_used = TRUE WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, otpId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
