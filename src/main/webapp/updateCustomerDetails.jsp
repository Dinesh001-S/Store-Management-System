<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="model.Customer" %>
<%@ page import="dao.CustomerDao" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Customer Details</title>
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
	    justify-content: center;
	}
	
	.updateCustomerForm {
		display:flex;
		flex-direction:column;
		margin:auto;
	    align-items:center;
	}
	
	.updateCustomerForm input,
	.updateCustomerForm select {
	    width: 350px;
	    padding: 10px;
	    margin: 10px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.updateCustomerForm #submit {
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	    margin: auto;
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

	Customer addUser = (Customer) session.getAttribute("addUser");
	int customerId = Integer.parseInt(request.getParameter("customerId"));
	CustomerDao customerDao = new CustomerDao();
	Customer customer = customerDao.getCustomer(customerId);
	%>
	<div class="formContainer">
	<h1>Customer Details</h1>
	<form class="updateCustomerForm" action="UpdateCustomerDetailsServlet" method="post">
		<label for="customerId">Customer Id</label> 
		<input type="text" name="customerId" id="customerId" value="<%= customer.getCustomerId() %>" readonly><br/>
		<label for="customerName">Customer Name</label>
		<input type="text" name="customerName" id="customerName" value="<%= customer.getCustomerName() %>" required><br /> 
		<label for="email">Customer Email</label>
		<input type="email" name="email" id="email" value="<%= customer.getEmail() %>" required><br /> 
		<label for="phoneNo">Customer Mobile Number (10-digit)</label>
		<input type="text" name="phoneNo" id="phoneNo" value="<%= customer.getPhoneNo() %>" required pattern="\d{10}"><br />
		<button type="submit" id="submit">Update Customer</button>
	</form>
	<%
        String result = request.getParameter("result");
        if(result != null){
            if(result.equals("0")){
                out.println("<h3>Customer ID is already present, please enter a unique Customer ID.</h3>");
                session.removeAttribute("addUser");
            } else if(result.equals("1")){
                out.println("<h3>Customer Details Updated Successfully...</h3>");
            }
        }
    %>
    </div>
</body>
</html>
