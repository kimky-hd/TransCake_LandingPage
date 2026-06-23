package org.example;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import org.example.utils.DBContext;

public class RunSQL {
    public static void main(String[] args) {
        try {
            Connection c = DBContext.getConnection();
            Statement s = c.createStatement();
            
            ResultSet rs = s.executeQuery("SELECT id, trip_type FROM trips ORDER BY id DESC LIMIT 5");
            while (rs.next()) {
                System.out.println("Trip #" + rs.getInt("id") + " | trip_type=" + rs.getString("trip_type"));
            }
            rs.close();
            
            s.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
