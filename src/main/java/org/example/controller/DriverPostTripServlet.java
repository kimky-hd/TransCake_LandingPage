package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.example.dao.TripDAO;
import org.example.dao.DriverVehicleDAO;
import org.example.model.DriverVehicle;
import org.example.model.Trip;
import org.example.model.User;
import org.example.websocket.TripWebSocketEndpoint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/driver/post-trip")
public class DriverPostTripServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private DriverVehicleDAO vehicleDAO = new DriverVehicleDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"driver".equals(loggedInUser.getRole())) {
            result.put("success", false);
            result.put("message", "Chỉ tài xế mới có thể đăng chuyến đi.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        // Kiểm tra xe đã được duyệt chưa
        DriverVehicle vehicle = vehicleDAO.getVehicleByUserId(loggedInUser.getId());
        if (vehicle == null || !"APPROVED".equals(vehicle.getVerificationStatus())) {
            result.put("success", false);
            result.put("message", "Xe của bạn chưa được duyệt. Vui lòng chờ hệ thống kiểm duyệt.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            Map<String, Object> body = gson.fromJson(request.getReader(), Map.class);
            if (body == null || !body.containsKey("pickupLat") || !body.containsKey("dropoffLat")) {
                result.put("success", false);
                result.put("message", "Thiếu thông tin điểm đi/đến.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kiểm tra xem tài xế có chuyến nào đang PENDING không (chỉ cho phép 1 chuyến chờ khách)
            List<Trip> currentPosted = tripDAO.getDriverPostedTrips(loggedInUser.getId());
            boolean hasPending = currentPosted.stream().anyMatch(t -> "PENDING".equals(t.getMatchStatus()));
            if (hasPending) {
                result.put("success", false);
                result.put("message", "Bạn đang có một chuyến đi chưa có khách. Vui lòng chờ hoặc hủy chuyến cũ trước khi đăng chuyến mới.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            Trip trip = new Trip();
            trip.setDriverId(loggedInUser.getId());
            trip.setPickupLocation((String) body.get("pickupLocation"));
            trip.setPickupLat(Double.valueOf(body.get("pickupLat").toString()));
            trip.setPickupLng(Double.valueOf(body.get("pickupLng").toString()));
            trip.setDropoffLocation((String) body.get("dropoffLocation"));
            trip.setDropoffLat(Double.valueOf(body.get("dropoffLat").toString()));
            trip.setDropoffLng(Double.valueOf(body.get("dropoffLng").toString()));
            
            trip.setTripType("PRE_BOOK"); // Các chuyến tài xế tự đăng mặc định là PRE_BOOK
            trip.setMatchStatus("PENDING");
            trip.setCompletionStatus("NOT_STARTED");
            trip.setNoteForDriver((String) body.get("note"));
            trip.setDistance(body.containsKey("distance") && body.get("distance") != null ? Double.valueOf(body.get("distance").toString()) : 0.0);
            
            // Xử lý giá tiền (nếu có)
            if (body.containsKey("price") && body.get("price") != null && !body.get("price").toString().trim().isEmpty()) {
                try {
                    trip.setPrice(Double.valueOf(body.get("price").toString()));
                } catch (NumberFormatException e) {
                    trip.setPrice(null);
                }
            } else {
                trip.setPrice(null);
            }

            trip.setVehicleType(vehicle.getVehicleType()); // Lấy loại xe từ thông tin đăng ký

            String scheduledTimeStr = (String) body.get("scheduledTime");
            if (scheduledTimeStr != null && !scheduledTimeStr.trim().isEmpty()) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                    LocalDateTime ldt = LocalDateTime.parse(scheduledTimeStr, formatter);
                    trip.setScheduledTime(Timestamp.valueOf(ldt));
                } catch (DateTimeParseException e) {
                    result.put("success", false);
                    result.put("message", "Định dạng thời gian không hợp lệ. Vui lòng sử dụng format yyyy-MM-dd'T'HH:mm");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            } else {
                result.put("success", false);
                result.put("message", "Vui lòng chọn thời gian khởi hành.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int tripId = tripDAO.insertDriverTrip(trip);
            if (tripId > 0) {
                // Broadcast cho hành khách
                JsonObject payload = new JsonObject();
                payload.addProperty("tripId", tripId);
                payload.addProperty("driverName", loggedInUser.getFullName());
                payload.addProperty("pickupLocation", trip.getPickupLocation());
                payload.addProperty("dropoffLocation", trip.getDropoffLocation());
                TripWebSocketEndpoint.broadcastToAllPassengers("NEW_DRIVER_TRIP", payload);

                result.put("success", true);
                result.put("message", "Đăng chuyến đi thành công!");
                result.put("tripId", tripId);
            } else {
                result.put("success", false);
                result.put("message", "Lỗi khi lưu chuyến đi vào CSDL.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi xử lý dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
