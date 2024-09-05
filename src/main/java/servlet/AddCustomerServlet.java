package servlet;

import dao.CustomerDao;
import model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

public class AddCustomerServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String customerName = request.getParameter("customerName");
		String phoneNo = request.getParameter("phoneNo");
		String email = request.getParameter("email");
		
		Customer customer = new Customer(customerName,phoneNo,email);
		CustomerDao customerDao = new CustomerDao();
		int result = customerDao.storeCustomerDetails(customer);
		
		HttpSession customerSession = request.getSession();
		String previousPage = customerSession.getAttribute("previousHeader").toString();
					
		if(previousPage != null) {
			response.sendRedirect(previousPage);
		}
		else if(result == 1) {			
			response.sendRedirect("addCustomer.jsp?result="+1);
		}
		else {
			response.sendRedirect("addCustomer.jsp?result="+-1);
		}
	}
}
