<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Discount" %>
<%@ page import="dao.DiscountDao" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Discounts Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: whitesmoke; 
            color: black;
            margin-left: 200px;
            margin-top: 30px;
        }
        
        .goBack{
        	align-item:center;
        	color:white;
        	background-color:steelblue;
        	padding:2.5px 4px;
        	text-decoration:none;
        	font-size: 24pt;
        	border:2px solid steelblue;
        	border-radius:50%;
        }
        
        .addDiscount {
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
        .addDiscount:hover {
            text-decoration: underline;
        }
        
        h1{
        	text-align:center;
        	margin-top: 0px;
        }
        table {
            width: 90%;
            border-collapse: collapse;
            background-color: White; 
            margin: 0px auto 50px auto;
        }
        th, td {
            border: 1px solid DarkGray;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: SteelBlue; 
            color: white;
        }
        .active-row {
            background-color: AliceBlue; 
        }
        .deactivate-row {
            background-color: MistyRose ; 
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
    <h1>Discount Details</h1><br/>
    <a class="addDiscount" href="addNewDiscount.jsp">Add Discount</a><br/><br/>
    <table id="discountsTable">
        <thead>
            <tr>
                <th>Discount ID</th>
                <th>Discount Type</th>
                <th>Condition Amount</th>
                <th>Discount Percentage</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                DiscountDao discountDao = new DiscountDao();
                List<Discount> discounts = discountDao.allDiscount();
                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
                for (Discount discount : discounts) {
                    String rowClass = "Active".equals(discount.getStatus()) ? "active-row" : "deactivate-row";
            %>
            <tr class="<%= rowClass %>">
                <td><%= discount.getDiscountId() %></td>
                <td><%= discount.getDiscountType() %></td>
                <td><%= currencyFormatter.format(discount.getConditionAmount()) %></td>
                <td><%= discount.getDiscountPercentage() %>%</td>
                <td><%= discount.getStatus() %></td>
                <td>
                    <form action="ToggleDiscountStatusServlet" method="post">
                        <input type="hidden" name="discountId" value="<%= discount.getDiscountId() %>"/>
                        <input type="hidden" name="currentStatus" value="<%= discount.getStatus() %>"/>
                        <button type="submit">
                            <%= "Active".equals(discount.getStatus()) ? "Deactivate" : "Activate" %>
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
