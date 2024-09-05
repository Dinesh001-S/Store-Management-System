<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Inventory"%>
<%@ page import="dao.InventoryDao"%>
<%@ page import="dao.CategoryDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Inventory</title>
<style type="text/css">
		body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            min-width: 1000px;
            margin-left: 200px;
            margin-top: 30px;
        }
        
        .addProduct {
            padding: 8px 12px;
		    background-color: white;
		    font-size: 14pt;
		    font-weight: bold;
		    text-decoration: none;
		    color: steelblue;
		    margin-left: 15px;
		    border: 1px solid DarkGray;
		    border-radius: 25px;
        }
        
        .addProduct:hover{
        	text-decoration : underline;
        }

        h1 {
            text-align: center;
        }
        
        #filterType{
        	padding: 5px;
        	margin : 15px;
        }

        table {
            width: 90%;
            border-collapse: collapse;
            background-color: White; 
            margin: 20px auto 50px auto;
        }

        table, th, td {
            border: 1px solid DarkGray; 
        }

        th, td {
        	width : fit-content;
            padding: 10px;
            text-align: center; 
        }

        thead {
            background-color: steelblue; 
            color: white;
        }

        tr:nth-child(even) {
            background-color: AliceBlue;
        }

        tbody tr:hover {
            background-color: LightCyan ; 
        }

</style>
<script>
    function showProducts(billId) {
        window.location.href = 'updateProductsInInventory.jsp?productId=' + encodeURIComponent(billId);
    }
    </script>
</head>
<body>
	<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp"); 
    }
%>

	<h1>Product Details</h1>
	<a class="addProduct" href="addNewProductInInventory.jsp">Add New Product</a>
	<a class="addCategory" href="add.jsp">Add New Product</a>
	<table id="productsTable" border="1">
		<thead>
			<tr>
				<th>Product ID</th>
				<th>Product Name</th>
				<th>Price(₹)</th>
				<th>Category</th>
				<th>Units</th>
			</tr>
		</thead>
		<tbody>
			<%
                InventoryDao productDAO = new InventoryDao();
            	CategoryDao categoryDAO = new CategoryDao();
                List<Inventory> products = productDAO.getAllProducts();
                for (Inventory product : products) {
                	String rowColor = product.getUnits() <= 5 ? "style='background-color: #ffb4ac;'" : ((5 < product.getUnits() && product.getUnits() <= 10) ?"style='background-color: #ffff62;'" : "");
           %>

			<tr onclick="showProducts(<%= product.getProductId() %>)" <%= rowColor %>>
				<td><%= product.getProductId() %></td>
				<td><%= product.getProductName() %></td>
				<td><%= product.getPrice() %></td>
				<td><%= categoryDAO.getCategoryName(product.getCategoryId()) %></td>
				<td><%= product.getUnits() %></td>
			</tr>
			<% } %>
		</tbody>
	</table>
</body>
</html>
