package org.example.controller;

import org.example.dao.DriverVehicleDAO;
import org.example.model.AdminDriverDTO;
import org.example.model.User;
import org.example.service.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/drivers")
public class AdminDriversServlet extends HttpServlet {
    private DriverVehicleDAO vehicleDAO = new DriverVehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        List<AdminDriverDTO> pendingDrivers = vehicleDAO.getPendingDriverApplications();
        request.setAttribute("pendingDrivers", pendingDrivers);
        
        request.getRequestDispatcher("/admin_drivers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        String email = request.getParameter("email");
        String driverName = request.getParameter("driverName");

        if (action == null || userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/drivers");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(userIdStr);
            if ("APPROVE".equalsIgnoreCase(action)) {
                boolean success = vehicleDAO.updateVerificationStatus(targetUserId, "APPROVED");
                if (success && email != null) {
                    EmailService.sendDriverApprovalEmail(email, driverName);
                }
            } else if ("REJECT".equalsIgnoreCase(action)) {
                boolean success = vehicleDAO.updateVerificationStatus(targetUserId, "REJECTED");
                if (success && email != null) {
                    EmailService.sendDriverRejectionEmail(email, driverName);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/drivers");
    }
}
