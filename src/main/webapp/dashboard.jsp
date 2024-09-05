<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory"%>
<%@ page import="model.Bill" %>
<%@ page import="dao.BillDao" %>
<%@ page import="dao.InventoryDao" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<style>
		body{
			font-family :Arial, sans-serif;
			margin-left: 200px;
			margin-top: 30x; 
		}
		
		.sales{
			display: flex;
			justify-content: space-between;
			margin-bottom: 20px;
			margin-top:20px;
		}
		
		.salesSection {
			border: 1px solid darkgray;
			padding: 20px; 
			box-shadow: 2px 2px 5px lightgray; 
			border-radius: 10px;
			width: fit-content;
			flex: 1;
			margin: 10px;
		}
	
		.salesSection h2 ,.salesSection p{
			text-align: center;
			font-size: 20px;
			margin-bottom: 10px;
		}
		
		h1 {
	            text-align: center;
	        }
		
		table {
            width: 95%;
            border-collapse: collapse;
            background-color: White; 
            margin: 20px auto 30px auto;
        }

        table, th, td {
            border: 1px solid lightgray; 
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
        .bill-count {
            font-weight: bold;
            margin-top: 10px;
        }
</style>
<script type="text/javascript">
	function showProducts(billId) {
	    window.location.href = 'updateProductsInInventory.jsp?productId=' + encodeURIComponent(billId);
	}
	function showBills(billId) {
        window.location.href = 'billInvoice.jsp?billId=' + billId;
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
		NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
		BillDao billDao = new BillDao();
		InventoryDao inventoryDao = new InventoryDao();
		double todaysSales = billDao.getTodaySales();
		double currentMonthSales = billDao.getCurrentMonthSales();
		List<Inventory> lowUnitProducts = inventoryDao.getLowUnitsProducts();
		List<Bill> todayBills = billDao.getTodayBills();
	%>
	<div class="dashboard">
		<div class="sales">
			 <div class="salesSection">
				<h2>Today's Sales</h2>
				<p><%= currencyFormatter.format(todaysSales) %></p>
			</div>
			<div class="salesSection">
				<h2>Current Month Sales</h2>
				<p><%= currencyFormatter.format(currentMonthSales) %></p>
			</div>
		</div>
        <div class="lowUnitsProducts">
        	<h1>Products with Low Units</h1>
        	<table>
        		<thead>
        			<tr>
        				<th>Product ID</th>
        				<th>Product Name</th>
        				<th>Price</th>
        				<th>Units</th>
        			</tr>
        		</thead>
        		<tbody>
        			<%
        				for(Inventory inventory : lowUnitProducts){
        			%>
        				<tr onclick="showProducts(<%= inventory.getProductId() %>)">
        					<td><%= inventory.getProductId() %></td>
        					<td><%= inventory.getProductName() %></td>
        					<td><%= currencyFormatter.format(inventory.getPrice()) %></td>
        					<td><%= inventory.getUnits() %></td>
        				<tr>
        			<% 
        				}
        			%>
        		</tbody>
        	</table>
        </div>
        <div class="todayBills">
        	<h1>Today Bills</h1>
        	<table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Subtotal</th>
                        <th>Discount Type</th>
                        <th>Discount (%)</th>
                        <th>Discount Amount</th>
                        <th>Tax (%)</th>
                        <th>Tax Amount</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%	
                    	if(todayBills.size() != 0){
                    	for(Bill bill : todayBills){
                    %>
                        <tr onclick="showBills(<%= bill.getBillId() %>)">
                            <td><%= bill.getBillId() %></td>
                            <td><%= bill.getDate() %></td>
                            <td><%= bill.getTime() %></td>
                            <td><%= currencyFormatter.format(bill.getSubTotal()) %></td>
                            <td><%= (bill.getDiscountType() == null) ? "N/A" : bill.getDiscountType() %></td>
                            <td><%= (bill.getDiscountPercentage() == 0.0) ? "N/A" : bill.getDiscountPercentage() %></td>
                            <td><%= (bill.getDiscountAmount() == 0.0) ? "N/A" : currencyFormatter.format(bill.getDiscountAmount()) %></td>
                            <td><%= bill.getTaxPercentage() %></td>
                            <td><%= currencyFormatter.format(bill.getTaxAmount()) %></td>
                            <td><%= currencyFormatter.format(bill.getTotal()) %></td>
                        </tr>
                    <%
                    }} 
                    	
                    	else if(todayBills.size() == 0){
            		%>
                             <tr>
                                 <td style="font-weight:bold;" colspan="10">No bills found</td>
                             </tr>
             <% 
                 }
             %>
                    
                </tbody>
                    	
            </table>
        </div>
	</div>
</body>
</html>