<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.User" %>
<%@ page import="model.Bill"%>
<%@ page import="model.Product"%>
<%@ page import="dao.InventoryDao"%>
<%@ page import="dao.BillDao"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Map.Entry"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill Products</title>
	<% 
    	User user = (User)session.getAttribute("user");
    	String admin = "";
    	if (user != null && user.getUserRoleId() == 101) {
    		admin = "admin";
	}%>
<style>
        body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            margin:20px;
        }
        
        #goback {
            text-decoration: none;
            color: steelblue; 
            margin-left: 15px;
        }
        #goback:hover {
            text-decoration: underline;
        }

        h1 {
            text-align: center;
        }
        
        #filterType{
        	padding: 5px;
        	margin : 15px;
        }
        
        #customerInputContainer, #dateRangeInputContainer{
        	padding:15px
        }

        table {
            width: 90%;
            border-collapse: collapse;
            background-color: White; 
            margin: 20px auto 50px auto;
        }

        table, th, td {
            border: 1px solid darkgray; 
        }

        th, td {
        	width : fit-content;
            padding: 10px;
            text-align: center; 
        }

        thead {
            background-color: SteelBlue; 
            color: white;
        }

        tr:nth-child(even) {
            background-color: AliceBlue;
        }

        tbody tr:hover {
            background-color: LightCyan ; 
        }

        .hidden {
            display: none;
        }

        .visible {
            display: block;
        }

        #appliedFilters {
            margin-top: 20px;
            padding: 10px;
            background-color: LightCyan; 
            border: 1px solid DarkCyan; 
        }

        #appliedFilters div {
            margin-bottom: 5px;
        }

        .bill-count {
            font-weight: bold;
            margin-top: 10px;
        }

        label, select, input {
            margin-right: 10px;
        }

        button {
            background-color: steelblue; 
            color: white;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 4px;
        }

        button:hover {
            background-color: purple; 
        }
        
        .admin{
        	margin-left:200px;
        	margin-top: 30px;
        }
    </style>
</head>
<body class=<%= admin %>>
	<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp"); 
    }
    else{
	if(((User)session.getAttribute("user")).getUserRoleId() == 101){%>
		<%@ include file="header.jsp" %>
	<%} %>
	<a id="goback" href="javascript:history.back()">Go Back</a>
	<% 
        String billIdStr = request.getParameter("billId");
        if (billIdStr != null) {
            int billId = Integer.parseInt(billIdStr);
            BillDao billDao = new BillDao();
            Bill bill = billDao.getBill(billId);
            if (bill != null) {
				NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
                Map<Integer, Product> products = bill.getInventorys();
    %>
	<h1>
		Products of Bill ID : 
		<%= billId %></h1>
	<table border="1">
		<thead>
			<tr>
				<th>Product ID</th>
				<th>Product Name</th>
				<th>Unit Price(₹)</th>
				<th>Quantity</th>
				<th>Amount</th>
			</tr>
		</thead>
		<tbody>
			<%
			InventoryDao inventoryDao = new InventoryDao();
            if (products != null && !products.isEmpty()) {
                for (Entry<Integer, Product> entry : products.entrySet()) {
                    Product product = entry.getValue();
                    
        %>
			<tr>
				<td><%= product.getProductId() %></td>
				<td><%= inventoryDao.getProduct(product.getProductId()).getProductName() %></td>
				<td><%= currencyFormatter.format(product.getPrice()) %></td>
				<td><%= product.getQuantity() %></td>
				<td><%= currencyFormatter.format(product.getPrice() * product.getQuantity()) %>
			</tr>
			<%
                }
            } else {
        %>
			<tr>
				<td colspan="4">No products found for this bill.</td>
			</tr>
			<%
            }
        %>
		</tbody>
	</table>
	<% 
            } else {
    %>
	<p>
		Bill not found for ID:
		<%= billId %></p>
	<% 
            }
        } else {
    %>
	<p>Invalid Bill ID.</p>
	<% 
        } }
    %>
</body>
</html>
