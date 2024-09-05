<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Bill"%>
<%@ page import="model.Customer" %>
<%@ page import="model.BillWithCustomer"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill Report</title>
<style type="text/css">
    body {
        font-family: Arial, sans-serif;
        background-color: WhiteSmoke;
        color: black;
        margin-left: 200px;
        margin-top: 10px;
        min-width: 1000px;
    }
    h3{
    	margin-top:5px;
    	margin-bottom:5px;
    }
    h1 {
        text-align: center;
        margin-bottom: 10px;
    }
    #reportType, #filterType, #filterTypeAllBills, #filterTypeCustomer, #filterTypeDiscount {
        padding: 5px;
        margin: 15px;
    }
    #discountFilters {
        gap: 10px;
    }
    label {
        margin-left: 20px;
    }
    #reportType {
        margin-bottom: 5px;
    }
    table {
        width: 90%;
        border-collapse: collapse;
        background-color: White;
        margin:10px auto 50px auto;
    }
    table, th, td {
        border: 1px solid DarkGray;
        font-size: 15px;
    }
    th, td {
        width: fit-content;
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
        background-color: LightCyan;
    }
    .hidden {
        display: none;
    }
    #submit {
        background-color: steelblue;
        color: white;
        border: none;
        padding: 8px 10px;
        cursor: pointer;
        border-radius: 4px;
        margin-top: 10px;
        margin-left: 15px;
    }
    #submit:hover {
        background-color: purple;
    }
    .filter-container {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-bottom: 20px;
    }
    .filter-row {
        max-width: fit-content;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .filter-row input,.filter-row select {
        padding: 3px;
        flex: 1;
    }
    .filter-button {
        padding: 10px 20px;
        background-color: steelblue;
        color: white;
        border: none;
        cursor: pointer;
        border-radius: 3px;
        margin-left: 20px;
    }
    .filter-button:hover {
        background-color: purple;
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
        height: 60px;
    }
    
    	.pagination {
            text-align: center;
            margin-top: 0px;
        }
        .pagination button {
            margin: 2px;
            padding: 8px 16px;
            background-color: steelblue;
            color: white;
            border: none;
            cursor: pointer;
        }
        .pagination button:disabled {
            background-color: lightgray;
            cursor: not-allowed;
        }
        .pagination button:hover:not(:disabled) {
            background-color: purple;
        }
    	
    	#limitChangeForm {
		    display: flex;
		    align-items: center;
		}
		
		#limitChangeForm label {
		    margin-right: 8px;
		    font-weight: bold;
		}
		
		#limitChangeForm select {
		    padding: 5px;
		    border-radius: 4px;
		    border: 1px solid lightgray;
		}
		.totalrecords {
		    text-align: right;
		    margin-right: 10%;
		    font-weight: bold;
		}
		.header-row {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin:20px 40px;
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
        String customerName = request.getParameter("customerName");
        String specificDate = request.getParameter("specificDate");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String dateFilter = request.getParameter("dateFilter");
        String discountApplied = request.getParameter("discountApplied");
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
    %>
    <h1>Bill Reports</h1>
    <div id="appliedFilters">
    	<div>
	        <h3>Applied Filters:</h3>
    	</div>
    	<div>
	        <% if (customerName != null && !customerName.isEmpty()) { %>
	            <div>Customer Name : <%= customerName %></div>
	        <% } %>
	        <% if (specificDate != null && !specificDate.isEmpty()) { %>
	            <div>Specific Date : <%= dateFormatter.format(Date.valueOf(specificDate)) %></div>
	        <% } %>
	        <% if (fromDate != null && !fromDate.isEmpty()) { %>
	            <div>From Date : <%= dateFormatter.format(Date.valueOf(fromDate)) %></div>
	        <% } %>
	        <% if (toDate != null && !toDate.isEmpty()) { %>
	            <div>To Date : <%= dateFormatter.format(Date.valueOf(toDate)) %></div>
	        <% } %>
	        <% if (dateFilter != null && !dateFilter.equals("all") && !dateFilter.isEmpty()) { %>
	            <div>Date Filter : <%= dateFilter %></div>
	        <% } %>
	        <% if (discountApplied != null && !discountApplied.equals("all") && !discountApplied.isEmpty()) { %>
	            <div>Discount Applied : <%= discountApplied %></div>
	        <% } %>
    	</div>
    </div>
    <form method="GET" action="BillReportServlet">
        <div class="filter-container">
            <div class="filter-row">
                <label for="customerName">Customer Name:</label>
                <input type="text" id="customerName" name="customerName">
            </div>

            <div class="filter-row">
                <label for="specificDate">Specific Date:</label>
                <input type="date" id="specificDate" name="specificDate">

                <label for="fromDate">From Date:</label>
                <input type="date" id="fromDate" name="fromDate">

                <label for="toDate">To Date:</label>
                <input type="date" id="toDate" name="toDate">

                <label for="dateFilter">Date Filter:</label>
                <select id="dateFilter" name="dateFilter">
                    <option value="all">All</option>
                    <option value="today">Today</option>
                    <option value="month">This Month</option>
                    <option value="week">This Week</option>
                </select>
            </div>

            <div class="filter-row">
                <label for="discountApplied">Discount Applied:</label>
                <select id="discountApplied" name="discountApplied">
                    <option value="all">All</option>
                    <option value="yes">Yes</option>
                    <option value="no">No</option>
                </select>
            </div>

            <div class="filter-row">
                <button type="submit" class="filter-button">Apply Filter</button>
            </div>
        </div>
    </form>
	
	<div class="header-row">
	    <form id="limitChangeForm" action="BillReportServlet" method="get">
	    	<input type="hidden" name="customerName" value="<%= (customerName!= null) ? customerName : "" %>">
		    <input type="hidden" name="specificDate" value="<%= (specificDate!=null)? specificDate: "" %>">
		    <input type="hidden" name="fromDate" value="<%= (fromDate != null) ? fromDate : "" %>">
		    <input type="hidden" name="toDate" value="<%= (toDate != null) ? toDate : "" %>">
		    <input type="hidden" name="dateFilter" value="<%= (dateFilter != null) ? dateFilter : "" %>">
		    <input type="hidden" name="discountApplied" value="<%= (discountApplied != null) ? discountApplied : "" %>">
	    	<label for="limit">Records Per Page </label>
	    	<select name="limit" id="limit">
	    		<option value="10" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("10") ? "selected" : "" %>>10</option>
	    		<option value="25" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("25") ? "selected" : "" %>>25</option>
	    		<option value="50" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("50") ? "selected" : "" %>>50</option>
	    		<option value="100" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("100") ? "selected" : "" %>>100</option>
	    	</select>
	   	</form>
		<h3 class="totalrecords">Total No. of Records : <%=(request.getAttribute("totalBills") != null)? request.getAttribute("totalBills") : 0 %></h3>
	</div>
    <% 
            	if(request.getAttribute("totalPages")!= null && (int)request.getAttribute("totalPages") > 1){
   	%>
    <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
            <button onclick="goToPage(${i})" ${i == currentPage ? 'disabled' : ''}>${i}</button>
        </c:forEach>
    </div>
	<% }%>
   	
   	
    <% 
        List<Bill> discountBills = (List<Bill>) request.getAttribute("bills");
        if (discountBills != null && !discountBills.isEmpty()) {
    %>
    <table>
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Customer Name</th>
                <th>Date</th>
                <th>Time</th>
                <th>Subtotal (₹)</th>
                <th>Discount Type</th>
                <th>Discount Percentage (%)</th>
                <th>Discount Amount (₹)</th>
                <th>Tax Percentage(%)</th>
                <th>Tax Amount(₹)</th>
                <th>Total Amount (₹)</th>
            </tr>
        </thead>
        <tbody>
            <% for (Bill bill : discountBills) { %>
            <tr onclick="showProducts(<%= bill.getBillId() %>)">
                <td><%= bill.getBillId() %></td>
                <td><%= bill.getCustomerName() %></td>
                <td><%= bill.getDate() %></td>
                <td><%= bill.getTime() %></td>
                <td><%= currencyFormatter.format(bill.getSubTotal()) %></td>
                <td><%= (bill.getDiscountType() == null) ? "N/A" : bill.getDiscountType() %></td>
                <td><%= (bill.getDiscountPercentage() == 0) ? "N/A" : bill.getDiscountPercentage() + "%" %></td>
                <td><%= (bill.getDiscountAmount() == 0.0) ? "N/A" : currencyFormatter.format(bill.getDiscountAmount()) %></td>
                <td><%= bill.getTaxPercentage() %>%</td>
                <td><%= currencyFormatter.format(bill.getTaxAmount()) %></td>
                <td><%= currencyFormatter.format(bill.getTotal()) %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <% } else { %>
    <div class="bill-count">Total Discounted Bills Found: 0</div>
    <table>
        <tr>
            <td colspan="9">No discounted bills found.</td>
        </tr>
    </table>
    <% } %>
    
    
    <script>
	    function goToPage(pageNumber) {
	        let url = new URLSearchParams(window.location.search);
	        url.set('page', pageNumber);
	        window.location.search = url.toString();
	    }
	    function showProducts(billId) {
	        window.location.href = 'billSpecificDetails.jsp?billId=' + billId;
	    }
        function resetDateFilters(except) {
            if (except !== 'specificDate') {
                document.getElementById('specificDate').value = '';
            }
            if (except !== 'fromDate' && except !== 'toDate') {
                document.getElementById('fromDate').value = '';
                document.getElementById('toDate').value = '';
            }
            if (except !== 'dateFilter') {
                document.getElementById('dateFilter').value = 'all';
            }
        }
        window.onload = function() {
            document.getElementById('specificDate').addEventListener('change', function() {
                resetDateFilters('specificDate');
            });

            document.getElementById('fromDate').addEventListener('change', function() {
                resetDateFilters('fromDate');
            });

            document.getElementById('toDate').addEventListener('change', function() {
                resetDateFilters('toDate');
            });

            document.getElementById('dateFilter').addEventListener('change', function() {
                resetDateFilters('dateFilter');
            });
            document.getElementById("limit").addEventListener('change', function() {
                document.getElementById("limitChangeForm").submit();
            });
        }
    </script>
</body>
</html>