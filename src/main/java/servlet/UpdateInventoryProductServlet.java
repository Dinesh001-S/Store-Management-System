package servlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import java.io.IOException;

import model.Inventory;
import dao.InventoryDao;

public class UpdateInventoryProductServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
	
		try {
			int productId = Integer.parseInt(request.getParameter("productId"));
			String productName = request.getParameter("productName");
			double price = Double.parseDouble(request.getParameter("price"));
			int units = Integer.parseInt(request.getParameter("units"));
			int categoryId = Integer.parseInt(request.getParameter("categoryId"));
			
			InventoryDao inventoryDao = new InventoryDao();
			int result = inventoryDao.editProduct(new Inventory(productId, productName, price , units, categoryId));
	
			response.sendRedirect("updateProductsInInventory.jsp?result="+result+"&productId="+productId);
		}
		catch(NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("updateProductsInInventory.jsp?result="+-2+"&productId="+Integer.parseInt(request.getParameter("productId")));
		}
	}
}
