<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.CustomerSales" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Sales Report</title>
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            min-width: 1000px;
            margin-left: 200px;
            margin-top: 20px;
        }
        h1 {
            text-align: center;
            margin-bottom: 10px;
        }
        #customerSalesReportForm {
            margin-left: 15px;
        }
        .filter-container {
	        display: flex;
	        flex-direction: column;
	        gap: 10px;
	        margin-top: 10px;
	        margin-left: 20px;
	        margin-bottom: 10px;
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
	    }
	    .filter-button:hover {
	        background-color: purple;
	    }
        #filterType {
            padding: 5px;
            margin: 15px;
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
        .pagination {
            text-align: center;
            margin-top: 0px;
            margin-bottom: 10px;
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
        
        .header-row {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin: 0 50px;
		}
    	
    	#limitChangeForm {
		    display: flex;
		    align-items: center;
		}
		
		#limitChangeForm label {
		    margin-left: 35px;
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
    </style>
    <script>
	    function goToPage(pageNumber) {
	        let url = new URLSearchParams(window.location.search);
	        url.set('page', pageNumber);
	        window.location.search = url.toString();
	    }
    	
        function showProducts(customerId, filterType, startDate, endDate) {
            window.location.href = 'customerSpecificBills.jsp?customerId=' + customerId + '&filterType=' + filterType + '&sDate=' + startDate + '&eDate=' + endDate;
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
    <h1>Customer Sales Report</h1>
    <div id="appliedFilters">
    <%
    	String filterType = "";
        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
        String specificDate = request.getParameter("specificDate");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String dateFilter = request.getParameter("dateFilter");

        if (specificDate != null && !specificDate.isEmpty()) {
        	filterType = "date";
            out.println("<div>Specific Date: " + dateFormatter.format(Date.valueOf(specificDate)) + "</div>");
        }

        if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
        	filterType = "dateRange";
            out.println("<div>Date Range: " + dateFormatter.format(Date.valueOf(fromDate)) + " to " + dateFormatter.format(Date.valueOf(toDate)) + "</div>");
        }

        if (dateFilter != null && !dateFilter.equals("all")) {
            switch (dateFilter) {
                case "today":
                	filterType = "today";
                    out.println("<div>Filter: Today</div>");
                    break;
                case "month":
                	filterType = "month";
                    out.println("<div>Filter: This Month</div>");
                    break;
                case "week":
                	filterType = "week";
                    out.println("<div>Filter: This Week</div>");
                    break;
            }
        }
        if ((specificDate == null || specificDate.isEmpty()) &&
            (fromDate == null || fromDate.isEmpty() || toDate == null || toDate.isEmpty()) &&
            (dateFilter == null || dateFilter.equals("all") || dateFilter.isEmpty())) {
            out.println("<div>All Bills</div>");
        }
    %>
</div>


    <form method="GET" action="CustomerSalesServlet">
        <div class="filter-container">
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
            <div class ="filter-row">
                <button type="submit">Apply Filter</button>
            </div>
        </div>
    </form>
    <div class="header-row">
	    <form id="limitChangeForm" action="CustomerSalesServlet" method="get">
		    <input type="hidden" name="specificDate" value="<%= (specificDate!=null)? specificDate: "" %>">
		    <input type="hidden" name="fromDate" value="<%= (fromDate != null) ? fromDate : "" %>">
		    <input type="hidden" name="toDate" value="<%= (toDate != null) ? toDate : "" %>">
		    <input type="hidden" name="dateFilter" value="<%= (dateFilter != null) ? dateFilter : "" %>">
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
            	if(request.getAttribute("totalPages") != null && (int)request.getAttribute("totalPages") > 1){
   	%>
    <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
            <button onclick="goToPage(${i})" ${i == currentPage ? 'disabled' : ''}>${i}</button>
        </c:forEach>
    </div>
	<% }%>

    <table>
        <thead>
            <tr>
                <th>Customer ID</th>
                <th>Customer Name</th>
                <th>Total Bills</th>
                <th>Total Amount</th>
            </tr>
        </thead>
        <tbody>
            <%
            	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
                List<CustomerSales> customerSalesList = (List<CustomerSales>) request.getAttribute("customerSales");
                if (customerSalesList != null && !customerSalesList.isEmpty()) {
                    for (CustomerSales sales : customerSalesList) {
            %>
                        <tr onclick="showProducts('<%= sales.getCustomerId() %>', '<%= filterType %>', '<%= specificDate %>', '<%= toDate %>')">
                            <td><%= sales.getCustomerId() %></td>
                            <td><%= sales.getCustomerName() %></td>
                            <td><%= sales.getTotalBills() %></td>
                            <td><%= currencyFormatter.format(sales.getTotalAmount()) %></td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="5">No sales data available</td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
            
