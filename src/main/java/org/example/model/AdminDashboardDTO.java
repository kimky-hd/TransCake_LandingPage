package org.example.model;

import java.util.List;
import java.util.Map;

public class AdminDashboardDTO {
    // User Stats
    private int totalUsers;
    private int totalPassengers;
    private int totalDrivers;
    private int totalAdmins;
    private int newUsersToday;
    
    // Trip Stats
    private int totalTrips;
    private int completedTrips;
    private int cancelledTrips;
    private int pendingTrips;
    private int inProgressTrips;
    private int tripsToday;
    private double completionRate;
    
    // Revenue Stats
    private double totalRevenue;
    private double revenueToday;
    private double revenueThisWeek;
    private double revenueThisMonth;
    private double avgTripPrice;
    private double totalDistance;
    
    // Driver Application Stats
    private int pendingDriverApps;
    private int approvedDriverApps;
    private int rejectedDriverApps;
    
    // Breakdown Stats
    private int onDemandTrips;
    private int preBookTrips;
    private int motorbikeTrips;
    private int carTrips;
    
    // Chart Data
    private List<Map<String, Object>> dailyRevenue; // 7 days data
    private Map<String, Integer> hobbiesStats; // SEO
    
    // Recent Data
    private List<Trip> allTrips;
    private List<User> allUsers;

    public AdminDashboardDTO() {}

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }

    public int getTotalPassengers() { return totalPassengers; }
    public void setTotalPassengers(int totalPassengers) { this.totalPassengers = totalPassengers; }

    public int getTotalDrivers() { return totalDrivers; }
    public void setTotalDrivers(int totalDrivers) { this.totalDrivers = totalDrivers; }

    public int getTotalAdmins() { return totalAdmins; }
    public void setTotalAdmins(int totalAdmins) { this.totalAdmins = totalAdmins; }

    public int getNewUsersToday() { return newUsersToday; }
    public void setNewUsersToday(int newUsersToday) { this.newUsersToday = newUsersToday; }

    public int getTotalTrips() { return totalTrips; }
    public void setTotalTrips(int totalTrips) { this.totalTrips = totalTrips; }

    public int getCompletedTrips() { return completedTrips; }
    public void setCompletedTrips(int completedTrips) { this.completedTrips = completedTrips; }

    public int getCancelledTrips() { return cancelledTrips; }
    public void setCancelledTrips(int cancelledTrips) { this.cancelledTrips = cancelledTrips; }

    public int getPendingTrips() { return pendingTrips; }
    public void setPendingTrips(int pendingTrips) { this.pendingTrips = pendingTrips; }

    public int getInProgressTrips() { return inProgressTrips; }
    public void setInProgressTrips(int inProgressTrips) { this.inProgressTrips = inProgressTrips; }

    public int getTripsToday() { return tripsToday; }
    public void setTripsToday(int tripsToday) { this.tripsToday = tripsToday; }

    public double getCompletionRate() { return completionRate; }
    public void setCompletionRate(double completionRate) { this.completionRate = completionRate; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public double getRevenueToday() { return revenueToday; }
    public void setRevenueToday(double revenueToday) { this.revenueToday = revenueToday; }

    public double getRevenueThisWeek() { return revenueThisWeek; }
    public void setRevenueThisWeek(double revenueThisWeek) { this.revenueThisWeek = revenueThisWeek; }

    public double getRevenueThisMonth() { return revenueThisMonth; }
    public void setRevenueThisMonth(double revenueThisMonth) { this.revenueThisMonth = revenueThisMonth; }

    public double getAvgTripPrice() { return avgTripPrice; }
    public void setAvgTripPrice(double avgTripPrice) { this.avgTripPrice = avgTripPrice; }

    public double getTotalDistance() { return totalDistance; }
    public void setTotalDistance(double totalDistance) { this.totalDistance = totalDistance; }

    public int getPendingDriverApps() { return pendingDriverApps; }
    public void setPendingDriverApps(int pendingDriverApps) { this.pendingDriverApps = pendingDriverApps; }

    public int getApprovedDriverApps() { return approvedDriverApps; }
    public void setApprovedDriverApps(int approvedDriverApps) { this.approvedDriverApps = approvedDriverApps; }

    public int getRejectedDriverApps() { return rejectedDriverApps; }
    public void setRejectedDriverApps(int rejectedDriverApps) { this.rejectedDriverApps = rejectedDriverApps; }

    public int getOnDemandTrips() { return onDemandTrips; }
    public void setOnDemandTrips(int onDemandTrips) { this.onDemandTrips = onDemandTrips; }

    public int getPreBookTrips() { return preBookTrips; }
    public void setPreBookTrips(int preBookTrips) { this.preBookTrips = preBookTrips; }

    public int getMotorbikeTrips() { return motorbikeTrips; }
    public void setMotorbikeTrips(int motorbikeTrips) { this.motorbikeTrips = motorbikeTrips; }

    public int getCarTrips() { return carTrips; }
    public void setCarTrips(int carTrips) { this.carTrips = carTrips; }

    public List<Map<String, Object>> getDailyRevenue() { return dailyRevenue; }
    public void setDailyRevenue(List<Map<String, Object>> dailyRevenue) { this.dailyRevenue = dailyRevenue; }

    public List<Trip> getAllTrips() { return allTrips; }
    public void setAllTrips(List<Trip> allTrips) { this.allTrips = allTrips; }

    public List<User> getAllUsers() { return allUsers; }
    public void setAllUsers(List<User> allUsers) { this.allUsers = allUsers; }

    public Map<String, Integer> getHobbiesStats() { return hobbiesStats; }
    public void setHobbiesStats(Map<String, Integer> hobbiesStats) { this.hobbiesStats = hobbiesStats; }
}
