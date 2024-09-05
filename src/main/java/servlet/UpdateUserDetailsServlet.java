package servlet;

import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UpdateUserDetailsServlet extends HttpServlet{
private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int userId = Integer.parseInt(request.getParameter("userId"));
			String userName = request.getParameter("userName");
			String email = request.getParameter("email");
			int age = Integer.parseInt(request.getParameter("age"));
			int userRoleId = Integer.parseInt(request.getParameter("userRoleId"));
			String city = request.getParameter("city");
			String gender = request.getParameter("gender");
			String dateOfJoining = request.getParameter("date");
			String shift = request.getParameter("shift");
			
			User user = new User(userId,userName,email,age,userRoleId,city,gender,dateOfJoining,shift);
			UserDao userDao = new UserDao();
			int result = userDao.editUser(user);
			response.sendRedirect("updateUserDetails.jsp?result="+result+"&userId="+userId);
		}
		catch(NumberFormatException e) {
			e.printStackTrace();
			response.sendRedirect("updateUserDetails.jsp?result="+-2+"&userId="+request.getParameter("userId"));
		}
	}
}
