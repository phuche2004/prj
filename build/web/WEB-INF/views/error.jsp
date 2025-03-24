<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - Restaurant Ordering System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h1 {
            color: #d9534f;
        }
        .error-details {
            margin: 20px 0;
            padding: 15px;
            background-color: #f2dede;
            border-radius: 4px;
            color: #a94442;
            text-align: left;
        }
        .back-link {
            margin-top: 20px;
        }
        .back-link a {
            color: #4CAF50;
            text-decoration: none;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Error Occurred</h1>
        <p>Sorry, an error occurred while processing your request.</p>
        
        <% if (exception != null) { %>
            <div class="error-details">
                <strong>Error Details:</strong>
                <p><%= exception.getMessage() %></p>
            </div>
        <% } %>
        
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/login">Return to Login</a>
        </div>
    </div>
</body>
</html>