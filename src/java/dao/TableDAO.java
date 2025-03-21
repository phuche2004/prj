// TableDAO.java
package dao;

import model.Table;
import utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {
    
    /**
     * Retrieves all restaurant tables from the database.
     * 
     * @return List of Table objects with their current status
     * @throws SQLException if a database access error occurs
     */
    public List<Table> getAllTables() throws SQLException {
        List<Table> tables = new ArrayList<>();
        String query = "SELECT t.TableID, t.Description, " +
                      "(SELECT TOP 1 o.Status FROM Orders o WHERE o.TableID = t.TableID AND " +
                      "o.Status IN ('Pending', 'Preparing', 'Served') ORDER BY o.OrderDateTime DESC) AS CurrentStatus, " +
                      "(SELECT TOP 1 o.OrderID FROM Orders o WHERE o.TableID = t.TableID AND " +
                      "o.Status IN ('Pending', 'Preparing', 'Served') ORDER BY o.OrderDateTime DESC) AS ActiveOrderID " +
                      "FROM Tables t ORDER BY t.TableID";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("TableID"));
                table.setDescription(rs.getString("Description"));
                
                // Get active order status
                String status = rs.getString("CurrentStatus");
                if (status != null) {
                    table.setStatus(status);
                    table.setHasActiveOrder(true);
                    table.setActiveOrderId(rs.getInt("ActiveOrderID"));
                } else {
                    table.setStatus("Available");
                    table.setHasActiveOrder(false);
                }
                
                tables.add(table);
            }
        }
        
        return tables;
    }
}