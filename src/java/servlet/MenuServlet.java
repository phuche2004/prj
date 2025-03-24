/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.MenuItemDAO;
import dao.OrderDAO;
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
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.MenuCategory;
import model.MenuItem;
import model.Order;

/**
 *
 * @author PhucHe
 */
@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {

    private MenuItemDAO menuItemDAO = new MenuItemDAO();
    private OrderDAO orderDAO = new OrderDAO();

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
            out.println("<title>Servlet MenuServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MenuServlet at " + request.getContextPath() + "</h1>");
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
        Integer tableId = (Integer) session.getAttribute("tableId");

        // Check if user is logged in
        if (tableId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get menu items by category
            Map<MenuCategory, List<MenuItem>> menuMap = menuItemDAO.getMenuItemsByCategory();
            request.setAttribute("menuMap", menuMap);

            // Check if there's an active order for this table
            Order activeOrder = orderDAO.getActiveOrderByTableId(tableId);
            request.setAttribute("activeOrder", activeOrder);

            // Forward to menu page
            request.getRequestDispatcher("/WEB-INF/views/menu.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading menu", e);
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
        Integer tableId = (Integer) session.getAttribute("tableId");

        // Check if user is logged in
        if (tableId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get or create an order for this table
            Order activeOrder = orderDAO.getActiveOrderByTableId(tableId);
            int orderId;

            if (activeOrder == null) {
                // Create a new order
                orderId = orderDAO.createOrder(tableId);
                if (orderId == -1) {
                    throw new ServletException("Failed to create order");
                }
            } else {
                orderId = activeOrder.getOrderId();
            }

            // Add the order item
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            orderDAO.addOrderItem(orderId, itemId, quantity, notes);

            // Redirect back to menu with a success message
            session.setAttribute("message", "Item added to your order!");
            response.sendRedirect(request.getContextPath() + "/menu");
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Error processing order", e);
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
