import java.sql.*;
public class CheckDB {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/transcake_db?useSSL=false&allowPublicKeyRetrieval=true", "root", "1234");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, trip_type, pickup_location, pickup_lat, dropoff_location, pickup_lng FROM trips ORDER BY id DESC LIMIT 5");
            while(rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + ", Type: " + rs.getString("trip_type") + ", Pickup: " + rs.getString("pickup_location") + ", Lat: " + rs.getDouble("pickup_lat"));
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
