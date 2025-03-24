// DatabaseConnection.java
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // SQL Server connection details
    private static final String JDBC_URL = "jdbc:sqlserver://localhost:1433;databaseName=RestaurantOrderSystem";
    private static final String JDBC_USER = "sa"; // Replace with your SQL Server username
    private static final String JDBC_PASSWORD = "123"; // Replace with your SQL Server password
    
    static {
        try {
            // Load SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    // Get database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}