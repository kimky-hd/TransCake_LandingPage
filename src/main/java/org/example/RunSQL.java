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
            
            ResultSet rs = s.executeQuery("DESCRIBE users");
            while (rs.next()) {
                System.out.println(rs.getString("Field") + " | " + rs.getString("Type") + " | Null: " + rs.getString("Null") + " | Key: " + rs.getString("Key") + " | Default: " + rs.getString("Default") + " | Extra: " + rs.getString("Extra"));
            }
            rs.close();
            
            s.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
