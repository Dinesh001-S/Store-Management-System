package dao;

import model.UserRole;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRoleDao {
	private Connection connection;
	
	public UserRoleDao(){
		connection = Database.getConnection();
	}
	
	public UserRole getUserRole(int userRoleId) {
		String sql = "SELECT * FROM user_role WHERE userRoleId = ?";
		try {
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, userRoleId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return new UserRole(
						rs.getInt("userRoleId"),
						rs.getString("userRoleName")
						);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
