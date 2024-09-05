package servlet;

import model.Inventory;
import dao.InventoryDao;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import java.io.IOException;

public class AddNewProductServlet extends HttpServlet{
	private final static long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String productName = request.getParameter("productName");
		double price = Double.parseDouble(request.getParameter("price"));
		int units = Integer.parseInt(request.getParameter("units"));
		int categoryId = Integer.parseInt(request.getParameter("category"));
		
		Inventory inventory = new Inventory(productName,price,units,categoryId);
		InventoryDao inventoryDao = new InventoryDao();
		int outcome = inventoryDao.addProduct(inventory);
		if(outcome == -1) {
			response.sendRedirect("addNewProductInInventory.jsp?result="+-1);
		}
		else {
			response.sendRedirect("addNewProductInInventory.jsp?result="+1);
		}
	}
}
