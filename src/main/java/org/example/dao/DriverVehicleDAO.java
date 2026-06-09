package org.example.dao;

import org.example.model.DriverVehicle;
import org.example.model.AdminDriverDTO;
import org.example.utils.DBContext;

import java.sql.Connection;
import java.util.List;
import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DriverVehicleDAO {

    public DriverVehicle getVehicleByUserId(int userId) {
        String sql = "SELECT * FROM driver_vehicles WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DriverVehicle vehicle = new DriverVehicle();
                    vehicle.setId(rs.getInt("id"));
                    vehicle.setUserId(rs.getInt("user_id"));
                    vehicle.setVehicleType(rs.getString("vehicle_type"));
                    vehicle.setVehicleName(rs.getString("vehicle_name"));
                    vehicle.setLicensePlate(rs.getString("license_plate"));
                    
                    vehicle.setIdCardNumber(rs.getString("id_card_number"));
                    vehicle.setIdCardFrontUrl(rs.getString("id_card_front_url"));
                    vehicle.setIdCardBackUrl(rs.getString("id_card_back_url"));
                    vehicle.setAvatarUrl(rs.getString("avatar_url"));
                    vehicle.setLicenseNumber(rs.getString("license_number"));
                    vehicle.setLicenseImageUrl(rs.getString("license_image_url"));
                    vehicle.setVehicleColor(rs.getString("vehicle_color"));
                    vehicle.setVehicleRegistrationUrl(rs.getString("vehicle_registration_url"));
                    vehicle.setVerificationStatus(rs.getString("verification_status"));
                    
                    vehicle.setCreatedAt(rs.getTimestamp("created_at"));
                    return vehicle;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerVehicle(DriverVehicle vehicle) {
        String sql = "INSERT INTO driver_vehicles (user_id, vehicle_type, vehicle_name, license_plate, id_card_number, id_card_front_url, id_card_back_url, avatar_url, license_number, license_image_url, vehicle_color, vehicle_registration_url, verification_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicle.getUserId());
            stmt.setString(2, vehicle.getVehicleType());
            stmt.setString(3, vehicle.getVehicleName());
            stmt.setString(4, vehicle.getLicensePlate());
            
            stmt.setString(5, vehicle.getIdCardNumber());
            stmt.setString(6, vehicle.getIdCardFrontUrl());
            stmt.setString(7, vehicle.getIdCardBackUrl());
            stmt.setString(8, vehicle.getAvatarUrl());
            stmt.setString(9, vehicle.getLicenseNumber());
            stmt.setString(10, vehicle.getLicenseImageUrl());
            stmt.setString(11, vehicle.getVehicleColor());
            stmt.setString(12, vehicle.getVehicleRegistrationUrl());
            stmt.setString(13, vehicle.getVerificationStatus() != null ? vehicle.getVerificationStatus() : "PENDING");
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateVehicle(DriverVehicle vehicle) {
        String sql = "UPDATE driver_vehicles SET vehicle_type = ?, vehicle_name = ?, license_plate = ?, id_card_number = ?, id_card_front_url = ?, id_card_back_url = ?, avatar_url = ?, license_number = ?, license_image_url = ?, vehicle_color = ?, vehicle_registration_url = ?, verification_status = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vehicle.getVehicleType());
            stmt.setString(2, vehicle.getVehicleName());
            stmt.setString(3, vehicle.getLicensePlate());
            
            stmt.setString(4, vehicle.getIdCardNumber());
            stmt.setString(5, vehicle.getIdCardFrontUrl());
            stmt.setString(6, vehicle.getIdCardBackUrl());
            stmt.setString(7, vehicle.getAvatarUrl());
            stmt.setString(8, vehicle.getLicenseNumber());
            stmt.setString(9, vehicle.getLicenseImageUrl());
            stmt.setString(10, vehicle.getVehicleColor());
            stmt.setString(11, vehicle.getVehicleRegistrationUrl());
            stmt.setString(12, vehicle.getVerificationStatus() != null ? vehicle.getVerificationStatus() : "PENDING");
            
            stmt.setInt(13, vehicle.getUserId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AdminDriverDTO> getPendingDriverApplications() {
        List<AdminDriverDTO> list = new ArrayList<>();
        String sql = "SELECT u.full_name, u.email, u.phone_number, v.* " +
                     "FROM users u JOIN driver_vehicles v ON u.id = v.user_id " +
                     "WHERE v.verification_status = 'PENDING' " +
                     "ORDER BY v.created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AdminDriverDTO dto = new AdminDriverDTO();
                dto.setUserId(rs.getInt("user_id"));
                dto.setFullName(rs.getString("full_name"));
                dto.setEmail(rs.getString("email"));
                dto.setPhoneNumber(rs.getString("phone_number"));
                dto.setVehicleType(rs.getString("vehicle_type"));
                dto.setVehicleName(rs.getString("vehicle_name"));
                dto.setLicensePlate(rs.getString("license_plate"));
                dto.setVehicleColor(rs.getString("vehicle_color"));
                dto.setIdCardNumber(rs.getString("id_card_number"));
                dto.setLicenseNumber(rs.getString("license_number"));
                dto.setIdCardFrontUrl(rs.getString("id_card_front_url"));
                dto.setIdCardBackUrl(rs.getString("id_card_back_url"));
                dto.setLicenseImageUrl(rs.getString("license_image_url"));
                dto.setVehicleRegistrationUrl(rs.getString("vehicle_registration_url"));
                dto.setAvatarUrl(rs.getString("avatar_url"));
                dto.setVerificationStatus(rs.getString("verification_status"));
                dto.setSubmittedAt(rs.getTimestamp("created_at"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateVerificationStatus(int userId, String status) {
        String sql = "UPDATE driver_vehicles SET verification_status = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
