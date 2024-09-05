package model;

public class Product {
	private int billId;
	private int productId;
    private double price;
    private int quantity;
    private boolean isReturn;
    private boolean isExchange;
    private String returnDate;
    
    public Product() {
    	
    }
    
    public Product(int productId,double price, int quantity) {
    	this.productId = productId;
    	this.price = price;
    	this.quantity = quantity;
    }
    
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }


    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getBillId() {
    	return billId;
    }
    
    public void setbillId(int billId) {
    	this.billId = billId;
    }
    public String getProductName() {
    	return returnDate;
    }
    
    public void setProductName(String returnDate) {
    	this.returnDate = returnDate;
    }
    
    public boolean getIsReturn() {
    	return isReturn;
    }
    
    public void setIsReturn(boolean isReturn) {
    	this.isReturn = isReturn;
    }
    
    public boolean getIsExchange() {
    	return isExchange;
    }
    
    public void setIsExchange(boolean isExchange) {
    	this.isExchange = isExchange;
    }
}
