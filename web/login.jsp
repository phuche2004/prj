<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <button type="submit">Login</button>
    </form>
    <p>Don't have an account? <a href="register.jsp">Register</a></p>
    <%
        if (request.getParameter("error") != null) {
            out.println("<p style='color:red;'>Invalid username or password</p>");
        }
    %>
</body>
</html>