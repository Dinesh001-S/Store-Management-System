package servlet;

import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

public class LoginServlet extends HttpServlet{
	private final static long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession(false); 
	    
//	    if (session == null || session.getAttribute("user") == null) {
//	        response.sendRedirect("login.jsp"); 
//	        return;
//	    }

	    int userId = Integer.parseInt(request.getParameter("userId"));
	    String password = request.getParameter("password");
	    
	    UserDao userDao = new UserDao();
	    User user = userDao.AuthenticateUser(userId, password);
	    
	    if (user != null) {
	        session.setAttribute("user", user);
	        if(user.getUserRoleId() == 102) {
	        	response.sendRedirect("bill.jsp");
	        }
	        
	        else {
	        	response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
	        }
	        System.out.println("Login Successful"); 
	    } else {
	        response.sendRedirect("login.jsp?outcome=" + -1);
	        System.out.println("Login Unsuccessful");
	    }
	}

}
