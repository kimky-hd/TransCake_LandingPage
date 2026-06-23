package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.TripDAO;
import org.example.model.DriverEarnings;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/driver/earnings")
public class DriverEarningsServlet extends HttpServlet {
    private TripDAO tripDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        tripDAO = new TripDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Unauthorized");
            out.print(gson.toJson(error));
            out.flush();
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"driver".equals(loggedInUser.getRole())) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Only drivers can view earnings");
            out.print(gson.toJson(error));
            out.flush();
            return;
        }

        try {
            DriverEarnings earnings = tripDAO.getDriverEarnings(loggedInUser.getId());
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", earnings);
            out.print(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Internal Server Error");
            out.print(gson.toJson(error));
        } finally {
            out.flush();
        }
    }
}
