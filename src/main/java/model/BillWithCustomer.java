package model;

import java.io.Serializable;

public class BillWithCustomer implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private Customer customer;
	private Bill bill;
	private int discountId;
    private double discountAmount;
    
	public BillWithCustomer(Customer customer, Bill bill) {
		this.customer = customer;
		this.bill = bill;
	}
	
	public BillWithCustomer(Bill bill, Customer customer, int discountId, double discountAmount) {
        this.bill = bill;
        this.customer = customer;
        this.discountId = discountId;
        this.discountAmount = discountAmount;
    }
	
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	
	public Customer getCustomer() {
		return customer;
	}
	
	public void setBill(Bill bill) {
		this.bill = bill;
	}
	
	public Bill getBill() {
		return bill;
	}
	
	public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }
}
