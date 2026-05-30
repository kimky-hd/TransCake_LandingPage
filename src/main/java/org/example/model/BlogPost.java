package org.example.model;

import java.sql.Timestamp;

public class BlogPost {
    private int id;
    private int tripId;
    private String title;
    private String content;
    private boolean isActive;
    
    // Additional joined fields
    private String passengerName;
    private Timestamp tripCreatedAt;
    private String pickupLocation;
    private String dropoffLocation;

    public BlogPost() {
    }

    public BlogPost(int id, int tripId, String title, String content, boolean isActive, String passengerName, Timestamp tripCreatedAt, String pickupLocation, String dropoffLocation) {
        this.id = id;
        this.tripId = tripId;
        this.title = title;
        this.content = content;
        this.isActive = isActive;
        this.passengerName = passengerName;
        this.tripCreatedAt = tripCreatedAt;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public Timestamp getTripCreatedAt() {
        return tripCreatedAt;
    }

    public void setTripCreatedAt(Timestamp tripCreatedAt) {
        this.tripCreatedAt = tripCreatedAt;
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
}
