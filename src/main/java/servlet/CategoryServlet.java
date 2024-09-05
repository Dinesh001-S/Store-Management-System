package servlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import java.io.IOException;
import java.util.List;

import dao.CategoryDao;
import dao.InventoryDao;
import model.Category;

public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		CategoryDao categoryDao = new CategoryDao();
		
		List<Category> categories = categoryDao.getAllCategory();
		request.setAttribute("categories", categories);
        request.getRequestDispatcher("viewBill.jsp").forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));
		String Category = request.getParameter("newCategory");
		
		InventoryDao inventoryDao = new InventoryDao();
		int outcome = inventoryDao.addNewCategory(categoryId, Category);
		
		if(outcome == 2) {
			response.sendRedirect("Inventory.jsp"+2);
		}
		else if(outcome != -1) 
		{
			response.sendRedirect("Inventory.jsp"+-1);
		}
		else {
			response.sendRedirect("Inventory.jsp"+-2);
		}
	}
}