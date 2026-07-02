package org.example.controller.api;

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

@WebServlet("/api/history")
public class TripHistoryApiServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Vui lòng đăng nhập");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(error));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String role = request.getParameter("role"); // "passenger" or "driver"
        
        if (role == null || role.trim().isEmpty()) {
            role = loggedInUser.getRole(); // fallback
        }

        List<Trip> historyList;

        if ("driver".equalsIgnoreCase(role)) {
            historyList = tripDAO.getTripHistoryByDriver(loggedInUser.getId());
        } else {
            historyList = tripDAO.getTripHistoryByPassenger(loggedInUser.getId());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", historyList);
        
        response.getWriter().write(gson.toJson(result));
    }
}
