package servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import dao.BillDao;
import dao.InventoryDao;
import dao.ProductDao;
import model.Bill;
import model.Inventory;
import model.Product;

public class ExchangeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        InventoryDao inventoryDao = new InventoryDao();
        List<Inventory> products = inventoryDao.getAllProducts();
        
        JSONArray jsonProducts = new JSONArray();
        for (Inventory product : products) {
            JSONObject jsonProduct = new JSONObject();
            jsonProduct.put("productId", product.getProductId());
            jsonProduct.put("productName", product.getProductName());
            jsonProduct.put("price", product.getPrice());
            jsonProduct.put("units", product.getUnits());
            jsonProducts.put(jsonProduct);
        }
                
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonProducts.toString());
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        StringBuilder stringBuilder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        }

        JSONObject jsonObject = new JSONObject(stringBuilder.toString());
        int billId = jsonObject.getInt("billId");
        JSONArray exchangeProductsArray = jsonObject.getJSONArray("exchangeProducts");
        double totalExchangeAmount = jsonObject.getDouble("totalExchangeAmount");
        
        List<Product> exchangeProducts = new ArrayList<>();

        for (int i = 0; i < exchangeProductsArray.length(); i++) {
            JSONObject product = exchangeProductsArray.getJSONObject(i);
            int productId = product.getInt("productId");
            double price = product.getDouble("price");
            int quantity = product.getInt("quantity");
            
            Product exchangeProduct = new Product();
            
            exchangeProduct.setProductId(productId);
            exchangeProduct.setPrice(price);
            exchangeProduct.setQuantity(quantity);
            
            exchangeProducts.add(exchangeProduct);

        }
        ProductDao billDao = new ProductDao();
        
        int outcome = billDao.productExchange(billId, exchangeProducts, totalExchangeAmount);
        
        if(outcome == 1) {
        	response.sendRedirect("ProductReturningServlet?billId="+billId);
        }
        else {
        	response.sendRedirect("ProductReturningServlet?billId="+billId);
        }
    }
}
