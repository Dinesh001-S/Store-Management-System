<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="employeeHeader.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Bill"%>
<%@ page import="model.User" %>
<%@ page import="dao.BillDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Employee Bills</title>
<style type="text/css">
		#body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            margin-left: 200px;
            margin-top: 30px;
        }
       
        h1 {
            text-align: center;
        }
        
        h3{
        	margin-left: 15px;
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
function showBillDetails(billId) {
    window.location.href = 'billSpecificDetails.jsp?billId=' + billId;
}
</script>
</head>
<body id="body">
	<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp"); 
    }
    else{
        int userId = ((User)session.getAttribute("user")).getUserId();
        BillDao billDao = new BillDao();
        List<Bill> bills = billDao.getBillsByEmployees(userId);

        if (bills != null && !bills.isEmpty()) {
    %>
	<h1>User Bills</h1>
	<h3>User Id : <%= userId %></h3>
	<table id="billsTable" border="1">
		<thead>
			<tr>
				<th>User Id</th>
				<th>Bill Id</th>
				<th>Customer Id</th>
				<th>Date</th>
				<th>Time</th>
				<th>Total Bill</th>
			</tr>
		</thead>
		<tbody>
			<%
            for (Bill bill : bills) {
            %>
			<tr onclick="showBillDetails(<%= bill.getBillId() %>)">
				<td><%= bill.getEmployeeId() %></td>
				<td><%= bill.getBillId() %></td>
				<td><%= bill.getCustomerId() %></td>
				<td><%= bill.getDate() %></td>
				<td><%= bill.getTime() %></td>
				<td><%= bill.getTotal() %></td>
			</tr>
			<%
            }
            %>
		</tbody>
	</table>
	<%
        } else {
            out.println("<h3>No bills found for this User..</h3>");
        }  }      
    %>
</body>
</html>
