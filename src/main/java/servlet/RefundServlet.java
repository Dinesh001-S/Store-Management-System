package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BillDao;
import dao.ProductDao;
import model.Bill;

public class RefundServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int billId = Integer.parseInt(request.getParameter("billId"));
        
        BillDao billDao = new BillDao();
        
        Bill bill = billDao.getBill(billId);
        
        if (bill != null) {
            double returnCreditAmount = bill.getReturnCreditAmount();
            
            double newRefundAmount = bill.getRefundAmount() + returnCreditAmount;
            bill.setRefundAmount(newRefundAmount);
            
            bill.setReturnCreditAmount(0.0);
            
            boolean isRefunded = billDao.refundAmount(bill);
            
            if (isRefunded) {
                request.setAttribute("message", "Successfully Refunded");
            } else {
                request.setAttribute("message", "Refund Failed");
            }
            response.sendRedirect("ProductReturningServlet?billId="+billId);
        } else {
        	response.sendRedirect("ProductReturningServlet?billId="+billId);
        }
    }
}
