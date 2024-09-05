<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="model.User" %>
<%@ page import="dao.UserDao" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Details</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    background-color: lightgray;
	    margin-left: 200px;
	    margin-top: 30px;
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
	    margin-bottom: 20px;
	}
	
	.userUpdateForm {
	    display: grid;
	    grid-template-columns: 1fr 1fr;
	    gap: 20px;
	    background-color: white;
	    border: 1px solid lightgray;
	    border-radius: 8px;
	    padding: 20px 0px 20px 20px;
	    justify-content: space-around;
	    align-items: center;
	    width: 90%;
	}
	
	.userUpdateForm div {
	    display: flex;
	    flex-direction: column;
	}
	
	.userUpdateForm label {
	    font-size: 14px;
	    margin-bottom: 5px;
	    color: black;
	}
	
	.userUpdateForm input,
	.userUpdateForm select {
	    width: 90%;
	    padding: 10px;
	    margin: 3px 0;
	    border: 1px solid lightgray;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.userUpdateForm select{
		width:95%;
	}
	
	.userUpdateForm #submit {
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
	
	.userUpdateForm #submit:hover {
	    background-color: darkslateblue;
	}
	
	h3 {
	    color: red;
	    font-size: 16px;
	    text-align: center;
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
			int userId = Integer.parseInt(request.getParameter("userId"));
			UserDao userDao = new UserDao();
			User user = userDao.getUser(userId);
		%>
	
	<div class="fromContainer">
		<h1>User Details</h1>		
		
		<form class="userUpdateForm" action="UpdateUserDetailsServlet" method="post">
			<div>
				<label for="userId">User ID</label>
				<input type="text" name="userId" id="userId" value="<%= user.getUserId() %>" readonly>
			</div>
			<div>
				<label for="userName">User Name</label>
				<input type="text" name="userName" id="userName" value="<%= user.getUserName() %>" required>
			</div>
			<div>
				<label for="email">User Email</label>
				<input type="email" name="email" id="email" value="<%= user.getEmail() %>" required>
			</div>
			<div>
				<label for="age">User Age</label>
				<input type="number" name="age" id="age" value="<%= user.getAge() %>" required>
			</div>
			<div>
				<label for="userRoleId">User Role</label>
				<select name="userRoleId" id="userRoleId" required>
					<option value="101" <%= user.getUserRoleId() == 101 ? "selected" : "" %>>Admin</option>
					<option value="102" <%= user.getUserRoleId() == 102 ? "selected" : "" %>>Employee</option>
				</select>
			</div>
			<div>
				<label for="city">User Native City</label>
				<input type="text" name="city" id="city" value="<%= user.getCity() %>" required>
			</div>
			<div>
				<label for="gender">User Gender</label>
				<select name="gender" id="gender" required>
					<option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Male</option>
					<option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Female</option>
				</select>
			</div>
			<div>
				<label for="date">Employee Joining Date</label>
				<input type="date" name="date" id="date" value="<%= user.getJoiningDate() %>" required>
			</div>
			<div>
				<label for="shift">User Shift</label>
				<select name="shift" id="shift" required>
					<option value="Day" <%= "Day".equals(user.getShift()) ? "selected" : "" %>>Day</option>
					<option value="Night" <%= "Night".equals(user.getShift()) ? "selected" : "" %>>Night</option>
					<option value="Full Time" <%= "Full Time".equals(user.getShift()) ? "selected" : "" %>>Full Time</option>
				</select>
			</div>
			<button type="submit" id="submit">Update</button>
		</form>
	<%
        String result = request.getParameter("result");
        if(result != null){
            if(result.equals("0")){
                out.println("<h3>User ID is already present, please enter a unique User ID.</h3>");
                session.removeAttribute("addUser");
            } else if(result.equals("1")){
                out.println("<h3>User Details Updated Successfully...</h3>");
            }
        }
    %>
	</div>

</body>
</html>
