package dao;

import java.sql.Date;

import model.User;

import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import security.Authentication;

public class UserDao {
	private Connection connection;
	public UserDao() {
		connection = Database.getConnection();
	}
		
	public int storeUserDetails(User user) {
    	
    	if(getUser(user.getUserId()) != null) {
    		return 0;
    	}
        String sql = "INSERT INTO user (userId, userName, email, age, userRoleId, city, gender, joiningDate, shift) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String authentication_sql = "INSERT INTO authentication (userId, password) VALUES (?,?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql);
        		PreparedStatement stmt = connection.prepareStatement(authentication_sql)
        		) {
            pstmt.setInt(1, user.getUserId());
            pstmt.setString(2, user.getUserName());
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getAge());
            pstmt.setInt(5, user.getUserRoleId());
            pstmt.setString(6, user.getCity());
            pstmt.setString(7, user.getGender());
            pstmt.setDate(8, Date.valueOf(user.getJoiningDate()));
            pstmt.setString(9, user.getShift());
            pstmt.executeUpdate();
            
            String hashedPassword = Authentication.hashPassword(user.getPassword());
            stmt.setInt(1, user.getUserId());
            stmt.setString(2, hashedPassword);
            stmt.executeUpdate();
        }
        catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return 1;
    }
	
	public List<User> allUsers() {
		SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
        String query = "SELECT * FROM user";
        List<User> users = new ArrayList<>();
        
        try{
        	PreparedStatement preparedStatement = connection.prepareStatement(query);
    		ResultSet resultSet = preparedStatement.executeQuery();
    		
            while (resultSet.next()) {
            	users.add(new User(
            			resultSet.getInt("userId"),
            			resultSet.getString("userName"),
            			resultSet.getString("email"),
            			resultSet.getInt("age"),
            			resultSet.getInt("userRoleId"),
            			resultSet.getString("city"),
            			resultSet.getString("gender"),
            			(dateFormatter.format(resultSet.getDate("joiningDate"))),
            			resultSet.getString("shift")
            			));
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
	
	public User getUser(int userId) {
        String query = "SELECT * FROM user WHERE userId = ?";        
        try{
        	PreparedStatement preparedStatement = connection.prepareStatement(query);
        	preparedStatement.setInt(1, userId);
    		ResultSet resultSet = preparedStatement.executeQuery();
    		
            if(resultSet.next()) {
            	return new User(
            			resultSet.getInt("userId"),
            			resultSet.getString("userName"),
            			resultSet.getString("email"),
            			resultSet.getInt("age"),
            			resultSet.getInt("userRoleId"),
            			resultSet.getString("city"),
            			resultSet.getString("gender"),
            			(resultSet.getDate("joiningDate")).toString(),
            			resultSet.getString("shift")
            			);
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
	
	public User AuthenticateUser(int userId, String password) {
		String sql = "SELECT * FROM authentication WHERE userId = ?";
		try {
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String HashedPassword = rs.getString("password");
				if(Authentication.verifyPassword(password, HashedPassword)) {
					return getUser(userId);	
				}
			}

		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
		
	public int getUserRole(int userId) {
		String sql = "SELECT userRoleId FROM user WHERE userId = ?";
		try {
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("userRoleId");
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return -1;
	}
	
	public int editUser(User user) {
		//User userCheck = getUser(user.getUserId());
		try {
			String sql = "UPDATE user SET userName = ?, email = ?, age = ?, userRoleId = ?, city = ?, gender = ?, joiningDate = ?, shift = ? WHERE userId = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getEmail());
			pstmt.setInt(3, user.getAge());
			pstmt.setInt(4, user.getUserRoleId());
			pstmt.setString(5, user.getCity());
			pstmt.setString(6, user.getGender());
			pstmt.setDate(7, Date.valueOf(user.getJoiningDate()));
			pstmt.setString(8, user.getShift());
			pstmt.setInt(9, user.getUserId());
			pstmt.executeUpdate();
		}
		catch(SQLException e) {
			e.printStackTrace();
			return -1;
		}
		
		return 1;
	}
}
