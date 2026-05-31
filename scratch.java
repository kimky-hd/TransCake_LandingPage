import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class scratch {
    public static void main(String[] args) {
        String urlDefault = "jdbc:mysql://mysql-176eb8b1-transcakedb.l.aivencloud.com:14573/defaultdb?sslMode=REQUIRED";
        String urlTrans = "jdbc:mysql://mysql-176eb8b1-transcakedb.l.aivencloud.com:14573/transcake_db?sslMode=REQUIRED";
        String user = "avnadmin";
        String pass = "AVNS_a1YoOo_Zsz5rxRi40F2";

        System.out.println("Testing defaultdb...");
        try {
            Connection c = DriverManager.getConnection(urlDefault, user, pass);
            Statement s = c.createStatement();
            ResultSet rs = s.executeQuery("SHOW TABLES");
            while(rs.next()) {
                System.out.println("Table in defaultdb: " + rs.getString(1));
            }
            c.close();
            System.out.println("defaultdb SUCCESS\n");
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Testing transcake_db...");
        try {
            Connection c = DriverManager.getConnection(urlTrans, user, pass);
            Statement s = c.createStatement();
            ResultSet rs = s.executeQuery("SHOW TABLES");
            while(rs.next()) {
                System.out.println("Table in transcake_db: " + rs.getString(1));
            }
            c.close();
            System.out.println("transcake_db SUCCESS");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
