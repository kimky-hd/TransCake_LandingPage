package org.example.controller;

import org.example.service.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/moikhanhdichoi")
public class MoiKhanhServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just forward to the JSP to display the page
        request.getRequestDispatcher("/moikhanhdichoi.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty() || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            out.print("{\"success\": false, \"message\": \"Email chưa đúng định dạng rồi, em nhập lại nha! 😢\"}");
            out.flush();
            return;
        }

        try {
            // Lưu email vào DB thay vì gửi mail tự động (nhưng bây giờ thì cả lưu và gửi)
            org.example.dao.UserDAO userDAO = new org.example.dao.UserDAO();
            boolean saved = userDAO.saveTimelineEmail(email.trim());
            
            if (saved) {
                // Kích hoạt gửi mail timeline lãng mạn bằng email phụ
                EmailService.sendRomanticTimelineEmail(email.trim());
                
                out.print("{\"success\": true, \"message\": \"Đã lưu và gửi email thành công!\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Email này đã được đăng ký hoặc có lỗi xảy ra!\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Hệ thống bị lỗi nhỏ, em nhắn anh trực tiếp nhé! ❤️\"}");
        } finally {
            out.flush();
        }
    }
}
