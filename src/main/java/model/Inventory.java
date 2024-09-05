package model;

public class Inventory {
    private int productId;
    private String productName;
    private int categoryId;
    private double price;
    private int units;

    public Inventory(int productId, String productName, double price, int units, int categoryId) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.units = units;
        this.categoryId = categoryId;
    }
    
    public Inventory() {};

    public Inventory(String productName, double price, int units, int categoryId) {
    	this.productName = productName;
    	this.price = price;
    	this.units = units;
    	this.categoryId = categoryId;
    }
    
    public Inventory(int productId, double price, int quantity) {
    	this.productId = productId;
    	this.price = price;
    	this.units = quantity;
    }
    
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getUnits() {
        return units;
    }

    public void setUnits(int units) {
        this.units = units;
    }
    
    public int getCategoryId() {
    	return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
    	this.categoryId = categoryId;
    }
}