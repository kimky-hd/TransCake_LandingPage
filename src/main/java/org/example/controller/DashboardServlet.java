package org.example.controller;

import org.example.dao.TripDAO;
import org.example.model.BlogPost;
import org.example.model.Trip;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private TripDAO tripDAO;

    @Override
    public void init() throws ServletException {
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prevent browser caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        boolean isLoggedIn = (user != null);
        String fullName = isLoggedIn && user.getFullName() != null && !user.getFullName().trim().isEmpty() ? user.getFullName() : "Người dùng";

        // Fetch community blog posts
        List<BlogPost> blogPosts = tripDAO.getAllActiveBlogPosts();

        // Check active trips
        Trip activeTrip = null;
        Trip activePreBookTrip = null;
        String preBookDateStr = "";
        String preBookTimeStr = "";

        if (isLoggedIn) {
            activeTrip = tripDAO.getActiveOnDemandTrip(user.getId());
            activePreBookTrip = tripDAO.getActivePreBookTrip(user.getId());

            if (activePreBookTrip != null && activePreBookTrip.getScheduledTime() != null) {
                java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.text.SimpleDateFormat sdfTime = new java.text.SimpleDateFormat("HH:mm");
                preBookDateStr = sdfDate.format(activePreBookTrip.getScheduledTime());
                preBookTimeStr = sdfTime.format(activePreBookTrip.getScheduledTime());
            }
        }

        boolean hasVehicle = false;
        if (isLoggedIn) {
            org.example.dao.DriverVehicleDAO vehicleDAO = new org.example.dao.DriverVehicleDAO();
            hasVehicle = (vehicleDAO.getVehicleByUserId(user.getId()) != null);
        }

        // Set attributes for JSP
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("fullName", fullName);
        request.setAttribute("userRole", isLoggedIn ? user.getRole() : "");
        request.setAttribute("hasVehicle", hasVehicle);
        request.setAttribute("blogPosts", blogPosts);
        request.setAttribute("activeTrip", activeTrip);
        request.setAttribute("activePreBookTrip", activePreBookTrip);
        request.setAttribute("preBookDateStr", preBookDateStr);
        request.setAttribute("preBookTimeStr", preBookTimeStr);

        // Forward to dashboard.jsp
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
