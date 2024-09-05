<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        .employeeHeader {
            margin: 0;
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
    </style>
</head>
<body class="employeeHeader">
    <div class="sidebar">
        <a href="bill.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "bill.js")}'>active</c:if>">Bill</a>
        <a href="viewBillBySpecificEmployee.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "viewBillBySecificEmployee")}'>active</c:if>">Bills Report</a>
        <a href="productReturn.jsp" class="<c:if test='${fn:contains(pageContext.request.requestURI, "productReturn.jsp")}'>active</c:if>">Product Return</a>
    </div>

    <div class="topbar">
        <h2>Store Management System</h2>
        <form action="logoutServlet" method="get">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>

    <div class="content">
    </div>

</body>
</html>
