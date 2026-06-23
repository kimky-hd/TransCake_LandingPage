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
            
            // Check completed trips
            System.out.println("=== COMPLETED TRIPS ===");
            ResultSet rs = s.executeQuery(
                "SELECT id, driver_id, passenger_id, price, distance, completion_status, completed_at, created_at " +
                "FROM trips WHERE completion_status = 'COMPLETED' ORDER BY id DESC LIMIT 10"
            );
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("Trip #" + rs.getInt("id") + 
                    " | driver=" + rs.getInt("driver_id") + 
                    " | price=" + rs.getDouble("price") + 
                    " | distance=" + rs.getDouble("distance") +
                    " | completed_at=" + rs.getTimestamp("completed_at") +
                    " | created_at=" + rs.getTimestamp("created_at"));
            }
            System.out.println("Total completed trips found: " + count);
            rs.close();
            
            // Check schema for completed_at column
            System.out.println("\n=== COLUMN CHECK ===");
            ResultSet rs2 = s.executeQuery(
                "SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_NAME = 'trips' AND COLUMN_NAME = 'completed_at'"
            );
            if (rs2.next()) {
                System.out.println("completed_at column exists, type: " + rs2.getString("DATA_TYPE"));
            } else {
                System.out.println("WARNING: completed_at column NOT FOUND!");
            }
            rs2.close();
            
            // Check all trips for a summary
            System.out.println("\n=== ALL TRIPS STATUS SUMMARY ===");
            ResultSet rs3 = s.executeQuery(
                "SELECT completion_status, COUNT(*) as cnt, COALESCE(SUM(price),0) as total_price " +
                "FROM trips GROUP BY completion_status"
            );
            while (rs3.next()) {
                System.out.println("Status: " + rs3.getString("completion_status") + 
                    " | Count: " + rs3.getInt("cnt") + 
                    " | Total Price: " + rs3.getDouble("total_price"));
            }
            rs3.close();
            
            s.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
