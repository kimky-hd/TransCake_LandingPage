package org.example.dao;

import org.example.model.DriverVehicle;
import org.example.utils.DBContext;

import java.sql.Connection;
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
        String sql = "INSERT INTO driver_vehicles (user_id, vehicle_type, vehicle_name, license_plate) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicle.getUserId());
            stmt.setString(2, vehicle.getVehicleType());
            stmt.setString(3, vehicle.getVehicleName());
            stmt.setString(4, vehicle.getLicensePlate());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateVehicle(DriverVehicle vehicle) {
        String sql = "UPDATE driver_vehicles SET vehicle_type = ?, vehicle_name = ?, license_plate = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vehicle.getVehicleType());
            stmt.setString(2, vehicle.getVehicleName());
            stmt.setString(3, vehicle.getLicensePlate());
            stmt.setInt(4, vehicle.getUserId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
