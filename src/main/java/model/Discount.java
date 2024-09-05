package model;

public class Discount {
	private int discountId;
	private String discountType;
	private double conditionAmount;
	private double discountPercentage;
	private String status;
	
	public Discount(String discountType, double conditionAmount, double discountPercentage) {
		this.discountType = discountType;
		this.conditionAmount = conditionAmount;
		this.discountPercentage = discountPercentage;
	}
	
	public Discount(int discountId, String discountType, double conditionAmount, double discountPercentage) {
		this.discountId = discountId;
		this.discountType = discountType;
		this.conditionAmount = conditionAmount;
		this.discountPercentage = discountPercentage;
	}
	
	public Discount(int discountId, String discountType, double conditionAmount, double discountPercentage, String status) {
		this.discountId = discountId;
		this.discountType = discountType;
		this.conditionAmount = conditionAmount;
		this.discountPercentage = discountPercentage;
		this.status = status;
	}
	
	public void setDiscountId(int discountId) {
		this.discountId = discountId;
	}
	
	public int getDiscountId() {
		return discountId;
	}
	
	public void setDiscountType(String discountType) {
		this.discountType = discountType;
	}
	
	public String getDiscountType() {
		return discountType;
	}
	
	public void setConditionAmount(double conditionAmount) {
		this.conditionAmount = conditionAmount;
	}
	
	public double getConditionAmount() {
		return conditionAmount;
	}
	
	public void setDiscountPercentage(double discountPercentage) {
		this.discountPercentage = discountPercentage;
	}
	
	public double getDiscountPercentage() {
		return discountPercentage;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return status;
	}
}
