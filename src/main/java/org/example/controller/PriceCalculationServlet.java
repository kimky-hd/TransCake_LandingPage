package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/api/price-estimate")
public class PriceCalculationServlet extends HttpServlet {
    private static final String VIETMAP_API_KEY = "663154c8a54428313795b6799a4e6dc463c0f678b38f7648";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonObject result = new JsonObject();
        
        try {
            String pLat = request.getParameter("pLat");
            String pLng = request.getParameter("pLng");
            String dLat = request.getParameter("dLat");
            String dLng = request.getParameter("dLng");
            String vehicleType = request.getParameter("vehicleType"); // 'MOTORBIKE' or 'CAR'
            
            if (pLat == null || pLng == null || dLat == null || dLng == null) {
                result.addProperty("success", false);
                result.addProperty("error", "Thiếu thông tin tọa độ");
                out.print(gson.toJson(result));
                return;
            }
            
            String vehicleParam = "car";
            if ("MOTORBIKE".equalsIgnoreCase(vehicleType)) {
                vehicleParam = "motorcycle";
            }
            
            String routeUrl = String.format(
                "https://maps.vietmap.vn/api/route?api-version=1.1&apikey=%s&point=%s,%s&point=%s,%s&vehicle=%s&points_encoded=false",
                VIETMAP_API_KEY, pLat, pLng, dLat, dLng, vehicleParam
            );
            
            URL url = new URL(routeUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder responseStr = new StringBuilder();
                String line;
                while ((line = in.readLine()) != null) {
                    responseStr.append(line);
                }
                in.close();
                
                JsonObject mapResponse = JsonParser.parseString(responseStr.toString()).getAsJsonObject();
                if (mapResponse.has("paths") && mapResponse.get("paths").getAsJsonArray().size() > 0) {
                    JsonObject path = mapResponse.get("paths").getAsJsonArray().get(0).getAsJsonObject();
                    double distanceMeters = path.get("distance").getAsDouble();
                    long timeMs = path.get("time").getAsLong();
                    
                    double distanceKm = Math.round((distanceMeters / 1000.0) * 10.0) / 10.0;
                    long durationMins = (long) Math.ceil(timeMs / 60000.0);
                    
                    double baseFare = 10000.0;
                    double perKmFare = 12000.0;
                    
                    if ("MOTORBIKE".equalsIgnoreCase(vehicleType)) {
                        baseFare = 5000.0;
                        perKmFare = 5000.0;
                    }
                    
                    double totalPrice = baseFare + (distanceKm * perKmFare);
                    
                    result.addProperty("success", true);
                    result.addProperty("distanceKm", distanceKm);
                    result.addProperty("durationMins", durationMins);
                    result.addProperty("totalPrice", totalPrice);
                    
                    if (path.has("points")) {
                        result.add("points", path.get("points"));
                    }
                    if (path.has("bbox")) {
                        result.add("bbox", path.get("bbox"));
                    }
                    
                } else {
                    result.addProperty("success", false);
                    result.addProperty("error", "Không tìm thấy đường đi");
                }
            } else {
                result.addProperty("success", false);
                result.addProperty("error", "Lỗi kết nối đến dịch vụ bản đồ");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("error", "Lỗi server: " + e.getMessage());
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
