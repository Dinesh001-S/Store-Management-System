package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BillDao;
import model.Bill;
public class ProductReturningServlet extends HttpServlet {
	    private static final long serialVersionUID = 1L;

	    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        String billIdStr = request.getParameter("billId");
	        if (billIdStr != null && !billIdStr.isEmpty()) {
	        	BillDao billDao = new BillDao();
	            int billId = Integer.parseInt(billIdStr);
	            Bill bill = billDao.getBill(billId);

				request.setAttribute("bill", bill);
				request.getRequestDispatcher("productReturn.jsp?billId=").forward(request, response);
	        } else {
	            response.sendRedirect("productReturn.jsp");
	        }
	    }
}