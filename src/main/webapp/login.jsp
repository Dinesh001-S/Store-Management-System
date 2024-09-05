<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: lightgray;
            color: black;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }

        h1 {
            color: steelblue; 
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: darkslategray;
            text-align: left;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid darkgray;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            background-color: steelblue;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            border-radius: 4px;
            width: 100%;
        }

        button:hover {
            background-color: purple;
        }

        h4 {
            color: red;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    if (session.getAttribute("user") != null) {
        int userRole = ((User)session.getAttribute("user")).getUserRoleId();

        switch (userRole) {
            case 101:
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                break;
            case 102:
                response.sendRedirect(request.getContextPath() + "/bill.jsp");
                break;
            default:
                response.sendRedirect("defaultDashboard.jsp");
                break;
        }
    }
    %>
    <div class="login-container">
        <h1>Login</h1>
        <form action="loginServlet" method="post">
            <label for="userId">User Id:</label> 
            <input type="text" name="userId" id="userId" required /> 
            <label for="password">Password:</label> 
            <input type="password" name="password" id="password" required>
            <button type="submit">Submit</button>
        </form>
        
        <%	
            if(request.getParameter("outcome") != null){
                out.println("<h4>Login Unsuccessful, Wrong User Id and Password</h4>");
            }
        %>
    </div>
</body>
</html>
