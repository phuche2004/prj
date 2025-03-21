<%-- /WEB-INF/views/admin/orders.jsp (updated) --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderItem" %>
<%@ page import="model.Table" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Restaurant Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h1, h2, h3 {
            color: #333;
        }
        .success {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        /* Table Layout Styles */
        .table-layout {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .restaurant-layout {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-template-rows: repeat(2, 1fr);
            gap: 15px;
            width: 100%;
            margin: 0 auto;
        }
        .table-cell {
            position: relative;
            aspect-ratio: 1/1;
            border-radius: 5px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            text-align: center;
            color: white;
            font-weight: bold;
            transition: transform 0.2s;
        }
        .table-cell:hover {
            transform: scale(1.05);
        }
        .table-available {
            background-color: #5cb85c;
        }
        .table-pending {
            background-color: #f0ad4e;
        }
        .table-preparing {
            background-color: #5bc0de;
        }
        .table-served {
            background-color: #d9534f;
        }
        .table-number {
            font-size: 24px;
            margin-bottom: 5px;
        }
        .table-status {
            font-size: 14px;
        }
        .table-selected {
            box-shadow: 0 0 0 3px #337ab7;
        }
        
        /* Order Details Styles */
        .order-card {
            background-color: white;
            margin-bottom: 20px;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .order-info span {
            margin-right: 15px;
            font-weight: bold;
        }
        .order-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
        }
        .status-pending {
            background-color: #fcf8e3;
            color: #8a6d3b;
        }
        .status-preparing {
            background-color: #d9edf7;
            color: #31708f;
        }
        .status-served {
            background-color: #dff0d8;
            color: #3c763d;
        }
        .status-paid {
            background-color: #f2dede;
            color: #a94442;
        }
        .order-items {
            margin-bottom: 15px;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .item-name {
            font-weight: bold;
        }
        .item-notes {
            font-style: italic;
            color: #666;
            font-size: 14px;
        }
        .order-actions {
            display: flex;
            justify-content: flex-end;
        }
        .order-actions form {
            margin-left: 10px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-preparing {
            background-color: #d9edf7;
            color: #31708f;
        }
        .btn-served {
            background-color: #dff0d8;
            color: #3c763d;
        }
        .btn-paid {
            background-color: #f2dede;
            color: #a94442;
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
        .refresh-btn {
            background-color: #4CAF50;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .no-orders {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
            color: #666;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
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
            font-weight: bold;
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
    </style>
    <script>
        // Function to show a specific order in the order list
        function showOrder(orderId) {
            window.location.href = "${pageContext.request.contextPath}/admin/orders?orderId=" + orderId;
        }
        
        // Function to show tab
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
            <h1>Restaurant Management System</h1>
            <a href="${pageContext.request.contextPath}/admin/orders" class="refresh-btn">Refresh</a>
        </div>
        
        <% if (session.getAttribute("message") != null) { %>
            <div class="success">
                <%= session.getAttribute("message") %>
                <% session.removeAttribute("message"); %>
            </div>
        <% } %>
        
        <div class="tabs">
            <button id="tab-table-layout" class="tab active" onclick="showTab('table-layout')">Table Layout</button>
            <button id="tab-order-list" class="tab" onclick="showTab('order-list')">Order List</button>
        </div>
        
        <!-- Table Layout Tab -->
        <div id="table-layout" class="tab-content active">
            <div class="table-layout">
                <div class="section-header">
                    <h2>Restaurant Table Layout (4x2)</h2>
                </div>
                
                <div class="restaurant-layout">
                    <% 
                        List<Table> tables = (List<Table>) request.getAttribute("tables");
                        Integer selectedOrderId = (Integer) request.getAttribute("selectedOrderId");
                        
                        for (Table table : tables) {
                            String statusClass = "table-available";
                            if (table.isHasActiveOrder()) {
                                switch (table.getStatus()) {
                                    case "Pending":
                                        statusClass = "table-pending";
                                        break;
                                    case "Preparing":
                                        statusClass = "table-preparing";
                                        break;
                                    case "Served":
                                        statusClass = "table-served";
                                        break;
                                }
                            }
                            
                            boolean isSelected = selectedOrderId != null && 
                                    table.isHasActiveOrder() && 
                                    table.getActiveOrderId() == selectedOrderId;
                    %>
                        <div class="table-cell <%= statusClass %> <%= isSelected ? "table-selected" : "" %>" 
                             <%= table.isHasActiveOrder() ? "onclick=\"showOrder(" + table.getActiveOrderId() + ")\"" : "" %>>
                            <div class="table-number"><%= table.getTableId() %></div>
                            <div class="table-status"><%= table.getStatus() %></div>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Selected Order Details -->
            <% 
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                
                if (selectedOrderId != null) {
                    for (Order order : orders) {
                        if (order.getOrderId() == selectedOrderId) {
            %>
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <span>Order #<%= order.getOrderId() %></span>
                            <span>Table #<%= order.getTableId() %></span>
                            <span>Time: <%= dateFormat.format(order.getOrderDateTime()) %></span>
                        </div>
                        <div class="order-status status-<%= order.getStatus().toLowerCase() %>">
                            <%= order.getStatus() %>
                        </div>
                    </div>
                    
                    <div class="order-items">
                        <h3>Order Items:</h3>
                        <% for (OrderItem item : order.getOrderItems()) { %>
                            <div class="order-item">
                                <div class="item-details">
                                    <div class="item-name"><%= item.getQuantity() %> x <%= item.getMenuItem().getItemName() %></div>
                                    <% if (item.getNotes() != null && !item.getNotes().isEmpty()) { %>
                                        <div class="item-notes">Notes: <%= item.getNotes() %></div>
                                    <% } %>
                                </div>
                                <div class="item-price">$<%= String.format("%.2f", item.getPrice()) %></div>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="order-total">
                        Total: $<%= String.format("%.2f", order.getTotalAmount()) %>
                    </div>
                    
                    <div class="order-actions">
                        <% if ("Pending".equals(order.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="status" value="Preparing">
                                <button type="submit" class="btn btn-preparing">Start Preparing</button>
                            </form>
                        <% } else if ("Preparing".equals(order.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="status" value="Served">
                                <button type="submit" class="btn btn-served">Mark as Served</button>
                            </form>
                        <% } else if ("Served".equals(order.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="status" value="Paid">
                                <button type="submit" class="btn btn-paid">Mark as Paid</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <%
                        break;
                    }
                }
            }
            %>
        </div>
        
        <!-- Order List Tab -->
        <div id="order-list" class="tab-content">
            <% if (orders == null || orders.isEmpty()) { %>
                <div class="no-orders">
                    <h2>No orders available</h2>
                    <p>There are currently no orders in the system.</p>
                </div>
            <% } else { %>
                <% for (Order order : orders) { %>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="order-info">
                                <span>Order #<%= order.getOrderId() %></span>
                                <span>Table #<%= order.getTableId() %></span>
                                <span>Time: <%= dateFormat.format(order.getOrderDateTime()) %></span>
                            </div>
                            <div class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                <%= order.getStatus() %>
                            </div>
                        </div>
                        
                        <div class="order-items">
                            <h3>Order Items:</h3>
                            <% for (OrderItem item : order.getOrderItems()) { %>
                                <div class="order-item">
                                    <div class="item-details">
                                        <div class="item-name"><%= item.getQuantity() %> x <%= item.getMenuItem().getItemName() %></div>
                                        <% if (item.getNotes() != null && !item.getNotes().isEmpty()) { %>
                                            <div class="item-notes">Notes: <%= item.getNotes() %></div>
                                        <% } %>
                                    </div>
                                    <div class="item-price">$<%= String.format("%.2f", item.getPrice()) %></div>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="order-total">
                            Total: $<%= String.format("%.2f", order.getTotalAmount()) %>
                        </div>
                        
                        <div class="order-actions">
                            <% if ("Pending".equals(order.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <input type="hidden" name="status" value="Preparing">
                                    <button type="submit" class="btn btn-preparing">Start Preparing</button>
                                </form>
                            <% } else if ("Preparing".equals(order.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <input type="hidden" name="status" value="Served">
                                    <button type="submit" class="btn btn-served">Mark as Served</button>
                                </form>
                            <% } else if ("Served".equals(order.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <input type="hidden" name="status" value="Paid">
                                    <button type="submit" class="btn btn-paid">Mark as Paid</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
        
        <div class="logout">
            <a href="${pageContext.request.contextPath}/login">Logout</a>
        </div>
    </div>
</body>
</html>