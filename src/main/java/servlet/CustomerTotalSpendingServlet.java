package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import dao.CustomerDao;

public class CustomerTotalSpendingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mobileNumber = request.getParameter("mobileNumber");
        CustomerDao customerDao = new CustomerDao();
        double totalSpending = customerDao.getCustomerTotalSpendByMonth(customerDao.getCustomerIdByPhoneNo(mobileNumber));
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        ObjectMapper mapper = new ObjectMapper();
        out.print(mapper.writeValueAsString(new TotalSpending(totalSpending)));
        out.flush();
    }

    public static class TotalSpending {
        public double totalSpending;
        public TotalSpending(double totalSpending) {
            this.totalSpending = totalSpending;
        }
    }
}
