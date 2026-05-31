package org.example.controller;

import org.example.dao.TripDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/trip-cancel")
public class TripCancelServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tripIdStr = request.getParameter("tripId");
        if (tripIdStr != null && !tripIdStr.isEmpty()) {
            try {
                int tripId = Integer.parseInt(tripIdStr);
                boolean success = tripDAO.cancelTrip(tripId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
            } catch (Exception e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            }
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"Missing tripId\"}");
        }
    }
}
