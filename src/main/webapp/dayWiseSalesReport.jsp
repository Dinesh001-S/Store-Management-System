<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.BillDao" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Sales Report</title>
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            margin-left: 200px;
            margin-top: 20px;
            min-width: 1000px;
        }
        h1 {
            text-align: center;
        }
        #customerSalesReportForm {
            margin-left: 15px;
        }

        #filterForm label {
            margin-left: 20px;
        }
        
        #filterForm select {
            padding: 5px;
        }
        
        .filterForm button{
            padding: 10px 20px;
            background-color: steelblue;
            color: white;
            border: none;
            cursor: pointer;
            margin-left: 15px;
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
            margin:10px 50px 50px 50px;
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
            margin-left: 20px;
        }
        button:hover {
            background-color: purple;
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
		    margin-left: 0;
		    font-weight: bold;
		}
		
		#limitChangeForm select {
		    padding: 5px;
		    border-radius: 4px;
		    border: 1px solid lightgray;
		    margin-left: 10px;
		}
		
		.totalrecords {
		    text-align: right;
		    margin-right: 0;
		    font-weight: bold;
		}
    </style>
    <script>
	    function goToPage(pageNumber) {
	        let url = new URLSearchParams(window.location.search);
	        url.set('page', pageNumber);
	        window.location.search = url.toString();
	    }
        window.onload = function() {
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
    <h1>Day Wise Sales Report</h1>
    <div id="appliedFilters">
    <%
        String filter = request.getParameter("filter");
        if (filter != null && !filter.equals("all")) {
            switch (filter) {
                case "today":
                    filter = "yaer";
                    out.println("<div>Filter: Year</div>");
                    break;
                case "month":
                    filter = "month";
                    out.println("<div>Filter: This Month</div>");
                    break;
                case "week":
                    filter = "week";
                    out.println("<div>Filter: This Week</div>");
                    break;
                case "year":
                	filter ="year";
                	out.println("<div>Filter: This Year</div>");
                	break;
            }
        }
        if ((filter == null || filter.isEmpty())) {
            out.println("<div>All Bills</div>");
        }
    %>
    </div>
	<form id="filterForm" action="DaySalesReportServlet" method="get">
	  <label for="filter">Filter by:</label>
	  <select name="filter" id="filter">
	    <option value="" >All</option>
	    <option value="week" ${filter == 'week' ? 'selected' : ''}>This Week</option>
	    <option value="month" ${filter == 'month' ? 'selected' : ''}>This Month</option>
	    <option value="year" ${filter == 'year' ? 'selected' : ''}>This Year</option>
	  </select>
	  <button type="submit">Apply Filter</button>
	</form>
    <div class="header-row">
	    <form id="limitChangeForm" action="DaySalesReportServlet" method="get">
	        <label for="limit">Records Per Page</label>
	        <select name="limit" id="limit">
	            <option value="10" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("10") ? "selected" : "" %>>10</option>
	            <option value="25" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("25") ? "selected" : "" %>>25</option>
	            <option value="50" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("50") ? "selected" : "" %>>50</option>
	            <option value="100" <%= request.getParameter("limit") != null && request.getParameter("limit").equals("100") ? "selected" : "" %>>100</option>
	        </select>
	    </form>
	    <h3 class="totalrecords">Total No. of Records: <%=(request.getAttribute("totalBills") != null)? request.getAttribute("totalBills") : 0 %></h3>
	</div>
   	<% 
            	if(request.getAttribute("totalPages")!= null && (int)request.getAttribute("totalPages") >1){
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
                <th>Date</th>
                <th>Total Sales</th>
            </tr>
        </thead>
        <tbody>
            <%
            	SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
            	Map<String , Double> sales = (Map<String , Double>) request.getAttribute("salesRecord");
                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
                BillDao billDao = new BillDao();
                if (sales != null && !sales.isEmpty()) {
                    for ( Map.Entry<String, Double> entry : sales.entrySet()) {
            %>
                        <tr>
                            <td><%= dateFormatter.format(Date.valueOf(entry.getKey())) %></td>
                            <td><%= currencyFormatter.format(entry.getValue()) %></td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="4">No sales data available</td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
