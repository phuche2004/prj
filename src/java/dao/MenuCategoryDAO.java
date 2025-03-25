package dao;

import model.MenuCategory;
import utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuCategoryDAO {
    
    // Get all menu categories
    public List<MenuCategory> getAllCategories() throws SQLException {
        List<MenuCategory> categories = new ArrayList<>();
        String query = "SELECT CategoryID, CategoryName FROM MenuCategories ORDER BY CategoryID";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                MenuCategory category = new MenuCategory();
                category.setCategoryId(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        }
        
        return categories;
    }
    
    // Add a new category
    public int addCategory(String categoryName) throws SQLException {
        String query = "INSERT INTO MenuCategories (CategoryName) VALUES (?); SELECT SCOPE_IDENTITY() AS CategoryID";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, categoryName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CategoryID");
                }
            }
        }
        
        return -1;
    }
    
    // Update a category
    public void updateCategory(int categoryId, String categoryName) throws SQLException {
        String query = "UPDATE MenuCategories SET CategoryName = ? WHERE CategoryID = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, categoryName);
            stmt.setInt(2, categoryId);
            stmt.executeUpdate();
        }
    }
    
    // Delete a category
    public void deleteCategory(int categoryId) throws SQLException {
        String query = "DELETE FROM MenuCategories WHERE CategoryID = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, categoryId);
            stmt.executeUpdate();
        }
    }
}