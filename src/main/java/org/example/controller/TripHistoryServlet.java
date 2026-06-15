package org.example.controller;

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
import java.util.List;

@WebServlet("/history")
public class TripHistoryServlet extends HttpServlet {
    private TripDAO tripDAO = new TripDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        List<Trip> historyList;

        if ("driver".equals(loggedInUser.getRole())) {
            historyList = tripDAO.getTripHistoryByDriver(loggedInUser.getId());
        } else {
            historyList = tripDAO.getTripHistoryByPassenger(loggedInUser.getId());
        }

        request.setAttribute("historyList", historyList);
        request.getRequestDispatcher("/history.jsp").forward(request, response);
    }
}
