package org.example.model;

import java.sql.Timestamp;

public class Trip {
    private int id;
    private int passengerId;
    private Integer driverId; // Can be null
    private String pickupLocation;
    private String dropoffLocation;
    private String tripType; // 'ON_DEMAND', 'PRE_BOOK'
    private Timestamp scheduledTime; // Can be null
    private String matchStatus; // 'PENDING', 'MATCHED', 'CANCELLED'
    private String completionStatus; // 'NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED'
    private Timestamp createdAt;

    // Constructors
    public Trip() {
    }

    public Trip(int passengerId, String pickupLocation, String dropoffLocation, String tripType, Timestamp scheduledTime) {
        this.passengerId = passengerId;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
        this.tripType = tripType;
        this.scheduledTime = scheduledTime;
        this.matchStatus = "PENDING";
        this.completionStatus = "NOT_STARTED";
    }

    // Getters and Setters
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
}
