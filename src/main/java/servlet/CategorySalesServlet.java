package servlet;

import dao.CategoryDao;
import model.CategorySales;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class CategorySalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            CategoryDao categoryDao = new CategoryDao();
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
    	    request.setAttribute("currentPage", page);
    	    List<CategorySales> categoryBillsCount = categoryDao.getFilteredCategorySales(specificDate, fromDate, toDate, dateFilter, limit, offset);
    	    
    	    int totalBills = categoryDao.getTotalCategorySales(specificDate, fromDate, toDate, dateFilter);
    	    int totalPages = (int) Math.ceil(totalBills* 1.0/limit);
    	    request.setAttribute("totalBills", totalBills);
    	    request.setAttribute("totalPages", totalPages);
            
            
            request.setAttribute("categoryBillsCount", categoryBillsCount);
            request.getRequestDispatcher("categorySalesReport.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}