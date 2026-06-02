package org.example.model;

import java.sql.Timestamp;

public class DriverVehicle {
    private int id;
    private int userId;
    private String vehicleType; // 'MOTORBIKE', 'CAR'
    private String vehicleName;
    private String licensePlate;
    private Timestamp createdAt;

    public DriverVehicle() {
    }

    public DriverVehicle(int userId, String vehicleType, String vehicleName, String licensePlate) {
        this.userId = userId;
        this.vehicleType = vehicleType;
        this.vehicleName = vehicleName;
        this.licensePlate = licensePlate;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
