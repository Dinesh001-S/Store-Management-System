package model;

public class FormData {
    private String date;
    private String customerPhoneNo;
    private String[] productIds;
    private String[] quantities;

    public FormData(String date, String customerPhoneNo, String[] productIds, String[] quantities) {
        this.date = date;
        this.customerPhoneNo = customerPhoneNo;
        this.productIds = productIds;
        this.quantities = quantities;
    }
    
    public void setDate(String date) {
    	this.date = date;
    }

    public String getDate() {
        return date;
    }
    
    public void setCustomerPhoneNo(String customerPhoneNo) {
    	this.customerPhoneNo = customerPhoneNo;
    }

    public String getCustomerPhoneNo() {
        return customerPhoneNo;
    }
    
    public void setProductIds(String[] productIds) {
    	this.productIds = productIds;
    }

    public String[] getProductIds() {
        return productIds;
    }
    
    public void setQuantities(String[] quantities) {
    	this.quantities = quantities;
    }

    public String[] getQuantities() {
        return quantities;
    }
}
