<%-- /WEB-INF/views/login.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Ordering System - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            width: 100%;
            max-width: 400px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .logo {
            max-width: 120px;
            margin-bottom: 15px;
        }
        h1 {
            font-size: 22px;
            margin-bottom: 15px;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            text-transform: uppercase;
            transition: background 0.3s ease;
        }
        .btn-login {
            background-color: #4CAF50;
            color: white;
            margin-top: 10px;
            position: relative;
        }
        .btn-login:hover {
            background-color: #45a049;
        }
        .btn-login span {
            display: block;
            font-size: 12px;
            font-weight: normal;
            opacity: 0.8;
        }
        .btn-admin {
            width: 93%;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            display: block;
            text-align: center;
            padding: 15px;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            text-transform: uppercase;
            margin-top: 10px;
            transition: background 0.3s ease;
        }
        .btn-admin:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="images/logo.png" alt="Restaurant Logo" class="logo">
        <h1>Welcome to Our Restaurant Ordering System</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="login" method="post">
            <div class="form-group">
                <label for="tableNumber">Table Number:</label>
                <input type="text" id="tableNumber" name="tableNumber" placeholder="Enter your table number (1-8)" required>
            </div>
            <button type="submit" class="btn-login">
                Enter your table number to access the menu.
            </button>
        </form>

        <a href="admin/login" class="btn-admin">Admin Login</a>
    </div>
</body>
</html>
