<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Bill"%>
<%@ page import="model.Inventory"%>
<%@ page import="dao.CategoryDao"%>
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
            margin:20px 50px 50px 50px;
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

	<%
        String categoryId = request.getParameter("categoryId");
		String filterType = request.getParameter("filterType");
		String sDate = request.getParameter("sDate");
		String eDate = request.getParameter("eDate");
        CategoryDao categoryDao = new CategoryDao();
		%>
	<h1>Category <%= categoryDao.getCategoryName(Integer.parseInt(categoryId)) %>   <%= (filterType != null) ? filterType.toUpperCase() : "All Sales" %> </h1>
		<%
    	try{
    
        if (categoryId != null && !categoryId.isEmpty()) {
            List<Inventory> bills = categoryDao.getCategoryBills((Integer.parseInt(categoryId)),filterType, sDate, eDate);

            if (bills != null && !bills.isEmpty()) {
            	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    %>
    <table id="billsTable" border="1">
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total(₹)</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Inventory bill : bills) { %>
            <tr onclick="showProducts(<%= bill.getProductId() %>)">
                <td><%= bill.getProductId() %></td>
                <td><%= bill.getProductName() %></td>
                <td><%= currencyFormatter.format(bill.getPrice()) %></td>
                <td><%= bill.getUnits() %></td>
                <td><%= currencyFormatter.format(bill.getPrice() * bill.getUnits()) %></td>
            </tr>
            <% 
                }
            %>
        </tbody>
    </table>
	<%
            } 
            
            else {
                out.println("<h3>No bills found for Category ID: " + categoryId + "</h3>");
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
