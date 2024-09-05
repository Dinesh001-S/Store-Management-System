package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import dao.DiscountDao;

public class ToggleDiscountStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int discountId = Integer.parseInt(request.getParameter("discountId"));
            String currentStatus = request.getParameter("currentStatus");

            String newStatus = "Active".equals(currentStatus) ? "Deactivate" : "Active";

            DiscountDao discountDao = new DiscountDao();
            discountDao.discountChangeStatus(discountId, newStatus);

            response.sendRedirect("displayAllDiscounts.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
