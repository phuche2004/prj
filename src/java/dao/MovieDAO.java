package dao;


import model.Movie;
import util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM Movies";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Movie movie = new Movie();
                movie.setId(rs.getInt("id"));
                movie.setTitle(rs.getString("title"));
                movie.setDirector(rs.getString("director"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setDuration(rs.getInt("duration"));
                movie.setTicketPrice(rs.getDouble("ticketPrice"));
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }
    public static void main(String[] args) {
        MovieDAO d = new MovieDAO();
        List<Movie> m = d.getAllMovies();
        for (Movie movie : m) {
            System.out.println("ID: " + movie.getId());
            System.out.println("Title: " + movie.getTitle());
            System.out.println("Director: " + movie.getDirector());
            System.out.println("Release Date: " + movie.getReleaseDate());
            System.out.println("Duration: " + movie.getDuration() + " minutes");
            System.out.println("Ticket Price: $" + movie.getTicketPrice());
            System.out.println("-----------------------------");
        }
    }
}