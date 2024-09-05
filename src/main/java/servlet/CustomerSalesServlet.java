package servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import dao.CustomerDao;
import model.CustomerSales;
import java.io.IOException;
import java.util.List;

public class CustomerSalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String specificDate = request.getParameter("specificDate");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String dateFilter = request.getParameter("dateFilter");
        String limitParam = request.getParameter("limit");
        
        int page = 1; 
	    int limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 10; 
	    if (request.getParameter("page") != null) {
	        page = Integer.parseInt(request.getParameter("page"));
	    }
	    int offset = (page - 1) * limit;

        CustomerDao customerDao = new CustomerDao();
        List<CustomerSales> customerSales = customerDao.getFilteredCustomerSales(specificDate, fromDate, toDate, dateFilter, limit, offset);

        request.setAttribute("customerSales", customerSales);
        request.setAttribute("currentPage", page);
        
        int totalBills = customerDao.getTotalCustomerSales(specificDate, fromDate, toDate, dateFilter);
	    int totalPages = (int) Math.ceil(totalBills* 1.0/limit);
	    request.setAttribute("totalBills", totalBills);
	    request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("customerSalesReport.jsp");
        dispatcher.forward(request, response);
    }
}
