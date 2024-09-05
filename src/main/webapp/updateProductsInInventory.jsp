<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Inventory"%>
<%@ page import="model.Category"%>
<%@ page import="dao.InventoryDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Product Details</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    background-color: lightgray;
	    margin-left: 200px;
	    margin-top: 20px;
	    padding: 0;
	    display: flex;
	    flex-direction: column;
	    justify-content: center;
	}
	
	h1 {
	    color: black;
	    margin-bottom: 20px;
	    text-align: center;
	}
	
	.formContainer {
	    background-color: white;
	    border: 1px solid lightgray;
	    border-radius: 8px;
	    padding: 20px 40px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	    width: min-content;
	    margin: auto;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	}
	
	.updateProduct {
	    display:flex;
		flex-direction:column;
		margin:auto;
	    align-items:center;
	}
	
	.updateProduct input,
	.updateProduct select {
	    width: 350px;
	    padding: 10px;
	    margin: 10px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.updateProduct select {
	    width: 371.33px;
	}
	
	#submit {
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
		}
	
	#submit:hover {
	    background-color: purple;
	}
	
	h3 {
	    color: red;
	    margin-top: 20px;
	    font-size: 16px;
	    text-align: center;
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
    }

		int productId = Integer.parseInt(request.getParameter("productId"));
		InventoryDao inventoryDao = new InventoryDao();
		Inventory inventory = inventoryDao.getProduct(productId);
	%>
	<div class="formContainer">
	<h1>Product Profile</h1>
	<form class="updateProduct" action="UpdateInventoryProductServlet" method="post">
		<label for="productId">Product ID</label> 
		<input type="text" name="productId" id="productId" value="<%= inventory.getProductId() %>" readonly><br />
		
		<label for="productName">Product Name</label> 
		<input type="text" name="productName" id="productName" value="<%= inventory.getProductName() %>" readonly><br />
		
		<label for="price">Product Price</label> 
		<input type="text" name="price" id="price" value="<%= inventory.getPrice() %>" required><br />
		
		<label for="categoryId">Product Category</label> 
		<select name="categoryId" id="categoryId" required>
			<%
                List<Category> categories = inventoryDao.getProductCategories();
                for (Category category : categories) {
            	    if (inventory.getCategoryId() == category.getCategoryId()) {
            %>
			<option value="<%= category.getCategoryId() %>" selected><%= category.getCategoryName() %></option>
			<%
            	    } else {
            %>
			<option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
			<%
                }
            }
            %>
		</select><br />
		
		<label for="units">Product Units</label> 
		<input type="number" name="units" id="units" value="<%= inventory.getUnits() %>" required><br />
		
		<button type="submit" id="submit">Update Product</button>
	</form>

	<%
		String resultStr = request.getParameter("result");
		if (resultStr != null) {
			int result = Integer.parseInt(resultStr);
			if (result == 0) {
	%>
	<h3>No Changes</h3>
	<%
			} else if (result == 1) {
	%>
	<h3>Successfully Updated</h3>
	<%
			} else if (result == -2) {
	%>
	<h3>Invalid Input DataType, Kindly Check and Enter Valid Input</h3>
	<%
			} else if (result == -1) {
	%>
	<h3>Failed to Update</h3>
	<%
			}
		}
	%>
	</div>
</body>
</html>