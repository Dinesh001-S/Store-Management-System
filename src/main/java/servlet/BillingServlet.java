package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import model.User;
import model.Bill;
import model.Product;
import model.FormData;
import model.Inventory;

import dao.CustomerDao;
import dao.BillDao;
import dao.InventoryDao;
import dao.DiscountDao;

public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("date");
        String customerPhoneNo = request.getParameter("customerPhoneNo");
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String selectedDiscountId = request.getParameter("selectedDiscountId"); 
        String discountAmountStr = request.getParameter("discountAmount");  
        String taxAmount = request.getParameter("gstAmount");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.getWriter().println("Employee not logged in.");
            return;
        }

        FormData formData = new FormData(date, customerPhoneNo, productIds, quantities);
        session.setAttribute("formData", formData);

        int userId = user.getUserId();
        InventoryDao inventoryDao = new InventoryDao();
        CustomerDao customerDao = new CustomerDao();
        DiscountDao discountDao = new DiscountDao();
        int customerId = customerDao.getCustomerIdByPhoneNo(customerPhoneNo);
        if (customerId == -1) {
            response.sendRedirect("addCustomer.jsp");
            return;
        }

        try {
            Map<Integer, Product> products = new HashMap<>();
            double subtotal = 0.00;
            double total = 0.00;
            double taxPercentage = 3.00;
            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = 0;
                if (products.containsKey(productId)) {
                    quantity = Integer.parseInt(quantities[i]) + products.get(productId).getQuantity();
                } else {
                    quantity = Integer.parseInt(quantities[i]);
                }
                Inventory inventoryProduct = inventoryDao.getProduct(productId);
                if (inventoryProduct == null) {
                    response.sendRedirect("bill.jsp?outcome=" + "Product Not Found" + "&productId=" + productId);
                    return;
                }
                int units = inventoryProduct.getUnits();
                if (quantity > units) {
                    response.sendRedirect("bill.jsp?outcome=" + "Insufficient Units" + "&productId=" + productId);
                    return;
                }
                double price = inventoryDao.getProductPrice(productId);
                Product product = new Product(productId, price, quantity);
                products.put(productId, product);
                subtotal += price * quantity;
                total += price * quantity;
            }
            
            String time = new SimpleDateFormat("HHmmss").format(new Date());
            BillDao billDao = new BillDao();
            
            int billId = -1;

            double discountAmount = 0.00;
            if (selectedDiscountId != null && !selectedDiscountId.isEmpty()) {
            	String discountType = discountDao.getDiscount(Integer.parseInt(selectedDiscountId)).getDiscountType();
                discountAmount = Double.parseDouble(discountAmountStr);
                total = subtotal -  discountAmount + Double.parseDouble(taxAmount);
                double discountPercentage = discountDao.getDiscount(Integer.parseInt(selectedDiscountId)).getDiscountPercentage();
                Bill bill = new Bill(userId, customerId, date, time, products,discountType,discountPercentage,discountAmount,taxPercentage,Double.parseDouble(taxAmount),total);
                bill.setTotal(total);
                billId = billDao.addBillWithDiscount(bill);
            }
            else {
            	total += Double.parseDouble(taxAmount);
            
            	Bill bill = new Bill(userId, customerId, date, time, products,taxPercentage,Double.parseDouble(taxAmount),total);
             	bill.setTotal(total);

            	billId = billDao.addBill(bill);
            }

            if (billId != -1) {
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    int units = inventoryDao.getProduct(productId).getUnits();
                    inventoryDao.updateProductUnits(productId, units - quantity);
                }
                session.removeAttribute("formData");
                response.sendRedirect(request.getContextPath() + "/billInvoice.jsp?billId=" + billId + "&discountApplied=true");
            } 
            else {
                response.getWriter().println("Failed to generate bill.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("bill.jsp?outcome=" + "Invalid Input");
        }
    }
}