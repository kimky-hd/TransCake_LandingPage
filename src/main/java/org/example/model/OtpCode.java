package org.example.model;

import java.sql.Timestamp;

public class OtpCode {
    private int id;
    private String phoneNumber;
    private String email;
    private String otpCode;
    private Timestamp expiresAt;
    private boolean isUsed;
    private Timestamp createdAt;

    public OtpCode() {}

    public OtpCode(String phoneNumber, String email, String otpCode, Timestamp expiresAt) {
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.otpCode = otpCode;
        this.expiresAt = expiresAt;
        this.isUsed = false;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }
    
    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }
    
    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean isUsed) { this.isUsed = isUsed; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
