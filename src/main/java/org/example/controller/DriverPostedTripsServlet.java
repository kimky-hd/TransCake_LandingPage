package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.example.dao.TripDAO;
import org.example.model.Trip;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/driver/posted-trips")
public class DriverPostedTripsServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        String action = request.getParameter("action");
        
        try {
            if ("driver".equals(loggedInUser.getRole())) {
                // Tài xế lấy danh sách chuyến do chính họ đăng
                List<Trip> driverTrips = tripDAO.getDriverPostedTrips(loggedInUser.getId());
                result.put("success", true);
                result.put("trips", driverTrips);
            } else if ("passenger".equals(loggedInUser.getRole()) || "available".equals(action)) {
                // Hành khách lấy danh sách tất cả chuyến đang chờ do tài xế đăng
                List<Trip> pendingTrips = tripDAO.getPendingDriverPostedTrips();
                result.put("success", true);
                result.put("trips", pendingTrips);
            } else {
                result.put("success", false);
                result.put("message", "Vai trò không hợp lệ.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi lấy dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
