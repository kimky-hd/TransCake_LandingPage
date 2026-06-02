package org.example.service;

import org.example.model.Trip;
import org.example.model.User;

import java.util.List;

public class TripMatchingService {

    /**
     * Thuật toán tính khoảng cách đường chim bay giữa 2 điểm tọa độ (Haversine formula).
     * @return Khoảng cách tính bằng kilomet (km).
     */
    public static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Bán kính trái đất (km)
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c; 
    }

    /**
     * Sắp xếp danh sách chuyến đi chờ duyệt dựa trên độ phù hợp với tài xế.
     * Tiêu chí:
     * 1. Điểm đón (pickup) càng gần tài xế càng được ưu tiên.
     * 2. Thời gian chuyến đi càng gấp càng được ưu tiên.
     */
    public List<Trip> rankTripsForDriver(User driver, List<Trip> pendingTrips, Double driverLat, Double driverLng) {
        if (pendingTrips == null || pendingTrips.isEmpty()) return pendingTrips;

        pendingTrips.sort((t1, t2) -> {
            double score1 = 0.0;
            double score2 = 0.0;

            // 1. Điểm Khoảng cách (Tối đa 100 điểm, trừ dần theo mỗi km cách xa)
            if (driverLat != null && driverLng != null) {
                if (t1.getPickupLat() != null && t1.getPickupLng() != null) {
                    double dist1 = calculateDistance(driverLat, driverLng, t1.getPickupLat(), t1.getPickupLng());
                    score1 += Math.max(0, 100 - dist1);
                }
                if (t2.getPickupLat() != null && t2.getPickupLng() != null) {
                    double dist2 = calculateDistance(driverLat, driverLng, t2.getPickupLat(), t2.getPickupLng());
                    score2 += Math.max(0, 100 - dist2);
                }
            }

            // 2. Điểm Thời gian (Ưu tiên các chuyến sắp khởi hành)
            if (t1.getScheduledTime() != null) {
                long diffHours = (t1.getScheduledTime().getTime() - System.currentTimeMillis()) / 3600000;
                if (diffHours <= 0) score1 += 50; // Quá hạn hoặc ngay lập tức
                else if (diffHours < 2) score1 += 30; // Khởi hành trong 2h tới
            }
            if (t2.getScheduledTime() != null) {
                long diffHours = (t2.getScheduledTime().getTime() - System.currentTimeMillis()) / 3600000;
                if (diffHours <= 0) score2 += 50;
                else if (diffHours < 2) score2 += 30;
            }

            // Sắp xếp giảm dần (điểm cao nhất lên đầu)
            return Double.compare(score2, score1);
        });

        return pendingTrips;
    }
}
