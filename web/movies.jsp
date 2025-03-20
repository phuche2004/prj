<%@ page import="model.Movie" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movies</title>
</head>
<body>
    <h1>Movie List</h1>
    <%
        List<Movie> movies = (List<Movie>) request.getAttribute("movies");
        if (movies == null || movies.isEmpty()) {
            out.println("<p>No movies found</p>");
        } else {
    %>
    <table border="1">
        <tr>
            <th>Title</th>
            <th>Director</th>
            <th>Release Date</th>
            <th>Duration</th>
            <th>Ticket Price</th>
        </tr>
        <%
            for (Movie movie : movies) {
        %>
        <tr>
            <td><%= movie.getTitle() %></td>
            <td><%= movie.getDirector() %></td>
            <td><%= movie.getReleaseDate() %></td>
            <td><%= movie.getDuration() %> minutes</td>
            <td>$<%= movie.getTicketPrice() %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        }
    %>
    <%
        if (session.getAttribute("user") != null) {
            out.println("<p><a href='bookings.jsp'>View Bookings</a></p>");
        } else {
            out.println("<p><a href='login.jsp'>Login to book tickets</a></p>");
        }
    %>
</body>
</html>