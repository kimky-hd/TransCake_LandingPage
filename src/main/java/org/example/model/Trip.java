package org.example.model;

import java.sql.Timestamp;

public class Trip {
    private int id;
    private int passengerId;
    private Integer driverId; // Can be null
    private String pickupLocation;
    private Double pickupLat;
    private Double pickupLng;
    private String dropoffLocation;
    private Double dropoffLat;
    private Double dropoffLng;
    private String tripType; // 'ON_DEMAND', 'PRE_BOOK'
    private Timestamp scheduledTime; // Can be null
    private String matchStatus; // 'PENDING', 'MATCHED', 'CANCELLED'
    private String completionStatus; // 'NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED'
    private String noteForDriver;
    private Double price;
    private Double distance;
    private Timestamp createdAt;
    private String vehicleType; // 'MOTORBIKE', 'CAR'

    // Constructors
    public Trip() {
    }

    public Trip(int passengerId, String pickupLocation, Double pickupLat, Double pickupLng, String dropoffLocation, Double dropoffLat, Double dropoffLng, String tripType, Timestamp scheduledTime, String noteForDriver, Double price, Double distance, String vehicleType) {
        this.passengerId = passengerId;
        this.pickupLocation = pickupLocation;
        this.pickupLat = pickupLat;
        this.pickupLng = pickupLng;
        this.dropoffLocation = dropoffLocation;
        this.dropoffLat = dropoffLat;
        this.dropoffLng = dropoffLng;
        this.tripType = tripType;
        this.scheduledTime = scheduledTime;
        this.matchStatus = "PENDING";
        this.completionStatus = "NOT_STARTED";
        this.noteForDriver = noteForDriver;
        this.price = price;
        this.distance = distance;
        this.vehicleType = vehicleType;
    }

    // Getters and Setters
    public Double getPickupLat() { return pickupLat; }
    public void setPickupLat(Double pickupLat) { this.pickupLat = pickupLat; }

    public Double getPickupLng() { return pickupLng; }
    public void setPickupLng(Double pickupLng) { this.pickupLng = pickupLng; }

    public Double getDropoffLat() { return dropoffLat; }
    public void setDropoffLat(Double dropoffLat) { this.dropoffLat = dropoffLat; }

    public Double getDropoffLng() { return dropoffLng; }
    public void setDropoffLng(Double dropoffLng) { this.dropoffLng = dropoffLng; }
    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPassengerId() {
        return passengerId;
    }

    public void setPassengerId(int passengerId) {
        this.passengerId = passengerId;
    }

    public Integer getDriverId() {
        return driverId;
    }

    public void setDriverId(Integer driverId) {
        this.driverId = driverId;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public String getDropoffLocation() {
        return dropoffLocation;
    }

    public void setDropoffLocation(String dropoffLocation) {
        this.dropoffLocation = dropoffLocation;
    }

    public String getTripType() {
        return tripType;
    }

    public void setTripType(String tripType) {
        this.tripType = tripType;
    }

    public Timestamp getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Timestamp scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getMatchStatus() {
        return matchStatus;
    }

    public void setMatchStatus(String matchStatus) {
        this.matchStatus = matchStatus;
    }

    public String getCompletionStatus() {
        return completionStatus;
    }

    public void setCompletionStatus(String completionStatus) {
        this.completionStatus = completionStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getNoteForDriver() {
        return noteForDriver;
    }

    public void setNoteForDriver(String noteForDriver) {
        this.noteForDriver = noteForDriver;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }
}
