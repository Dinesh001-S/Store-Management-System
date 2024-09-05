package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.InventoryDao;

public class ProductPriceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");

        try {
            int productId = Integer.parseInt(productIdStr);
            InventoryDao inventoryDao = new InventoryDao();
            double price = inventoryDao.getProductPrice(productId);
            response.setContentType("application/json");
            response.getWriter().println("{\"price\":" + price + "}");
        }
        catch (NumberFormatException e) {
            response.getWriter().println("Invalid Product ID");
        }
        catch (Exception e) {
            response.getWriter().println("Error");
        }
    }
}
