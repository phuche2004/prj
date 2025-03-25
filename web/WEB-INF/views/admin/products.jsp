<%-- /WEB-INF/views/admin/products.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<%@ page import="model.MenuCategory" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin - Product Management</title>
        <style>
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

            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom:20px;
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

            /* Table styles */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }
            .data-table th, .data-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            .data-table th {
                background-color: #f5f5f5;
                font-weight: bold;
            }
            .data-table tr:hover {
                background-color: #f9f9f9;
            }

            /* Form styles */
            .form-container {
                background-color: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input[type="text"], input[type="number"], select, textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 16px;
            }
            textarea {
                height: 100px;
                resize: vertical;
            }
            .checkbox-group {
                display: flex;
                align-items: center;
            }
            .checkbox-group input {
                margin-right: 10px;
            }
            .btn {
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                font-size: 16px;
                margin-right: 10px;
            }
            .btn-primary {
                background-color: #4CAF50;
                color: white;
            }
            .btn-secondary {
                background-color: #f1f1f1;
                color: #333;
            }
            .btn-danger {
                background-color: #d9534f;
                color: white;
            }
            .btn-edit {
                background-color: #5bc0de;
                color: white;
                padding: 5px 10px;
                font-size: 14px;
            }
            .btn-delete {
                background-color: #d9534f;
                color: white;
                padding: 5px 10px;
                font-size: 14px;
            }

            /* Navigation */
            .nav-tabs {
                display: flex;
                margin-bottom: 20px;
            }
            .nav-tab {
                padding: 10px 20px;
                background-color: #f1f1f1;
                border: none;
                cursor: pointer;
                margin-right: 5px;
                border-radius: 5px 5px 0 0;
                font-weight: bold;
                text-decoration: none;
                color: #333;
            }
            .nav-tab.active, .nav-tab:hover {
                background-color: #4CAF50;
                color: white;
            }

            /* Image preview */
            .image-preview {
                max-width: 200px;
                max-height: 200px;
                margin-top: 10px;
                border: 1px solid #ddd;
                padding: 5px;
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

            /* Action buttons container */
            
        </style>
        <script>
            // Function to preview image before upload
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {
                        document.getElementById('imagePreview').src = e.target.result;
                        document.getElementById('imagePreview').style.display = 'block';
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            }

            // Function to clear form
            function clearForm() {
                document.getElementById('productForm').reset();
                document.getElementById('imagePreview').src = '';
                document.getElementById('imagePreview').style.display = 'none';
                document.getElementById('action').value = 'add';
                document.getElementById('itemId').value = '';
                document.getElementById('formTitle').textContent = 'Add New Product';
                document.getElementById('submitButton').textContent = 'Add Product';
            }

            // Function to populate form for editing
            function editProduct(itemId, categoryId, itemName, description, price, isAvailable, imageUrl) {
                document.getElementById('action').value = 'edit';
                document.getElementById('itemId').value = itemId;
                document.getElementById('categoryId').value = categoryId;
                document.getElementById('itemName').value = itemName;
                document.getElementById('description').value = description;
                document.getElementById('price').value = price;
                document.getElementById('isAvailable').checked = isAvailable === 'true';

                // Show image preview if available
                if (imageUrl && imageUrl !== '') {
                    document.getElementById('imagePreview').src = '${pageContext.request.contextPath}/' + imageUrl;
                    document.getElementById('imagePreview').style.display = 'block';
                } else {
                    document.getElementById('imagePreview').style.display = 'none';
                }

                document.getElementById('formTitle').textContent = 'Edit Product';
                document.getElementById('submitButton').textContent = 'Update Product';

                // Scroll to form
                document.getElementById('productForm').scrollIntoView();
            }
        </script>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Product Management</h1>
            </div>

            <% if (session.getAttribute("message") != null) {%>
            <div class="success">
                <%= session.getAttribute("message")%>
                <% session.removeAttribute("message"); %>
            </div>
            <% } %>

            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/admin/orders" class="nav-tab">Orders</a>
                <a href="${pageContext.request.contextPath}/admin/products" class="nav-tab active">Products</a>
            </div>

            <!-- Product Form -->
            <div class="form-container">
                <h2 id="formTitle">Add New Product</h2>
                <form id="productForm" action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="action" name="action" value="add">
                    <input type="hidden" id="itemId" name="itemId" value="">

                    <div class="form-group">
                        <label for="categoryId">Category:</label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">Select Category</option>
                            <%
                                List<MenuCategory> categories = (List<MenuCategory>) request.getAttribute("categories");
                                for (MenuCategory category : categories) {
                            %>
                            <option value="<%= category.getCategoryId()%>"><%= category.getCategoryName()%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="itemName">Product Name:</label>
                        <input type="text" id="itemName" name="itemName" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="price">Price:</label>
                        <input type="number" id="price" name="price" step="0.01" min="0" required>
                    </div>

                    <div class="form-group checkbox-group">
                        <input type="checkbox" id="isAvailable" name="isAvailable" checked>
                        <label for="isAvailable">Available</label>
                    </div>

                    <div class="form-group">
                        <label for="image">Image:</label>
                        <input type="file" id="image" name="image" accept="image/*" onchange="previewImage(this)">
                        <img id="imagePreview" src="" alt="Image Preview" class="image-preview" style="display: none;">
                    </div>

                    <div class="form-group">
                        <button type="submit" id="submitButton" class="btn btn-primary">Add Product</button>
                        <button type="button" class="btn btn-secondary" onclick="clearForm()">Clear</button>
                    </div>
                </form>
            </div>

            <!-- Products Table -->
            <div class="form-container">
                <h2>Product List</h2>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Available</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
                            for (MenuItem item : menuItems) {
                                // Find category name
                                String categoryName = "";
                                for (MenuCategory cat : categories) {
                                    if (cat.getCategoryId() == item.getCategoryId()) {
                                        categoryName = cat.getCategoryName();
                                        break;
                                    }
                                }
                        %>
                        <tr>
                            <td><%= item.getItemId()%></td>
                            <td>
                                <% if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) {%>
                                <img src="${pageContext.request.contextPath}/<%= item.getImageUrl()%>" alt="<%= item.getItemName()%>" width="50">
                                <% } else { %>
                                No Image
                                <% }%>
                            </td>
                            <td><%= item.getItemName()%></td>
                            <td><%= categoryName%></td>
                            <td>$<%= String.format("%.2f", item.getPrice())%></td>
                            <td><%= item.isAvailable() ? "Yes" : "No"%></td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn-edit" onclick="editProduct('<%= item.getItemId()%>', '<%= item.getCategoryId()%>', '<%= item.getItemName().replace("'", "\\'")%>', '<%= item.getDescription().replace("'", "\\'")%>', '<%= item.getPrice()%>', '<%= item.isAvailable()%>', '<%= item.getImageUrl() != null ? item.getImageUrl() : ""%>')">Edit</button>

                                <form action="${pageContext.request.contextPath}/admin/products" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="itemId" value="<%= item.getItemId()%>">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="logout">
                <a href="${pageContext.request.contextPath}/login">Logout</a>
            </div>
        </div>

        <!-- If there's an item to edit, populate the form -->
        <%
            MenuItem itemToEdit = (MenuItem) request.getAttribute("itemToEdit");
            if (itemToEdit != null) {
        %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                editProduct(
                        '<%= itemToEdit.getItemId()%>',
                        '<%= itemToEdit.getCategoryId()%>',
                        '<%= itemToEdit.getItemName().replace("'", "\\'")%>',
                        '<%= itemToEdit.getDescription().replace("'", "\\'")%>',
                        '<%= itemToEdit.getPrice()%>',
                        '<%= itemToEdit.isAvailable()%>',
                        '<%= itemToEdit.getImageUrl() != null ? itemToEdit.getImageUrl() : ""%>'
                        );
            });
        </script>
        <% }%>
    </body>
</html>