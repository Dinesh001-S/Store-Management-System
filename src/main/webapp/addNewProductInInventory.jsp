<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="dao.InventoryDao"%>
<%@ page import="model.Category"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Product</title>
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
	
	.addProductForm {
		display:flex;
		flex-direction:column;
		margin:auto;
	    align-items:center;
	}
	
	.formContainer input,
	.formContainer select {
	    width: 350px;
	    padding: 10px;
	    margin: 10px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.addProductForm select{
		width: 370px;
	}
	
	.formContainer #submit {
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	}
	
	.formContainer #submit:hover {
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

    InventoryDao inventoryDao = new InventoryDao();
	List<Category> categories = inventoryDao.getProductCategories();
	%>
	<div class="formContainer">
	<h1>Add New Product</h1>
	<form class="addProductForm" action="AddNewProductServlet" method="post">
		<label for="productName">Enter Product Name</label>
		<input type="text" name="productName" id="productName" required><br />
		<label for="price">Enter Price</label>
		<input type="text" name="price" id="price" required><br />
		<label for="categoryId">Select Category</label>
		<select name="category" id="category" required>
			<option value="">Select Category</option>
			<% for (Category category : categories) { %>
				<option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
			<% } %>
		</select>
		<label for="quantity">Enter Units</label>
		<input type="number" name="units" id="units" required min="1"><br /> 
		<button type="submit" id="submit">Add Product</button>
	</form>
    <%	
    	String resultString = request.getParameter("result");
    	if(resultString != null){
		int result = Integer.parseInt(resultString);
		if(result == 1){
			%><h3>Product Added Successfully...</h3>
	<%
		}
		else{
			%><h3>Failed to Add The Product...</h3>
	<%
		}}
	%>
    </div>
</body>
</html>
