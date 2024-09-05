<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file='header.jsp' %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    background-color: lightgray;
	    margin-left: 200px;
	    margin-top: 30px;
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
	
	.addDiscount {
		display:flex;
		flex-direction:column;
		margin:auto;
	    align-items:center;
	}
	
	.addDiscount input,
	.addDiscount select {
	    width: 350px;
	    padding: 10px;
	    margin: 10px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.addDiscount select{
	 width:371.33px;
	}
	
	.addDiscount #submit {
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	    margin:auto;
	}
	
	.addDiscount #submit:hover {
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
	%>
	<div class="formContainer">
	<h1>Add Discount</h1>
	<form class="addDiscount" action="AddNewDiscountServlet" method="post">
		<label for="discountType">Discount Type</label>
		<select name="discountType" id="discountType" required>
			<option value="Monthly Discount">Monthly Discount</option>
			<option value="Single Bill Discount">Single Bill Discount</option>
		</select><br/>
		<label for="conditionAmount">Condition Amount</label>
		<input type="text" name="conditionAmount" id="conditionAmount" required><br/>
		<label for="discountPercentage">Discount Percentage</label>
		<input type="text" name="discountPercentage" id="discountPercentage" required><br/>
		<button type="submit" id="submit">Submit</button>
	</form>
	<%
		String outcome = request.getParameter("outcome");
		if(outcome != null && outcome.equals("1")){
			out.println("<h3>Discount Added Successfully...</h3>");
		}
		else if(outcome != null && outcome.equals("-1")){
			out.println("<h3>Failed to Add Discount...</h3>");
		}
		else if(outcome != null && outcome.equals("-2")){
			out.println("<h3>Kindly Enter Valid Input...</h3>");
		}
	%>
	</div>
</body>
</html>