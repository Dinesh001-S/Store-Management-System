<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Bill"%>
<%@ page import="dao.BillDao"%>
<%@ page import="dao.CustomerDao" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Bills</title>
<style type="text/css">
		body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            min-width:1000px;
            margin-top:30px;
            margin-left: 200px;
        }
        
        .addBill ,.productReturn{
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
        .addBill:hover ,.productReturn:hover{
            text-decoration: underline;
        }

        h1 {
            text-align: center;
        }
        
        #filterType{
        	padding: 5px;
        	margin : 15px;
        }

        table {
            width: 90%;
            border-collapse: collapse;
            background-color: White; 
            margin: 20px auto 50px auto;
        }

        table, th, td {
        	font-size: 15px;
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
<script>
function showProducts(billId) {
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
%>
		<h1>Bills Details</h1>
	<% 
		NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
		BillDao billDao = new BillDao();
		CustomerDao customerDao = new CustomerDao();
		List<Bill> bills = (List<Bill>) request.getAttribute("bills");
		
	%>
	<a class="addBill" href="bill.jsp">Add Bill</a>
	<a class="productReturn" href="productReturn.jsp">Product Return</a>
	<table id="billsTable" border=1>
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
                <td><%= customerDao.getCustomer(bill.getCustomerId()).getCustomerName() %></td>
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
            if(bills.size()== 0){
    			out.println("<h3>No Bill Found</h3>");
    		}
            %>
        </tbody>
	</table>
</body>
</html>