package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import dao.DiscountDao;
import model.Discount;

public class AddNewDiscountServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String discountType = request.getParameter("discountType");
			double conditionAmount = Double.parseDouble(request.getParameter("conditionAmount"));
			double discountPercentage = Double.parseDouble(request.getParameter("discountPercentage"));
			
			DiscountDao discountDao = new DiscountDao();
			int outcome = discountDao.addDiscount(new Discount(discountType, conditionAmount,discountPercentage));
			response.sendRedirect("addNewDiscount.jsp?outcome="+outcome);
		}
		catch(NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("addNewDiscount.jsp?outcome="+-2);
		}
	}

}
