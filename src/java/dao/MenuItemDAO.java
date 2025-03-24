// MenuItemDAO.java
package dao;

import model.MenuItem;
import model.MenuCategory;
import utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class MenuItemDAO {
    
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
    
    // Get menu items organized by category
    public Map<MenuCategory, List<MenuItem>> getMenuItemsByCategory() throws SQLException {
        Map<MenuCategory, List<MenuItem>> menuMap = new HashMap<>();
        List<MenuCategory> categories = getAllCategories();
        
        for (MenuCategory category : categories) {
            List<MenuItem> items = getMenuItemsByCategoryId(category.getCategoryId());
            menuMap.put(category, items);
        }
        
        return menuMap;
    }
    
    // Get menu items by category ID
    public List<MenuItem> getMenuItemsByCategoryId(int categoryId) throws SQLException {
        List<MenuItem> items = new ArrayList<>();
        String query = "SELECT ItemID, CategoryID, ItemName, Description, Price, IsAvailable " +
                      "FROM MenuItems WHERE CategoryID = ? AND IsAvailable = 1 ORDER BY ItemName";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MenuItem item = new MenuItem();
                    item.setItemId(rs.getInt("ItemID"));
                    item.setCategoryId(rs.getInt("CategoryID"));
                    item.setItemName(rs.getString("ItemName"));
                    item.setDescription(rs.getString("Description"));
                    item.setPrice(rs.getDouble("Price"));
                    item.setAvailable(rs.getBoolean("IsAvailable"));
                    items.add(item);
                }
            }
        }
        
        return items;
    }
    
    // Get menu item by ID
    public MenuItem getMenuItemById(int itemId) throws SQLException {
        String query = "SELECT ItemID, CategoryID, ItemName, Description, Price, IsAvailable " +
                      "FROM MenuItems WHERE ItemID = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, itemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    MenuItem item = new MenuItem();
                    item.setItemId(rs.getInt("ItemID"));
                    item.setCategoryId(rs.getInt("CategoryID"));
                    item.setItemName(rs.getString("ItemName"));
                    item.setDescription(rs.getString("Description"));
                    item.setPrice(rs.getDouble("Price"));
                    item.setAvailable(rs.getBoolean("IsAvailable"));
                    return item;
                }
            }
        }
        
        return null;
    }
     public static void main(String[] args) {
        System.out.println("Hệ Thống Quản Lý Nhà Hàng");
        System.out.println("===========================");
        
        MenuItemDAO menuItemDAO = new MenuItemDAO();
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        
        try {
            // Hiển thị tất cả các danh mục
            List<MenuCategory> categories = menuItemDAO.getAllCategories();
            System.out.println("\nDANH SÁCH DANH MỤC:");
            System.out.println("---------------------------");
            System.out.printf("%-5s | %-30s\n", "ID", "Tên Danh Mục");
            System.out.println("---------------------------");
            
            for (MenuCategory category : categories) {
                System.out.printf("%-5d | %-30s\n", 
                    category.getCategoryId(), 
                    category.getCategoryName());
            }
            
            // Hiển thị menu theo danh mục
            System.out.println("\nMENU THEO DANH MỤC:");
            System.out.println("========================================================");
            
            Map<MenuCategory, List<MenuItem>> menuMap = menuItemDAO.getMenuItemsByCategory();
            
            for (Map.Entry<MenuCategory, List<MenuItem>> entry : menuMap.entrySet()) {
                MenuCategory category = entry.getKey();
                List<MenuItem> items = entry.getValue();
                
                System.out.println("\n" + category.getCategoryName().toUpperCase() + ":");
                System.out.println("--------------------------------------------------------");
                System.out.printf("%-5s | %-25s | %-40s | %-15s\n", 
                    "ID", "Tên Món", "Mô Tả", "Giá");
                System.out.println("--------------------------------------------------------");
                
                if (items.isEmpty()) {
                    System.out.println("Không có món ăn nào trong danh mục này");
                } else {
                    for (MenuItem item : items) {
                        System.out.printf("%-5d | %-25s | %-40s | %-15s\n", 
                            item.getItemId(), 
                            item.getItemName(), 
                            truncateString(item.getDescription(), 40), 
                            currencyFormatter.format(item.getPrice()));
                    }
                }
            }
            
            // Hiển thị thông tin chi tiết về một món ăn cụ thể
            System.out.println("\nCHI TIẾT MÓN ĂN:");
            System.out.println("========================================================");
            
            int testItemId = 1; // Thay đổi ID này nếu muốn kiểm tra món ăn khác
            MenuItem singleItem = menuItemDAO.getMenuItemById(testItemId);
            
            if (singleItem != null) {
                System.out.println("ID: " + singleItem.getItemId());
                System.out.println("Tên món: " + singleItem.getItemName());
                System.out.println("Danh mục ID: " + singleItem.getCategoryId());
                System.out.println("Mô tả: " + singleItem.getDescription());
                System.out.println("Giá: " + currencyFormatter.format(singleItem.getPrice()));
                System.out.println("Tình trạng: " + (singleItem.isAvailable() ? "Còn hàng" : "Hết hàng"));
            } else {
                System.out.println("Không tìm thấy món ăn có ID = " + testItemId);
            }
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi truy vấn dữ liệu: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Cắt ngắn chuỗi nếu quá dài để hiển thị đẹp hơn
     */
    private static String truncateString(String str, int maxLength) {
        if (str == null) {
            return "";
        }
        
        if (str.length() <= maxLength) {
            return str;
        }
        
        return str.substring(0, maxLength - 3) + "...";
    }
}