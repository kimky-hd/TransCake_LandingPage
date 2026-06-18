package org.example.controller;

import org.example.dao.TripDAO;
import org.example.model.Trip;
import org.example.model.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/driver/active-trip")
public class DriverActiveTripServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"driver".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Forbidden\"}");
            return;
        }

        // Ưu tiên 1: Lấy chuyến đi đang IN_PROGRESS (dù là Đặt ngay hay Hẹn trước)
        Trip activeTrip = tripDAO.getInProgressTripForDriver(user.getId());
        
        // Ưu tiên 2: Nếu không có chuyến nào đang chạy, ưu tiên trả về chuyến ON_DEMAND (NOT_STARTED)
        if (activeTrip == null) {
            activeTrip = tripDAO.getActiveOnDemandTripForDriver(user.getId());
        }
        // Lưu ý: Không trả về chuyến PRE_BOOK (NOT_STARTED) ở API này vì nó đã hiển thị ở phần Lịch trình sắp tới.
        
        JsonObject json = new JsonObject();
        if (activeTrip != null) {
            json.addProperty("active", true);
            json.add("trip", gson.toJsonTree(activeTrip));
        } else {
            json.addProperty("active", false);
        }

        response.getWriter().write(gson.toJson(json));
    }
}
