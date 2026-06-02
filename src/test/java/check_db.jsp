<%@ page import="org.example.utils.DBContext" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>DB Check</title></head>
<body>
<%
    try (Connection conn = DBContext.getConnection();
         Statement stmt = conn.createStatement()) {
        ResultSet rs = stmt.executeQuery("SHOW COLUMNS FROM trips");
        out.println("<table border='1'><tr><th>Field</th><th>Type</th></tr>");
        while(rs.next()) {
            out.println("<tr><td>" + rs.getString("Field") + "</td><td>" + rs.getString("Type") + "</td></tr>");
        }
        out.println("</table>");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
</body>
</html>
