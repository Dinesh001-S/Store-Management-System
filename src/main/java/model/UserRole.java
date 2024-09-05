package model;

public class UserRole {
	private int userRoleId;
	private String userRoleName;
	public UserRole(int userRoleId, String userRoleName) {
		this.userRoleId = userRoleId;
		this.userRoleName = userRoleName;
	}
	
	public void setUserRoleId(int userRoleId) {
		this.userRoleId = userRoleId;
	}
	
	public int getUserRoleId() {
		return userRoleId;
	}
	
	public void setUserRoleName(String userRoleName) {
		this.userRoleName = userRoleName;
	}
	
	public String getUserRoleName() {
		return userRoleName;
	}
}
