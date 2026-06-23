package org.example.model;

import java.util.List;
import java.util.Map;

public class DriverEarnings {
    private double today;
    private double week;
    private double month;
    private double total;
    private int completedTripsToday;
    private int completedTripsWeek;
    private int completedTripsMonth;
    private int completedTripsTotal;
    private List<Map<String, Object>> dailyBreakdown; // 7-day chart data [{day, amount, label}]
    private List<Trip> recentTrips;

    public DriverEarnings() {
    }

    public double getToday() {
        return today;
    }

    public void setToday(double today) {
        this.today = today;
    }

    public double getWeek() {
        return week;
    }

    public void setWeek(double week) {
        this.week = week;
    }

    public double getMonth() {
        return month;
    }

    public void setMonth(double month) {
        this.month = month;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getCompletedTripsToday() {
        return completedTripsToday;
    }

    public void setCompletedTripsToday(int completedTripsToday) {
        this.completedTripsToday = completedTripsToday;
    }

    public int getCompletedTripsWeek() {
        return completedTripsWeek;
    }

    public void setCompletedTripsWeek(int completedTripsWeek) {
        this.completedTripsWeek = completedTripsWeek;
    }

    public int getCompletedTripsMonth() {
        return completedTripsMonth;
    }

    public void setCompletedTripsMonth(int completedTripsMonth) {
        this.completedTripsMonth = completedTripsMonth;
    }

    public int getCompletedTripsTotal() {
        return completedTripsTotal;
    }

    public void setCompletedTripsTotal(int completedTripsTotal) {
        this.completedTripsTotal = completedTripsTotal;
    }

    public List<Map<String, Object>> getDailyBreakdown() {
        return dailyBreakdown;
    }

    public void setDailyBreakdown(List<Map<String, Object>> dailyBreakdown) {
        this.dailyBreakdown = dailyBreakdown;
    }

    public List<Trip> getRecentTrips() {
        return recentTrips;
    }

    public void setRecentTrips(List<Trip> recentTrips) {
        this.recentTrips = recentTrips;
    }
}
