package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDao;
import model.User;

public class AddUserServlet extends HttpServlet{
	private final static long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		int userId = Integer.parseInt(request.getParameter("userId"));
		String userName = request.getParameter("userName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		int age = Integer.parseInt(request.getParameter("age"));
		int userRoleId = Integer.parseInt(request.getParameter("userRoleId"));
		String city = request.getParameter("city");
		String gender = request.getParameter("gender");
		String dateOfJoining = request.getParameter("date");
		String shift = request.getParameter("shift");
		
		//String[] dateSplit = date.split("-");
		
		//int dateOfJoining = Integer.parseInt(dateSplit[0]) * 10000 + Integer.parseInt(dateSplit[1]) * 100 + Integer.parseInt(dateSplit[2]);
		
		User user = new User(userId, userName, email, password, age,userRoleId, city, gender, dateOfJoining , shift);
        UserDao userDao = new UserDao();
        int result = userDao.storeUserDetails(user);
        if(result == 1) {
			System.out.println("User Successfully Added...");
			response.sendRedirect("addUser.jsp?result="+1);
		}
        else if(result == 0) {
        	HttpSession session = request.getSession();
        	session.setAttribute("addUser", user);
        	response.sendRedirect("addUser.jsp?result="+0);
        }
	}
}