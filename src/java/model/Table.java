// Table.java
package model;

public class Table {
    private int tableId;
    private String description;
    private String status; // Available, Pending, Preparing, Served
    private boolean hasActiveOrder;
    private int activeOrderId;
    
    /**
     * Default constructor
     */
    public Table() {
    }
    
    /**
     * Constructs a table with the specified properties
     */
    public Table(int tableId, String description) {
        this.tableId = tableId;
        this.description = description;
        this.status = "Available";
        this.hasActiveOrder = false;
    }
    
    // Getters and Setters
    public int getTableId() {
        return tableId;
    }
    
    public void setTableId(int tableId) {
        this.tableId = tableId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isHasActiveOrder() {
        return hasActiveOrder;
    }
    
    public void setHasActiveOrder(boolean hasActiveOrder) {
        this.hasActiveOrder = hasActiveOrder;
    }
    
    public int getActiveOrderId() {
        return activeOrderId;
    }
    
    public void setActiveOrderId(int activeOrderId) {
        this.activeOrderId = activeOrderId;
    }
}