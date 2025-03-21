-- Create database
CREATE DATABASE RestaurantOrderSystem;
GO

USE RestaurantOrderSystem;
GO

-- Create Tables table for the 8 restaurant tables
CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    Description NVARCHAR(50)
);
GO

-- Create MenuCategories table
CREATE TABLE MenuCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL
);
GO

-- Create MenuItems table
CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT FOREIGN KEY REFERENCES MenuCategories(CategoryID),
    ItemName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL,
    IsAvailable BIT DEFAULT 1
);
GO

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    TableID INT FOREIGN KEY REFERENCES Tables(TableID),
    OrderDateTime DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Preparing, Served, Paid
    TotalAmount DECIMAL(10, 2) DEFAULT 0
);
GO

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ItemID INT FOREIGN KEY REFERENCES MenuItems(ItemID),
    Quantity INT NOT NULL,
    Notes NVARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL
);
GO

-- Insert data for the 8 tables
INSERT INTO Tables (TableID, Description)
VALUES
(1, 'Table 1'), (2, 'Table 2'), (3, 'Table 3'), (4, 'Table 4'),
(5, 'Table 5'), (6, 'Table 6'), (7, 'Table 7'), (8, 'Table 8');
GO

-- Insert menu categories
INSERT INTO MenuCategories (CategoryName)
VALUES ('Appetizers'), ('Main Courses'), ('Desserts'), ('Beverages');
GO

-- Insert sample menu items
INSERT INTO MenuItems (CategoryID, ItemName, Description, Price)
VALUES
-- Appetizers
(1, 'Spring Rolls', 'Fresh vegetables wrapped in rice paper', 5.99),
(1, 'Chicken Wings', 'Spicy buffalo chicken wings with dipping sauce', 8.99),
-- Main Courses
(2, 'Grilled Salmon', 'Atlantic salmon with lemon and herbs', 18.99),
(2, 'Beef Steak', 'Premium beef with vegetables', 22.99),
-- Desserts
(3, 'Chocolate Cake', 'Rich chocolate cake with vanilla ice cream', 6.99),
-- Beverages
(4, 'Soft Drink', 'Cola, Sprite, or Fanta', 2.99),
(4, 'Fresh Juice', 'Orange, apple, or carrot juice', 4.99);
GO

-- Create Admin credentials table
CREATE TABLE AdminUser (
    Username NVARCHAR(50) PRIMARY KEY,
    Password NVARCHAR(100) NOT NULL
);
GO

-- Insert default admin (username: admin, password: admin123)
INSERT INTO AdminUser (Username, Password)
VALUES ('admin', 'admin123');
GO