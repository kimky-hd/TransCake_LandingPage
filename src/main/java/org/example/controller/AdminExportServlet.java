package org.example.controller;

import org.example.dao.AdminDAO;
import org.example.model.AdminDashboardDTO;
import org.example.model.Trip;
import org.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/export")
public class AdminExportServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User adminUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        AdminDashboardDTO stats = adminDAO.getDashboardStats(startDate, endDate);

        response.setContentType("text/csv; charset=UTF-8");
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        response.setHeader("Content-Disposition", "attachment; filename=\"TransCake_Data_" + timestamp + ".csv\"");

        try (OutputStream out = response.getOutputStream()) {
            // Write UTF-8 BOM for Microsoft Excel to properly recognize Vietnamese characters
            out.write(239);
            out.write(187);
            out.write(191);

            try (PrintWriter writer = new PrintWriter(new OutputStreamWriter(out, StandardCharsets.UTF_8))) {
                
                // 1. Export Users Section
                writer.println("--- DANH SÁCH NGƯỜI DÙNG ---");
                writer.println("ID,Họ và Tên,SĐT,Email,Vai trò,Trạng thái,Giới tính,Ngày tạo");
                
                List<User> users = stats.getAllUsers();
                if (users != null) {
                    for (User user : users) {
                        writer.printf("%d,%s,%s,%s,%s,%s,%s,%s\n",
                                user.getId(),
                                escapeCsv(user.getFullName()),
                                escapeCsv(user.getPhoneNumber()),
                                escapeCsv(user.getEmail()),
                                escapeCsv(user.getRole()),
                                escapeCsv(user.getStatus()),
                                escapeCsv(user.getGender()),
                                user.getCreatedAt() != null ? user.getCreatedAt().toString() : ""
                        );
                    }
                }
                
                writer.println();
                writer.println();
                
                // 2. Export Trips Section
                writer.println("--- DANH SÁCH CHUYẾN ĐI ---");
                writer.println("Mã Chuyến,Mã Khách,Tên Khách,Mã Tài Xế,Điểm Đón,Điểm Trả,Loại Chuyến,Phương Tiện,Quãng Đường (km),Giá Tiền,Trạng Thái Ghép,Trạng Thái Hoàn Thành,Ngày Tạo");
                
                List<Trip> trips = stats.getAllTrips();
                if (trips != null) {
                    for (Trip trip : trips) {
                        writer.printf("%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                                trip.getId(),
                                trip.getPassengerId(),
                                escapeCsv(trip.getPassengerName()),
                                trip.getDriverId() != null ? trip.getDriverId() : "",
                                escapeCsv(trip.getPickupLocation()),
                                escapeCsv(trip.getDropoffLocation()),
                                escapeCsv(trip.getTripType()),
                                escapeCsv(trip.getVehicleType()),
                                trip.getDistance() != null ? trip.getDistance() : "",
                                trip.getPrice() != null ? trip.getPrice() : "",
                                escapeCsv(trip.getMatchStatus()),
                                escapeCsv(trip.getCompletionStatus()),
                                trip.getCreatedAt() != null ? trip.getCreatedAt().toString() : ""
                        );
                    }
                }
                writer.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xuất file Excel (CSV)");
        }
    }

    private String escapeCsv(String data) {
        if (data == null) return "";
        String escapedData = data.replaceAll("\\R", " ");
        if (data.contains(",") || data.contains("\"") || data.contains("'")) {
            data = data.replace("\"", "\"\"");
            escapedData = "\"" + data + "\"";
        }
        return escapedData;
    }
}
