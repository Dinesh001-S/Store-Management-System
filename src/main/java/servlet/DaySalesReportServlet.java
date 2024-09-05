package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Map;

import dao.BillDao;

public class DaySalesReportServlet extends HttpServlet{
	private final static long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String filter = request.getParameter("filter");
		String limitParam = request.getParameter("limit");
		
		int page = 1; 
	    int limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 10; 
	    if (request.getParameter("page") != null) {
	        page = Integer.parseInt(request.getParameter("page"));
	    }
	    int offset = (page - 1) * limit;

	    BillDao billDao = new BillDao();
	    
	    int[] totalrecord = new int[1];
	    
	    Map<String , Double> sales = billDao.getDayWiseSales(limit,offset,filter,totalrecord);
	    request.setAttribute("salesRecord", sales);
	    request.setAttribute("currentPage", page);
	    
	    int totalPages = (int) Math.ceil(totalrecord[0] * 1.0/limit);
	    request.setAttribute("totalBills", totalrecord[0]);
	    request.setAttribute("totalPages", totalPages);

	    RequestDispatcher dispatcher = request.getRequestDispatcher("dayWiseSalesReport.jsp");
	    dispatcher.forward(request, response);
	}
}
