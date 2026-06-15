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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String tripIdStr = request.getParameter("tripId");
        if (tripIdStr == null || tripIdStr.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"error\": \"Missing tripId\"}");
            return;
        }

        try {
            int tripId = Integer.parseInt(tripIdStr);

            // Kiểm tra trạng thái hiện tại — hành khách KHÔNG được hủy chuyến đã MATCHED
            String currentStatus = tripDAO.getTripMatchStatus(tripId);
            if ("MATCHED".equals(currentStatus)) {
                response.getWriter().write("{\"success\": false, \"error\": \"Chuyến đi đã được tài xế nhận. Chỉ tài xế mới có thể hủy chuyến.\", \"blocked\": true}");
                return;
            }

            boolean success = tripDAO.cancelTrip(tripId);
            response.getWriter().write("{\"success\": " + success + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
