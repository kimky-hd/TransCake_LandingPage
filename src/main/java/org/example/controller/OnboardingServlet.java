package org.example.controller;

import com.google.gson.Gson;
import org.example.dao.UserDAO;
import org.example.dao.DriverVehicleDAO;
import org.example.model.User;
import org.example.model.DriverVehicle;

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

@WebServlet("/api/onboarding")
public class OnboardingServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        // Kiểm tra đăng nhập hoặc đăng ký tạm thời
        HttpSession session = request.getSession(false);
        if (session == null) {
            result.put("success", false);
            result.put("message", "Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String pendingPhone = (String) session.getAttribute("pendingUserPhone");
        String pendingEmail = (String) session.getAttribute("pendingUserEmail");
        String pendingPass = (String) session.getAttribute("pendingUserPass");

        if (loggedInUser == null && (pendingPhone == null || pendingPass == null || pendingEmail == null)) {
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập hoặc đăng ký trước khi thực hiện.");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            // Đọc dữ liệu JSON
            Map<String, Object> body = gson.fromJson(request.getReader(), Map.class);
            if (body == null) {
                result.put("success", false);
                result.put("message", "Thiếu dữ liệu onboarding.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Lấy thông tin
            String fullName = (String) body.get("fullName");
            String gender = (String) body.get("gender");
            String role = (String) body.get("role");
            List<String> tags = (List<String>) body.get("tags");
            
            // Driver Vehicle Info
            String vehicleType = (String) body.get("vehicleType");
            String vehicleName = (String) body.get("vehicleName");
            String licensePlate = (String) body.get("licensePlate");
            String idCardNumber = (String) body.get("idCardNumber");
            String idCardFrontUrl = (String) body.get("idCardFrontUrl");
            String idCardBackUrl = (String) body.get("idCardBackUrl");
            String avatarUrl = (String) body.get("avatarUrl");
            String licenseNumber = (String) body.get("licenseNumber");
            String licenseImageUrl = (String) body.get("licenseImageUrl");
            String vehicleColor = (String) body.get("vehicleColor");
            String vehicleRegistrationUrl = (String) body.get("vehicleRegistrationUrl");

            Boolean isDriverUpgradeObj = (Boolean) body.get("isDriverUpgrade");
            boolean isDriverUpgrade = isDriverUpgradeObj != null && isDriverUpgradeObj;

            if (isDriverUpgrade) {
                if (loggedInUser == null) {
                    result.put("success", false);
                    result.put("message", "Vui lòng đăng nhập.");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                
                if (vehicleName == null || vehicleName.trim().isEmpty() || licensePlate == null || licensePlate.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Vui lòng điền tên xe và biển số xe.");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                
                boolean updated = userDAO.updateOnboardingProfile(loggedInUser.getId(), loggedInUser.getFullName(), loggedInUser.getGender(), "driver", loggedInUser.getHobbies());
                if (updated) {
                    // Hủy tất cả các chuyến đi ở vai trò passenger cũ
                    org.example.dao.TripDAO tripDAO = new org.example.dao.TripDAO();
                    tripDAO.cancelAllTripsForUser(loggedInUser.getId(), "passenger");

                    loggedInUser.setRole("driver");
                    session.setAttribute("loggedInUser", loggedInUser);
                    
                    DriverVehicleDAO vehicleDAO = new DriverVehicleDAO();
                    DriverVehicle vehicle = new DriverVehicle(loggedInUser.getId(), vehicleType != null ? vehicleType : "MOTORBIKE", vehicleName, licensePlate);
                    vehicle.setIdCardNumber(idCardNumber);
                    vehicle.setIdCardFrontUrl(idCardFrontUrl);
                    vehicle.setIdCardBackUrl(idCardBackUrl);
                    vehicle.setAvatarUrl(avatarUrl);
                    vehicle.setLicenseNumber(licenseNumber);
                    vehicle.setLicenseImageUrl(licenseImageUrl);
                    vehicle.setVehicleColor(vehicleColor);
                    vehicle.setVehicleRegistrationUrl(vehicleRegistrationUrl);
                    vehicle.setVerificationStatus("PENDING");
                    
                    if (vehicleDAO.getVehicleByUserId(loggedInUser.getId()) == null) {
                        vehicleDAO.registerVehicle(vehicle);
                    } else {
                        vehicleDAO.updateVehicle(vehicle);
                    }
                    result.put("success", true);
                    result.put("message", "Đăng ký phương tiện thành công! Các chuyến xe cũ đã bị hủy.");
                } else {
                    result.put("success", false);
                    result.put("message", "Lỗi server khi lưu thông tin.");
                }
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (fullName == null || fullName.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập họ và tên.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (tags == null || tags.size() < 4) {
                result.put("success", false);
                result.put("message", "Vui lòng chọn ít nhất 4 sở thích.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Kết hợp List tags thành chuỗi cách nhau bởi dấu phẩy
            String joinedHobbies = String.join(", ", tags);
            boolean isSuccess = false;

            if (pendingPhone != null && pendingEmail != null && pendingPass != null) {
                // Luồng Đăng ký mới
                isSuccess = userDAO.createUserWithOnboarding(pendingPhone, pendingEmail, pendingPass, fullName, gender, role, joinedHobbies);
                if (isSuccess) {
                    User createdUser = userDAO.findByEmail(pendingEmail);
                    session.setAttribute("loggedInUser", createdUser);
                    session.removeAttribute("pendingUserPhone");
                    session.removeAttribute("pendingUserEmail");
                    session.removeAttribute("pendingUserPass");
                }
            } else if (loggedInUser != null) {
                // Luồng đã Đăng nhập
                isSuccess = userDAO.updateOnboardingProfile(loggedInUser.getId(), fullName, gender, role, joinedHobbies);
                if (isSuccess) {
                    loggedInUser.setFullName(fullName);
                    loggedInUser.setGender(gender);
                    loggedInUser.setRole(role);
                    loggedInUser.setHobbies(joinedHobbies);
                    session.setAttribute("loggedInUser", loggedInUser);
                }
            }

            if (isSuccess) {
                // Nếu là tài xế, lưu thêm thông tin xe
                if ("driver".equals(role)) {
                    User finalUser = (User) session.getAttribute("loggedInUser");
                    if (finalUser != null && vehicleType != null && vehicleName != null && licensePlate != null) {
                        DriverVehicleDAO vehicleDAO = new DriverVehicleDAO();
                        DriverVehicle vehicle = new DriverVehicle(finalUser.getId(), vehicleType, vehicleName, licensePlate);
                        vehicle.setIdCardNumber(idCardNumber);
                        vehicle.setIdCardFrontUrl(idCardFrontUrl);
                        vehicle.setIdCardBackUrl(idCardBackUrl);
                        vehicle.setAvatarUrl(avatarUrl);
                        vehicle.setLicenseNumber(licenseNumber);
                        vehicle.setLicenseImageUrl(licenseImageUrl);
                        vehicle.setVehicleColor(vehicleColor);
                        vehicle.setVehicleRegistrationUrl(vehicleRegistrationUrl);
                        vehicle.setVerificationStatus("PENDING");
                        
                        // Check if exists
                        if (vehicleDAO.getVehicleByUserId(finalUser.getId()) == null) {
                            vehicleDAO.registerVehicle(vehicle);
                        } else {
                            vehicleDAO.updateVehicle(vehicle);
                        }
                    }
                }

                result.put("success", true);
                result.put("message", "Hoàn tất hồ sơ thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Lỗi server khi lưu thông tin.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi định dạng dữ liệu: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }
}
