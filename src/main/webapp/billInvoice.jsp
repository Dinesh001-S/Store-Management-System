<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map"%>
<%@ page import="model.Product"%>
<%@ page import="model.Bill"%>
<%@ page import="dao.BillDao"%>
<%@ page import="dao.InventoryDao" %>
<%@ page import="dao.CustomerDao" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Invoice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.4;
            color: black;
        }
        
        a{
        	color: steelblue;
        	text-decoration: none; 
        }
        
        a:hover{
        	text-decoration: underline;
        } 
        
        .container{
            max-width: 450px; 
            margin: 20px auto;
            padding:20px;
            border : 1px solid darkgray;
        }

        h1 {
            margin: 0;
            padding: 0;
        }

        h1 {
            font-size: 24px;
            text-align: center;
        }

        .header, .footer {
            text-align: center;
            margin-bottom: 20px;
        }

        .invoice-info {
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 5px;
            text-align: center;
            border: 1px solid black;
        }

        th {
            background-color: steelblue;
            color : white;
        }

        .totals {
            margin-top: 20px;
            text-align: right;
        }

        .totals p {
            margin: 5px 0;
        }
    </style>
</head>
<body>
		<%
		    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		    response.setHeader("Pragma", "no-cache");
		    response.setDateHeader("Expires", 0);
		
		    if (session == null || session.getAttribute("user") == null) {
		        response.sendRedirect("login.jsp"); 
		    } else {
		    	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
		        int billId = Integer.parseInt(request.getParameter("billId"));
		        BillDao billDao = new BillDao();
		        CustomerDao customerDao = new CustomerDao();
		        Bill bill = billDao.getBill(billId);
		%>
		<a href="javascript:history.back()">Go Back</a>
		<div class="container">
		<div class="header">
		    <h1>Bill</h1>
		</div>
		
		<div class="invoice-info">
		    <p>Bill No: <%= billId %></p>
		    <p>Date: <%= bill.getDate() %></p>
		    <p>Time: <%= bill.getTime() %></p>
		    <p>Sold To: (CID:<%= bill.getCustomerId() %>) <%= customerDao.getCustomer(bill.getCustomerId()).getCustomerName() %></p>
		</div>
		
		<table>
		    <thead>
		        <tr>
		            <th>Item Name</th>
		            <th>Qty</th>
		            <th>Price</th>
		            <th>Total</th>
		        </tr>
		    </thead>
		    <tbody>
		    <%
		    	InventoryDao inventoryDao = new InventoryDao();
		        for (Map.Entry<Integer, Product> entry : bill.getInventorys().entrySet()) {
		            Product product = entry.getValue();
		            double totalPrice = product.getPrice() * product.getQuantity();
		    %>
		        <tr>
		            <td><%= inventoryDao.getProduct(product.getProductId()).getProductName() %></td>
		            <td><%= product.getQuantity() %></td>
		            <td><%= currencyFormatter.format(product.getPrice()) %></td>
		            <td><%= currencyFormatter.format(totalPrice) %></td>
		        </tr>
		    <%
		        }
		    %>
		    </tbody>
		</table>
		
		<div class="totals">
		    <p>subtotal: <%= currencyFormatter.format(bill.getSubTotal()) %></p>
		    <p>Discount(<%= bill.getDiscountPercentage() %>%): -<%= currencyFormatter.format(bill.getDiscountAmount()) %></p>
		    <p>GST Amount (<%= bill.getTaxPercentage() %>%): +<%= currencyFormatter.format(bill.getTaxAmount()) %></p>
		    <p>Total: <%= currencyFormatter.format(bill.getTotal()) %></p>
		</div>
		
		<div class="footer">
		    <p>Thank You</p>
		</div>
		
		</div>
		<%
		    }
		%>
</body>
</html>
