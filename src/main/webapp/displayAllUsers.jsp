<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="model.User"%>
<%@ page import="dao.UserDao"%>
<%@ page import="dao.UserRoleDao"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users Details</title>
<style type="text/css">
		body {
            font-family: Arial, sans-serif;
            background-color: WhiteSmoke;
            color: black;
            margin-left: 200px;
            margin-top: 30px;
        }
        
       	.addUser {
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
        .addUser:hover {
            text-decoration: underline;
        }

        h1 {
            text-align: center;
            margin-top: 0px;
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
            margin: 20px auto 50px auto;
        }

        table, th, td {
            border: 1px solid DarkGray; 
        }

        th, td {
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
<script type="text/javascript">
	function showProducts(billId) {
        window.location.href = 'updateUserDetails.jsp?userId=' + encodeURIComponent(billId);
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
	<br />
	<h1>Users Details</h1>
	<a class="addUser" href="addUser.jsp">Add User</a>

	<table id="employeeTable" border="1">
		<thead>
			<tr>
				<th>User ID</th>
				<th>User Name</th>
				<th>Email</th>
				<th>Age</th>
				<th>User Role</th>
				<th>City</th>
				<th>Gender</th>
				<th>Date of Joining</th>
				<th>Shift</th>
			</tr>
		</thead>
		<tbody>
			<%
                UserDao employeeDAO = new UserDao();
				UserRoleDao userRoleDao = new UserRoleDao();
                List<User> employees = employeeDAO.allUsers(); 

                for (User employee : employees) {
            %>
			<tr onclick="showProducts(<%= employee.getUserId() %>)">
				<td><%= employee.getUserId() %></td>
				<td><%= employee.getUserName() %></td>
				<td><%= employee.getEmail() %></td>
				<td><%= employee.getAge() %></td>
				<td><%= userRoleDao.getUserRole(employee.getUserRoleId()).getUserRoleName() %></td>
				<td><%= employee.getCity() %></td>
				<td><%= employee.getGender() %></td>
				<td><%= employee.getJoiningDate() %></td>
				<td><%= employee.getShift() %></td>
			</tr>
			<%
                }
            %>
		</tbody>
	</table>
</body>
</html>
