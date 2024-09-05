<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Bill"%>
<%@ page import="model.Customer"%>
<%@ page import="dao.CustomerDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Bills</title>
<style>
        body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            min-width: 1000px;
            margin-left: 200px;
            margin-top: 30px;
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
            margin:20px auto 50px auto;
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

        .hidden {
            display: none;
        }

        .visible {
            display: block;
        }

        #appliedFilters {
	     	display: flex;
	     	justify-content: center;
	     	align-items: center;
	     	gap:10px;
	        padding: 4px;
	        background-color: lightcyan; 
	        border: 1px solid darkcyan; 
	        margin: 0 0 10px 20px;
	        width: 400px;
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
            background-color: ForestGreen; 
            color: white;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 4px;
        }

        button:hover {
            background-color: MediumSeaGreen; 
        }
    </style>
<script>
function showProducts(billId) {
    window.location.href = 'billSpecificDetails.jsp?billId=' + billId;
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
	<a id="goback" href="javascript:history.back()">Go Back</a>

	<h1>Customer Bills</h1>
	<%
        String customerId = request.getParameter("customerId");
		String filterType = request.getParameter("filterType");
		String sDate = request.getParameter("sDate");
		String eDate = request.getParameter("eDate");
		
    	try{
    
        if (customerId != null && !customerId.isEmpty()) {
        	CustomerDao customerDao = new CustomerDao();
            List<Bill> bills = customerDao.getCustomerBills((Integer.parseInt(customerId)),filterType, sDate, eDate);

            if (bills != null && !bills.isEmpty()) {
            	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    %>
    <table id="billsTable" border="1">
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Customer Name</th>
                <th>Date</th>
                <th>Time</th>
                <th>subtotal(₹)</th>
                <th>Discount Type</th>
                <th>Discount Percentage(%)</th>
                <th>Discount Amount(₹)</th>
                <th>Tax Percentage(%)</th>
                <th>Tax Amount(₹)</th>
                <th>Total(₹)</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Bill bill : bills) {
                                %>
            <tr onclick="showProducts(<%= bill.getBillId() %>)">
                <td><%= bill.getBillId() %></td>
                <td><%= bill.getCustomerName() %></td>
                <td><%= bill.getDate() %></td>
                <td><%= bill.getTime() %></td>
                <td><%= currencyFormatter.format(bill.getSubTotal()) %></td>
                <td><%= (bill.getDiscountType() == null) ? "N/A" : bill.getDiscountType() %></td>
                <td><%= (bill.getDiscountPercentage() == 0) ? "N/A" : bill.getDiscountPercentage()+"%" %></td>
                <td><%= (bill.getDiscountAmount() == 0.0) ? "N/A" : currencyFormatter.format(bill.getDiscountAmount()) %></td>
                <td><%= bill.getTaxPercentage() %>%</td>
                <td><%= currencyFormatter.format(bill.getTaxAmount()) %></td>
                <td><%= currencyFormatter.format(bill.getTotal()) %></td>
            </tr>
            <% 
                }
            %>
        </tbody>
    </table>
	<%
            } 
            
            else if(bills == null){
            	out.println("<h3>Customer ID " + customerId + " is Not Found</h3>");
     %>
	<a href="addCustomer.jsp">Click Here to Enter Customer Details</a>
	<%
            }
            
            else {
                out.println("<h3>No bills found for Customer ID: " + customerId + "</h3>");
            }
        }
        
    	}
    	catch(NumberFormatException e){
    %>
	<h3>Invalid Input , Kindly Enter the Valid Input</h3>
	<%
    	}
    %>
</body>
</html>
