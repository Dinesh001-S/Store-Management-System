package model;

import java.io.Serializable;

public class Customer implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private int customerId;
	private String customerName;
	private String phoneNo;
	private String email;
	
	public Customer( String customerName, String phoneNo, String email){
		this.customerName = customerName;
		this.phoneNo = phoneNo;
		this.email = email;
	}
	
	public Customer(int customerId, String customerName, String phoneNo, String email){
		this.customerId = customerId;
		this.customerName = customerName;
		this.phoneNo = phoneNo;
		this.email = email;
	}
	
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	
	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	
	public String getCustomerName() {
		return customerName;
	}
	
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	
	public String getPhoneNo() {
		return phoneNo;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getEmail() {
		return email;
	}
}
