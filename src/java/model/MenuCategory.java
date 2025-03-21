// MenuCategory.java
package model;

public class MenuCategory {
    private int categoryId;
    private String categoryName;
    
    // Constructors
    public MenuCategory() {}
    
    public MenuCategory(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }
    
    // Getters and Setters
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}