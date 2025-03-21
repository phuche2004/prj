/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.OrderDAO;
import dao.TableDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.Table;

/**
 *
 * @author PhucHe
 */
@WebServlet(name = "AdminOdersServlet", urlPatterns = {"/admin/orders"})
public class AdminOdersServlet extends HttpServlet {


    private OrderDAO orderDAO = new OrderDAO();
    private TableDAO tableDAO = new TableDAO();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminOdersServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminOdersServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean adminLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
        
        // Check if admin is logged in
        if (adminLoggedIn == null || !adminLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        try {
            // Get all tables with their status
            List<Table> tables = tableDAO.getAllTables();
            request.setAttribute("tables", tables);
            
            // Get all orders
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
            
            // Get selected order ID if any
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                int selectedOrderId = Integer.parseInt(orderIdParam);
                request.setAttribute("selectedOrderId", selectedOrderId);
            }
            
            // Forward to admin orders page
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading tables or orders", e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         HttpSession session = request.getSession();
        Boolean adminLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
        
        // Check if admin is logged in
        if (adminLoggedIn == null || !adminLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Update order status
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            orderDAO.updateOrderStatus(orderId, status);
            
            // Redirect back to orders with a success message
            session.setAttribute("message", "Order status updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Error updating order", e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
