/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.MenuCategoryDAO;
import dao.MenuItemDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.MenuCategory;
import model.MenuItem;

/**
 *
 * @author PhucHe
 */
@WebServlet(name = "ProductManagementServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ProductManagementServlet extends HttpServlet {

    private MenuItemDAO menuItemDAO = new MenuItemDAO();
    private MenuCategoryDAO menuCategoryDAO = new MenuCategoryDAO();

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
            out.println("<title>Servlet ProductManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductManagementServlet at " + request.getContextPath() + "</h1>");
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
            // Get all menu items
            List<MenuItem> menuItems = menuItemDAO.getAllMenuItems();
            request.setAttribute("menuItems", menuItems);

            // Get all categories for the dropdown
            List<MenuCategory> categories = menuItemDAO.getAllCategories();
            request.setAttribute("categories", categories);

            // If edit mode, get the specific item
            String editIdParam = request.getParameter("editId");
            if (editIdParam != null && !editIdParam.isEmpty()) {
                int editId = Integer.parseInt(editIdParam);
                MenuItem itemToEdit = menuItemDAO.getMenuItemById(editId);
                request.setAttribute("itemToEdit", itemToEdit);
            }

            // Forward to products management page
            request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading menu items", e);
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

        // Check the action type
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                addMenuItem(request, response);
            } else if ("edit".equals(action)) {
                editMenuItem(request, response);
            } else if ("delete".equals(action)) {
                deleteMenuItem(request, response);
            }

            // Redirect back to products page with success message
            session.setAttribute("message", "Product " + action + "ed successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            throw new ServletException("Error managing products", e);
        }
    }

    private void addMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        double price = Double.parseDouble(request.getParameter("price"));
        boolean isAvailable = request.getParameter("isAvailable") != null;

        // Handle file upload
        String imageUrl = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Define the upload directory
            String uploadDir = getServletContext().getRealPath("/images/menu");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // Save the file
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Store relative path in database
            imageUrl = "images/menu/" + uniqueFileName;
        }

        // Create and save the menu item
        menuItemDAO.addMenuItem(categoryId, itemName, description, price, isAvailable, imageUrl);
    }

    private void editMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        double price = Double.parseDouble(request.getParameter("price"));
        boolean isAvailable = request.getParameter("isAvailable") != null;

        // Get the current item to check if we need to update the image
        MenuItem currentItem = menuItemDAO.getMenuItemById(itemId);
        String imageUrl = currentItem.getImageUrl();

        // Handle file upload if a new image is provided
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Define the upload directory
            String uploadDir = getServletContext().getRealPath("/images/menu");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // Save the file
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Store relative path in database
            imageUrl = "images/menu/" + uniqueFileName;
        }

        // Update the menu item
        menuItemDAO.updateMenuItem(itemId, categoryId, itemName, description, price, isAvailable, imageUrl);
    }

    private void deleteMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        menuItemDAO.deleteMenuItem(itemId);
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
