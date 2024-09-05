<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Customer"%>
<%@ page import="model.User"%>
<%@ page import="dao.CustomerDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customers Details</title>
<style type="text/css">
		body {
            font-family: Arial, sans-serif;
            background-color: Whitesmoke;
            color: black;
            margin-left:200px;
            margin-top: 30px;
        }
        
        .addCustomer {
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
        a.addCustomer:hover {
            text-decoration: underline;
        }

        h1 {
            text-align: center;
            margin-top: 0px;
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
            border: 1px solid DarkGray; 
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

</style>
	<script type="text/javascript">
		function updateCustomer(customerId) {
	        window.location.href = 'updateCustomerDetails.jsp?customerId=' + encodeURIComponent(customerId);
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
	<br/>
	<h1>Customers Details</h1>
	<a class="addCustomer" href="addCustomer.jsp">Add Customer</a>

	<table id="customerTable" border="1">
		<thead>
			<tr>
				<th>Customer ID</th>
				<th>Customer Name</th>
				<th>Email</th>
				<th>Phone Number</th>
			</tr>
		</thead>
		<tbody>
			<%
                CustomerDao customerDAO = new CustomerDao(); 
                List<Customer> customers = customerDAO.getAllCustomerDetails(); 

                for (Customer customer : customers) {
            %>
			<tr onclick="updateCustomer(<%= customer.getCustomerId() %>)">
				<td><%= customer.getCustomerId() %></td>
				<td><%= customer.getCustomerName() %></td>
				<td><%= customer.getEmail() %></td>
				<td><%= customer.getPhoneNo() %></td>
			</tr>
			<%
                }
            %>
		</tbody>
	</table>
</body>
</html>