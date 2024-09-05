package servlet;

import dao.CustomerDao;
import model.Customer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UpdateCustomerDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String customerName = request.getParameter("customerName");
            String email = request.getParameter("email");
            String phoneNo = request.getParameter("phoneNo");

            Customer customer = new Customer(customerId, customerName, phoneNo, email);
            CustomerDao customerDao = new CustomerDao();
            int result = customerDao.updateCustomerDetails(customer);
            response.sendRedirect("updateCustomerDetails.jsp?result=" + result + "&customerId=" + customerId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("updateCustomerDetails.jsp?result=" + -2 + "&customerId=" + request.getParameter("customerId"));
        }
    }
}
