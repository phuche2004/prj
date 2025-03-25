// Order.java
package model;

import java.util.Date;
import java.util.List;

public class Order {
    private int orderId;
    private int tableId;
    private Date orderDateTime;
    private String status;
    private double totalAmount;
    private List<OrderItem> orderItems;
    
    // Constructors
    public Order() {}
    
    public Order(int orderId, int tableId, Date orderDateTime, String status, double totalAmount) {
        this.orderId = orderId;
        this.tableId = tableId;
        this.orderDateTime = orderDateTime;
        this.status = status;
        this.totalAmount = totalAmount;
    }
    
    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }
    
    public Date getOrderDateTime() { return orderDateTime; }
    public void setOrderDateTime(Date orderDateTime) { this.orderDateTime = orderDateTime; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public List<OrderItem> getOrderItems() { return orderItems; }
    public void setOrderItems(List<OrderItem> orderItems) { this.orderItems = orderItems; }
}