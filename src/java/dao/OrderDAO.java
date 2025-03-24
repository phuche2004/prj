// OrderDAO.java
package dao;

import model.Order;
import model.OrderItem;
import model.MenuItem;
import utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    private MenuItemDAO menuItemDAO = new MenuItemDAO();
    
    // Create a new order for a table
    public int createOrder(int tableId) throws SQLException {
        String query = "INSERT INTO Orders (TableID, OrderDateTime, Status, TotalAmount) " +
                      "VALUES (?, GETDATE(), 'Pending', 0); SELECT SCOPE_IDENTITY() AS OrderID";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, tableId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("OrderID");
                }
            }
        }
        
        return -1;
    }
    
    // Add an item to an order
    public void addOrderItem(int orderId, int itemId, int quantity, String notes) throws SQLException {
        // First, get the menu item to get the price
        MenuItem item = menuItemDAO.getMenuItemById(itemId);
        if (item == null) {
            throw new SQLException("Menu item not found");
        }
        
        String query = "INSERT INTO OrderItems (OrderID, ItemID, Quantity, Notes, Price) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, orderId);
            stmt.setInt(2, itemId);
            stmt.setInt(3, quantity);
            stmt.setString(4, notes);
            stmt.setDouble(5, item.getPrice() * quantity);
            
            stmt.executeUpdate();
            
            // Update the total amount in the order
            updateOrderTotal(orderId, conn);
        }
    }
    
    // Update order total amount
    private void updateOrderTotal(int orderId, Connection conn) throws SQLException {
        String query = "UPDATE Orders SET TotalAmount = " +
                      "(SELECT SUM(Price) FROM OrderItems WHERE OrderID = ?) " +
                      "WHERE OrderID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }
    
    // Get all orders (for admin)
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT OrderID, TableID, OrderDateTime, Status, TotalAmount FROM Orders ORDER BY OrderDateTime DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("OrderID"));
                order.setTableId(rs.getInt("TableID"));
                order.setOrderDateTime(rs.getTimestamp("OrderDateTime"));
                order.setStatus(rs.getString("Status"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                
                // Get order items for this order
                order.setOrderItems(getOrderItemsByOrderId(order.getOrderId()));
                
                orders.add(order);
            }
        }
        
        return orders;
    }
    
    // Get order items by order ID
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT oi.OrderItemID, oi.OrderID, oi.ItemID, oi.Quantity, oi.Notes, oi.Price " +
                      "FROM OrderItems oi WHERE oi.OrderID = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("OrderItemID"));
                    item.setOrderId(rs.getInt("OrderID"));
                    item.setItemId(rs.getInt("ItemID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setNotes(rs.getString("Notes"));
                    item.setPrice(rs.getDouble("Price"));
                    
                    // Get the menu item details
                    item.setMenuItem(menuItemDAO.getMenuItemById(item.getItemId()));
                    
                    items.add(item);
                }
            }
        }
        
        return items;
    }
    
    // Update order status
    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String query = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }
    
    // Get active order for a table
    public Order getActiveOrderByTableId(int tableId) throws SQLException {
        String query = "SELECT OrderID, TableID, OrderDateTime, Status, TotalAmount " +
                      "FROM Orders WHERE TableID = ? AND Status IN ('Pending', 'Preparing') " +
                      "ORDER BY OrderDateTime DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, tableId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("OrderID"));
                    order.setTableId(rs.getInt("TableID"));
                    order.setOrderDateTime(rs.getTimestamp("OrderDateTime"));
                    order.setStatus(rs.getString("Status"));
                    order.setTotalAmount(rs.getDouble("TotalAmount"));
                    
                    // Get order items for this order
                    order.setOrderItems(getOrderItemsByOrderId(order.getOrderId()));
                    
                    return order;
                }
            }
        }
        
        return null;
    }
}