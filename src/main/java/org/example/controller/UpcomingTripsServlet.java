package org.example.controller;

import com.google.gson.Gson;
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

@WebServlet("/api/upcoming-trips")
public class UpcomingTripsServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private Gson gson = new Gson();

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

        User user = (User) session.getAttribute("loggedInUser");

        try {
            List<Trip> trips;
            if ("driver".equals(user.getRole())) {
                trips = tripDAO.getUpcomingTripsForDriver(user.getId());
            } else {
                trips = tripDAO.getUpcomingTripsForPassenger(user.getId());
            }

            result.put("success", true);
            result.put("role", user.getRole());
            result.put("trips", trips);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
