<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            margin: 0;
            min-width:1000px;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            width: 200px;
            background-color: steelblue;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 60px;
            line-height: 1;
        }

        .sidebar a {
            display: block;
            color: white;
            padding: 15px;
            text-decoration: none;
            border: 1px solid steelblue;
        }

        .sidebar a.active, .sidebar a:hover, .dropdown a.active {
            background-color: aliceblue;
            color: steelblue;
        }

        .sidebar h1 {
            color: white;
            font-size: 26pt;
        }

        .content {
            margin-left: 250px;
            padding: 20px;
        }

        .topbar {
            height: 60px;
            background-color: #77c6f7;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            position: fixed;
            top: 0;
            left: 200px;
            right: 0;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
        }

        .topbar h2 {
            margin: 0;
            font-size: 24px;
            color: whitesmoke;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .logout-btn {
            background-color: black;
            border: none;
            padding: 10px 20px;
            color: white;
            cursor: pointer;
        }

        .logout-btn:hover {
            background-color: #3a3a3a;
            color: white;
        }

        .sidebar .dropdown {
            display: none;
            background-color: steelblue;
            margin-left: 20px;
        }

        .sidebar .dropdown a {
            padding: 10px 15px;
            font-size: 14px;
        }

        .sidebar .reports:hover .dropdown {
            display: block;
        }
    </style>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            toggleDropdown();
        });

        function toggleDropdown() {
            const currentUrl = window.location.href;
            const billReportUrls = ["BillReportServlet", "CustomerSalesServlet", "CategorySalesServlet", "DaySalesReportServlet"];
            const dropdown = document.querySelector(".sidebar .dropdown");

            let shouldShowDropdown = billReportUrls.some(url => currentUrl.includes(url));

            if (shouldShowDropdown) {
                dropdown.style.display = "block";
            }
        }

        function categorySalesReport() {
            document.getElementById("categorySalesReport").submit();
        }

        function customerSalesReport() {
            document.getElementById("customerSalesReport").submit();
        }

        function billReports() {
            document.getElementById("billReports").submit();
        }

        function dayWiseSalesReport() {
            document.getElementById("daySalesReport").submit();
        }

        function displayAllBills() {
            document.getElementById("displayAllBills").submit();
        }
    </script>
</head>
<body>
    <div class="sidebar">
        <a href="dashboard.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "dashboard")}'>active</c:if>">Dashboard</a>
        <a href="displayAllUsers.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "User")}'>active</c:if>">Users</a>
        <a href="displayAllCustomers.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "Customer")}'>active</c:if>">Customers</a>
        <a href="#" onclick="displayAllBills()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "Bill") || fn:contains(pageContext.request.requestURI, "bill.jsp") || fn:contains(pageContext.request.requestURI, "productReturn.jsp")}'>active</c:if>">Bills</a>
        <a href="Inventory.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "Inventory")}'>active</c:if>">Inventory</a>
        <a href="displayAllDiscounts.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "Discount")}'>active</c:if>">Discount</a>

        <div class="reports">
            <a href="#" onclick="billReports()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "Report")}'>active</c:if>">Reports</a>
            <div class="dropdown">
                <a href="#" onclick="billReports()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "billReports")}'>active</c:if>">Bill Reports</a>
                <a href="#" onclick="customerSalesReport()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "customerSalesReport")}'>active</c:if>">Customer Sales Report</a>
                <a href="#" onclick="categorySalesReport()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "categorySalesReport")}'>active</c:if>">Category Sales Report</a>
                <a href="#" onclick="dayWiseSalesReport()" class="<c:if test='${fn:contains(pageContext.request.requestURI, "dayWiseSalesReport")}'>active</c:if>">Day Wise Sales Report</a>
            </div>
        </div>
    </div>

    <div class="topbar">
        <h2>Store Management System</h2>
        <form action="logoutServlet" method="get">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>

    <form id="displayAllBills" action="DisplayBillsServlet" method="get"></form>
    <form id="billReports" action="BillReportServlet" method="get"></form>
    <form id="customerSalesReport" action="CustomerSalesServlet" method="get"></form>
    <form id="categorySalesReport" action="CategorySalesServlet" method="get"></form>
    <form id="daySalesReport" action="DaySalesReportServlet" method="get"></form>

    <div class="content">
    </div>

</body>
</html>
