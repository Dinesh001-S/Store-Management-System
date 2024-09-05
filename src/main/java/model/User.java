package model;

import java.io.Serializable;

public class User implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private int userId;
    private String userName;
    private String email;
    private String password;
    private int age;
    private int userRoleId;
    private String city;
    private String gender;
    private String joiningDate;
    private String shift;

    public User(int userId, String userName, String email, String password, int age, int userRoleId, String city, String gender, String joiningDate, String shift) {
        this.userId = userId;
        this.userName = userName;
        this.email = email;
        this.password = password;
        this.age = age;
        this.userRoleId = userRoleId;
        this.city = city;
        this.gender = gender;
        this.joiningDate = joiningDate;
        this.shift = shift;
    }
    
    public User(int userId, String userName, String email, int age,int userRole, String city, String gender, String joiningDate, String shift) {
    	this.userId = userId;
        this.userName = userName;
        this.email = email;
        this.age = age;
        this.userRoleId = userRole;
        this.city = city;
        this.gender = gender;
        this.joiningDate = joiningDate;
        this.shift = shift;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getAge() {
        return age;
    }

    public void setUserRoleId(int userRoleId) {
        this.userRoleId = userRoleId;
    }

    public int getUserRoleId() {
        return userRoleId;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCity() {
        return city;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getGender() {
        return gender;
    }

    public void setJoiningDate(String joiningDate) {
        this.joiningDate = joiningDate;
    }

    public String getJoiningDate() {
        return joiningDate;
    }

    public void setShift(String shift) {
        this.shift = shift;
    }

    public String getShift() {
        return shift;
    }
}