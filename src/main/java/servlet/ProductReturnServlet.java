package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ProductDao;

public class ProductReturnServlet  extends HttpServlet{
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		try{
			String billIdStr = request.getParameter("billId");
			String productIdStr = request.getParameter("productId");
			String returnReason = request.getParameter("returnReason");
			String returnDate = request.getParameter("date");
			String amountStr = request.getParameter("amount");
			String quantityStr = request.getParameter("quantity");
						
			int billId = Integer.parseInt(billIdStr);
			int productId = Integer.parseInt(productIdStr);
			double amount = Double.parseDouble(amountStr);
			int quantity = Integer.parseInt(quantityStr.trim());
			
			ProductDao productDao = new ProductDao();
			productDao.productReturn(billId, productId, returnDate,quantity, returnReason, amount);
			
			response.sendRedirect("ProductReturningServlet?billId="+billId);
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}
