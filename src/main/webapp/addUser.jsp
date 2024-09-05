<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="model.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New User</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    background-color: lightgray;
	    margin-left: 200px;
	    margin-top: 20px;
	    padding: 0;
	    display: flex;
	    flex-direction: column;
	    justify-content: center;
	}
	
	h1 {
	    color: black;
	    margin-bottom: 10px;
	    text-align: center;	
	}
	
	.fromContainer{
		display: flex;
	    flex-direction: column;
	    gap: 10px;
	    background-color: white;
	    border: 1px solid lightgray;
	    border-radius: 8px;
	    padding: 20px;
	    box-shadow: 0 0 10px gray;
	    align-items: center;
	    margin: auto;
	    width: 90%;
	    padding-top:0px;
	    margin-bottom: 30px;
	}
	
	.addUserForm {
	    display: grid;
	    grid-template-columns: 1fr 1fr;
	    gap: 10px;
	    border: 1px solid lightgray;
	    border-radius: 8px;
	    padding: 20px 0px 20px 20px;
	    justify-content: space-around;
	    align-items: center;
	    width: 90%;
	}
	
	.addUserForm div {
	    display: flex;
	    flex-direction: column;
	}
	
	.addUserForm label {
	    font-size: 14px;
	    margin-bottom: 5px;
	    color: black;
	}
	
	.addUserForm input,
	.addUserForm select {
	    width: 90%;
	    padding: 10px;
	    margin: 3px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.addUserForm select{
		width:95%;
	}
	
	.addUserForm #submit {
	    grid-column: span 2;
	    background-color: steelblue;
	    color: white;
	    padding: 10px 15px;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	    margin: auto;
	    width: fit-content;
	}
	
	.addUserForm #submit:hover {
	    background-color: purle;
	}
	
	h3 {
	    color: red;
	    margin-top: 20px;
	    font-size: 16px;
	    text-align: center;
	    margin-bottom: 0px;
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
        HttpSession customerSession = request.getSession();
        String previousPage = request.getHeader("Referer");
        customerSession.setAttribute("previousHeader", previousPage);
        User addUser = (User) session.getAttribute("addUser");
    %>
	
	<div class="fromContainer">
	<h1>Add User</h1>
	<form class="addUserForm" action="AddUserServlet" method="post">
		<div>
			<label for="userId">Enter User ID</label>
			<input type="text" name="userId" id="userId" value="<%= addUser != null ? addUser.getUserId() : "" %>" required>
		</div>
		<div>
			<label for="userName">Enter User Name</label>
			<input type="text" name="userName" id="userName" value="<%= addUser != null ? addUser.getUserName() : "" %>" required>
		</div>
		<div>
			<label for="email">Enter User Email</label>
			<input type="email" name="email" id="email" value="<%= addUser != null ? addUser.getEmail() : "" %>" required>
		</div>
		<div>
			<label for="password">Enter User Password</label>
			<input type="password" name="password" id="password" value="<%= addUser != null ? addUser.getPassword() : "" %>" required>
		</div>
		<div>
			<label for="age">Enter User Age</label>
			<input type="number" name="age" id="age" value="<%= addUser != null ? addUser.getAge() : "" %>" required>
		</div>
		<div>
			<label for="userRoleId">Enter User Role</label>
			<select name="userRoleId" id="userRoleId" required>
				<option value="101" <%= addUser != null && addUser.getUserRoleId() == 101 ? "selected" : "" %>>Admin</option>
				<option value="102" <%= addUser != null && addUser.getUserRoleId() == 102 ? "selected" : "" %>>Employee</option>
			</select>
		</div>
		<div>
			<label for="city">Enter User's City</label>
			<input type="text" name="city" id="city" value="<%= addUser != null ? addUser.getCity() : "" %>" required>
		</div>
		<div>
			<label for="gender">Enter User Gender</label>
			<select name="gender" id="gender" required>
				<option value="Male" <%= addUser != null && "Male".equals(addUser.getGender()) ? "selected" : "" %>>Male</option>
				<option value="Female" <%= addUser != null && "Female".equals(addUser.getGender()) ? "selected" : "" %>>Female</option>
			</select>
		</div>
		<div>
			<label for="date">Enter User Joining Date</label>
			<input type="date" name="date" id="date" value="<%= addUser != null ? addUser.getJoiningDate() : "" %>" required>
		</div>
		<div>
			<label for="shift">Enter User Shift</label>
			<select name="shift" id="shift" required>
				<option value="Day" <%= addUser != null && "Day".equals(addUser.getShift()) ? "selected" : "" %>>Day</option>
				<option value="Night" <%= addUser != null && "Night".equals(addUser.getShift()) ? "selected" : "" %>>Night</option>
				<option value="Full Time" <%= addUser != null && "Full Time".equals(addUser.getShift()) ? "selected" : "" %>>Full Time</option>
			</select>
		</div>
		<button type="submit" id="submit">Add User</button>
	</form>
	<%
        String result = request.getParameter("result");
        if(result != null){
            if(result.equals("0")){
                out.println("<h3>User ID is already present, please Enter a unique User ID.</h3>");
                session.removeAttribute("addUser");
            } else if(result.equals("1")){
                out.println("<h3>User Details Added Successfully...</h3>");
            }
        }
    %>
	</div>

</body>
</html>
