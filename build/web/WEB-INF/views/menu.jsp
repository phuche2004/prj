<%-- /WEB-INF/views/menu.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MenuCategory" %>
<%@ page import="model.MenuItem" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderItem" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Restaurant Menu</title>
        <style>
            .menu-item {
                display: flex;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            .menu-item-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 5px;
                margin-right: 15px;
            }
            .menu-item-content {
                flex: 1;
            }
            .menu-item-image-container {
                flex-shrink: 0;
            }
            .default-image {
                background-color: #f1f1f1;
                display: flex;
                justify-content: center;
                align-items: center;
                color: #999;
                font-size: 12px;
            }
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
            }
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: rgba(255, 255, 255, 0.9);
                padding: 15px 25px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .header h1 {
                font-size: 32px;
                font-weight: bold;
                color: #fff;
                background-color: #4CAF50;
                padding: 10px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                display: inline-block;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 10px rgba(76, 175, 80, 0.8);
            }

            .header div {
                font-size: 16px;
                color: #555;
                margin-left: 15px;
            }

            .header div:first-child {
                font-weight: bold;
            }

            @media (max-width: 768px) {
                .header {
                    flex-direction: column;
                    text-align: center;
                }

                .header div {
                    margin: 5px 0;
                }
            }
            h1, h2, h3 {
                color: #333;
            }
            .category {
                background-color: white;
                margin-bottom: 20px;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .menu-item {
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            .menu-item:last-child {
                border-bottom: none;
            }
            .item-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
            }
            .item-name {
                font-weight: bold;
                font-size: 18px;
            }
            .item-price {
                font-weight: bold;
                color: #4CAF50;
            }
            .item-description {
                color: #666;
                margin-bottom: 10px;
            }
            .add-form {
                display: flex;
                align-items: center;
            }
            .add-form input[type="number"] {
                width: 60px;
                padding: 5px;
                margin-right: 10px;
            }
            .add-form input[type="text"] {
                flex-grow: 1;
                padding: 5px;
                margin-right: 10px;
            }

            <%-- Continuing /WEB-INF/views/menu.jsp --%>
            .add-form input[type="text"] {
                flex-grow: 1;
                padding: 5px;
                margin-right: 10px;
            }
            .add-button {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }
            .add-button:hover {
                background-color: #45a049;
            }
            .success {
                background-color: #dff0d8;
                color: #3c763d;
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .current-order {
                background-color: #f9f9f9;
                margin-bottom: 20px;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .order-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }
            .order-total {
                text-align: right;
                font-weight: bold;
                margin-top: 10px;
                font-size: 18px;
            }
            .logout {
                text-align: right;
                margin-top: 20px;
            }
            .logout a {
                color: #4CAF50;
                text-decoration: none;
            }
            .logout a:hover {
                text-decoration: underline;
            }
            .tabs {
                display: flex;
                margin-bottom: 20px;
            }
            .tab {
                padding: 10px 20px;
                background-color: #f1f1f1;
                border: none;
                cursor: pointer;
                margin-right: 5px;
                border-radius: 5px 5px 0 0;
            }
            .tab.active {
                background-color: white;
                border-bottom: 2px solid #4CAF50;
            }
            .tab-content {
                display: none;
            }
            .tab-content.active {
                display: block;
            }

            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-image: url('<%= request.getContextPath()%>/images/background.jpg');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                background-repeat: no-repeat;
            }

        </style>
        <script>
            function showTab(tabId) {
                // Hide all tab contents
                var tabContents = document.getElementsByClassName('tab-content');
                for (var i = 0; i < tabContents.length; i++) {
                    tabContents[i].classList.remove('active');
                }

                // Deactivate all tabs
                var tabs = document.getElementsByClassName('tab');
                for (var i = 0; i < tabs.length; i++) {
                    tabs[i].classList.remove('active');
                }

                // Show the selected tab content and activate the tab
                document.getElementById(tabId).classList.add('active');
                document.getElementById('tab-' + tabId).classList.add('active');
            }
        </script>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Restaurant Menu</h1>
                <div>Welcome, <%= session.getAttribute("customerName")%>!</div>
                <div>Phone: <%= session.getAttribute("phoneNumber")%></div>
                <div>Table Number: <%= session.getAttribute("tableId")%></div>
            </div>

            <% if (session.getAttribute("message") != null) {%>
            <div class="success">
                <%= session.getAttribute("message")%>
                <% session.removeAttribute("message"); %>
            </div>
            <% } %>

            <%
                Order activeOrder = (Order) request.getAttribute("activeOrder");
                if (activeOrder != null && !activeOrder.getOrderItems().isEmpty()) {
            %>
            <div class="current-order">
                <h2>Your Current Order</h2>

                <% for (OrderItem item : activeOrder.getOrderItems()) {%>
                <div class="order-item">
                    <div>
                        <strong><%= item.getQuantity()%> x <%= item.getMenuItem().getItemName()%></strong>
                        <% if (item.getNotes() != null && !item.getNotes().isEmpty()) {%>
                        <div><em>Notes: <%= item.getNotes()%></em></div>
                        <% }%>
                    </div>
                    <div>$<%= String.format("%.2f", item.getPrice())%></div>
                </div>
                <% }%>

                <div class="order-total">
                    Total: $<%= String.format("%.2f", activeOrder.getTotalAmount())%>
                </div>

            </div>
            <% } %>

            <div class="tabs">
                <%
                    Map<MenuCategory, List<MenuItem>> menuMap = (Map<MenuCategory, List<MenuItem>>) request.getAttribute("menuMap");
                    int categoryCounter = 0;
                    for (MenuCategory category : menuMap.keySet()) {
                        boolean isActive = categoryCounter == 0;
                        categoryCounter++;
                %>
                <button id="tab-category<%= category.getCategoryId()%>" class="tab <%= isActive ? "active" : ""%>" 
                        onclick="showTab('category<%= category.getCategoryId()%>')">
                    <%= category.getCategoryName()%>
                </button>
                <% } %>
            </div>

            <%
                categoryCounter = 0;
                for (Map.Entry<MenuCategory, List<MenuItem>> entry : menuMap.entrySet()) {
                    MenuCategory category = entry.getKey();
                    List<MenuItem> items = entry.getValue();
                    boolean isActive = categoryCounter == 0;
                    categoryCounter++;
            %>
            <div id="category<%= category.getCategoryId()%>" class="tab-content <%= isActive ? "active" : ""%>">
                <div class="category">
                    <h2><%= category.getCategoryName()%></h2>

                    <% for (MenuItem item : items) { %>
<div class="menu-item">
    <div class="menu-item-image-container">
        <% if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) { %>
            <img src="<%= request.getContextPath() %>/<%= item.getImageUrl() %>" alt="<%= item.getItemName() %>" class="menu-item-image">
        <% } else { %>
            <div class="menu-item-image default-image">No Image</div>
        <% } %>
    </div>
    <div class="menu-item-content">
        <div class="item-header">
            <div class="item-name"><%= item.getItemName() %></div>
            <div class="item-price">$<%= String.format("%.2f", item.getPrice()) %></div>
        </div>
        <div class="item-description"><%= item.getDescription() %></div>

        <form class="add-form" action="menu" method="post">
            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
            <input type="number" name="quantity" value="1" min="1" max="10" required>
            <input type="text" name="notes" placeholder="Any special requests?">
            <button type="submit" class="add-button">Add to Order</button>
        </form>
    </div>
</div>
<% } %>
                </div>
            </div>
            <% }%>
            <div class="logout">
                <a href="${pageContext.request.contextPath}/login">Exit</a>
            </div>
        </div>
    </body>
</html>