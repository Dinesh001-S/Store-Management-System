package model;

import java.io.Serializable;
import java.util.Map;

public class Bill implements Serializable{
	private static final long serialVersionUID = 1L;
	
    private int billId;
    private int userId;
    private int customerId;
    private String customerName;
    private String date;
    private String time;
    private Map<Integer, Product> products;
    private double subtotal;
    private String discountType;
    private double discountPercentage;
    private double discountAmount;
    private double taxPercentage;
    private double taxAmount;
    private double total;
    private double returnCreditAmount;
    private double refundAmount;
    private double exchangeAmount;

    
    public Bill(int billId, int userId, int customerId,String date,String time, double total) {
    	 this.billId = billId;
         this.userId = userId;
         this.customerId = customerId;
         this.date = date;
         this.time = time;
         this.total = total;
    }

    public Bill(int billId, int userId, int customerId, String date,String time, Map<Integer, Product> products, double total) {
        this.billId = billId;
        this.userId = userId;
        this.customerId = customerId;
        this.date = date;
        this.time = time;
        this.products = products;
        this.total = total;
    }
    
    public Bill(int billId, int userId, int customerId, String date,String time, Map<Integer, Product> products, double total,double taxPercentage, double subtotal, double taxAmount) {
        this.billId = billId;
        this.userId = userId;
        this.customerId = customerId;
        this.date = date;
        this.time = time;
        this.products = products;
        this.total = total;
        this.taxPercentage = taxPercentage;
        this.taxAmount = taxAmount;
        this.subtotal = subtotal;
    }

    public Bill(int userId, int customerId, String date,String time, Map<Integer, Product> products) {
        this.userId = userId;
        this.customerId = customerId;
        this.date = date;
        this.time = time;
        this.products = products;
        this.total = calculateTotal();
    }
    
    public Bill(int userId, int customerId, String date,String time, Map<Integer, Product> products, double taxPercentage, double taxAmount,double total) {
        this.userId = userId;
        this.customerId = customerId;
        this.date = date;
        this.time = time;
        this.products = products;
        this.subtotal = calculateTotal();
        this.taxPercentage = taxPercentage;
        this.taxAmount = taxAmount;
        this.total = total;
    }
    
    public Bill(int userId, int customerId, String date,String time, Map<Integer, Product> products,String discountType,double discountPercentage, double discountAmount, double taxPercentage, double taxAmount,double total) {
        this.userId = userId;
        this.customerId = customerId;
        this.date = date;
        this.time = time;
        this.products = products;
        this.subtotal = calculateTotal();
        this.discountType = discountType;
        this.discountPercentage = discountPercentage;
        this.discountAmount = discountAmount;
        this.taxPercentage = taxPercentage;
        this.taxAmount = taxAmount;
        this.total = total;
    }
    
    public Bill() {
    	
    }

    private double calculateTotal() {
        double subtotal = 0;
        for (Product product : products.values()) {
            subtotal += product.getPrice() * product.getQuantity();
        }
        return subtotal;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getEmployeeId() {
        return userId;
    }

    public void setEmployeeId(int userId) {
        this.userId = userId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
    	return customerName;
    }
    
    public void setCustomerName(String customerName) {
    	this.customerName = customerName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    
    public String getTime() {
    	return time;
    }
    
    public void setTime(String time) {
    	this.time = time;
    }

    public Map<Integer, Product> getInventorys() {
        return products;
    }

    public void setInventorys(Map<Integer, Product> products) {
        this.products = products;
        this.subtotal = calculateTotal();
    }
    
    public double getSubTotal() {
    	return subtotal;
    }
    
    public void setSubTotal(double subtotal) {
    	this.subtotal = subtotal;
    }
    
    public String getDiscountType() {
    	return discountType;
    }
    
    public void setDiscountType(String discountType) {
    	this.discountType = discountType;
    }
    
    public double getDiscountPercentage() {
    	return discountPercentage;
    }
    
    public void setDiscountPercentage(double discountPercentage) {
    	this.discountPercentage = discountPercentage;
    }
    
    public double getDiscountAmount() {
    	return discountAmount;
    }
    
    public void setDiscountAmount(double discountAmount) {
    	this.discountAmount = discountAmount;
    }
    
    public double getTaxPercentage() {
        return taxPercentage;
    }

    public void setTaxPercentage(double taxPercentage) {
        this.taxPercentage = taxPercentage;
    }
    
    public double getTaxAmount() {
    	return this.taxAmount;
    }
    
    public void setTaxAmount(double taxAmount) {
    	this.taxAmount = taxAmount;
    }
    
    public double getTotal() {
    	return total;
    }
    
    public void setTotal(double total) {
    	this.total = total;
    }
    
    public double getReturnCreditAmount() {
        return returnCreditAmount;
    }

    public void setReturnCreditAmount(double returnCreditAmount) {
        this.returnCreditAmount = returnCreditAmount;
    }

    public double getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(double refundAmount) {
        this.refundAmount = refundAmount;
    }

    public double getExchangeAmount() {
        return exchangeAmount;
    }

    public void setExchangeAmount(double exchangeAmount) {
        this.exchangeAmount = exchangeAmount;
    }
}
