package servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import dao.BillDao;
import model.Bill;

import java.io.IOException;
import java.util.List;

public class BillReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String customerName = request.getParameter("customerName");
	    String dateFilter = request.getParameter("dateFilter");
	    String specificDate = request.getParameter("specificDate");
	    String fromDate = request.getParameter("fromDate");
	    String toDate = request.getParameter("toDate");
	    String discountApplied = request.getParameter("discountApplied");
	    String limitParam = request.getParameter("limit");
	    
	    int page = 1; 
	    int limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 10; 
	    if (request.getParameter("page") != null) {
	        page = Integer.parseInt(request.getParameter("page"));
	    }
	    int offset = (page - 1) * limit;

	    BillDao billDao = new BillDao();
	    List<Bill> filteredBills = billDao.getFilteredBills(customerName, dateFilter, specificDate, fromDate, toDate, discountApplied, offset, limit);

	    request.setAttribute("bills", filteredBills);
	    request.setAttribute("currentPage", page);
	    
	    int totalBills = billDao.getTotalBills(customerName, dateFilter, specificDate, fromDate, toDate, discountApplied);
	    int totalPages = (int) Math.ceil(totalBills* 1.0/limit);
	    request.setAttribute("totalBills", totalBills);
	    request.setAttribute("totalPages", totalPages);

	    RequestDispatcher dispatcher = request.getRequestDispatcher("billReports.jsp");
	    dispatcher.forward(request, response);
	}
}