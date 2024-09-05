<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Customer</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    background-color: lightgray;
	    margin-left: 200px;
	    margin-top:30px;
	    padding: 0;
	    display: flex;
	    flex-direction: column; 
	    justify-content: center;
	}
	
	h1 {
	    color: black;
	    margin-bottom: 20px;
	    text-align:center;	
	}
	
	.formContainer{
		display: flex;
		flex-direction: column;
	    background-color: white;
	    border: 1px solid lightgray;
	    width: min-content;
	    margin: auto;
	    border-radius: 8px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	    padding: 20px 40px;
	}
	
	.addCustomerForm {
		display:flex;
		flex-direction:column;
		margin:auto;
	    align-items:center;
	}
	
	.addCustomerForm input,
	.addCustomerForm select {
	    width: 350px;
	    padding: 10px;
	    margin: 10px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.addCustomerForm select{
	 width:371.33px;
	}
	
	
	
	.addCustomerForm #submit {
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	    margin:auto;
	}
	
	.addCustomerForm #submit:hover {
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
    HttpSession customerSession = request.getSession();
    String previousPage = request.getHeader("Referer");
    customerSession.setAttribute("previousHeader", previousPage);
    %>
    <div class="formContainer">
	<h1>Add Customer</h1>
	<form class="addCustomerForm" action="AddCustomerServlet" method="post">
		Enter Customer Name
		<input type="text" name="customerName" id="customerName" required><br /> 
		Enter Customer Email
		<input type="email" name="email" id="email" required><br /> 
		Enter Customer Mobile Number
		<input type="text" name="phoneNo" id="phoneNo" required pattern="\d{10}"><br />
		<button type="submit" id="submit">Add Customer</button>
	</form>
	<%	
    	String resultString = request.getParameter("result");
    	if(resultString != null){
		int result = Integer.parseInt(resultString);
		if(result == 1){
			%><h3>Customer Added Successfully...</h3>
	<%
		}
		else{
			%><h3>Failed to Add Customer...</h3>
	<%
		}}
	%>
    </div>
</body>
</html>
