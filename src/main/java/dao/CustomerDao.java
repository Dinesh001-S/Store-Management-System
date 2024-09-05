package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.sql.Connection;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

import model.Customer;
import model.CustomerSales;
import model.Bill;

public class CustomerDao {
	private Connection connection;
	public CustomerDao() {
		connection = Database.getConnection();
	}
	public int storeCustomerDetails(Customer customer) {
		try {
			String sql = "INSERT INTO customerdetails ( customerName, phoneNo, email) VALUES ( ?, ?, ?)";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			
	        pstmt.setString(1, customer.getCustomerName());
	        pstmt.setString(2, customer.getPhoneNo());
	        pstmt.setString(3, customer.getEmail());
	        pstmt.executeUpdate();
		}
		catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
		return 1;
	}
	
	public int getCustomerIdByPhoneNo(String phoneNo) {
		int customerId = -1;
		try {
			String sql = "SELECT customerId FROM customerdetails where phoneNo = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			
			pstmt.setString(1,phoneNo);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("customerId");
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return customerId;
	}
	
	public Customer getCustomer(int customerId) {		
		try {
			String sql = "SELECT * FROM customerdetails WHERE customerId = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, customerId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return new Customer(
						rs.getInt("customerId"),
						rs.getString("customerName"),
						rs.getString("phoneNo"),
						rs.getString("email")
						);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	public List<Customer> getAllCustomerDetails(){
		List<Customer> customers = new ArrayList<>();
		
		try {
			String sql = "SELECT * FROM customerdetails";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				customers.add(
						new Customer(
								rs.getInt("customerId"),
								rs.getString("customerName"),
								rs.getString("phoneNo"),
								rs.getString("email")
								)
						);
			}
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return customers;
	}
	
	public int updateCustomerDetails(Customer customer) {
        try {
            String sql = "UPDATE customerdetails SET customerName = ?, email = ?, phoneNo = ? WHERE customerId = ?";
            PreparedStatement pstmt = connection.prepareStatement(sql);
            pstmt.setString(1, customer.getCustomerName());
            pstmt.setString(2, customer.getEmail());
            pstmt.setString(3, customer.getPhoneNo());
            pstmt.setInt(4, customer.getCustomerId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }

        return 1;
    }
	
	public double getCustomerTotalSpendByMonth(int customerId) {
		try {
			String sql = "SELECT customerId, SUM(total) as total FROM Bill WHERE customerId = ? AND YEAR(date) = YEAR(CURRENT_DATE) AND MONTH(date) = MONTH(CURRENT_DATE) Group by customerId";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1,customerId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getDouble("total");
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return -1.00;
		}
		return 0.00;
	}
	
	public List<CustomerSales> getAllCustomerSales() throws Exception {
        String query = "SELECT customerdetails.customerId as customerId,customerdetails.customerName as customerName,count(bill.customerId) as totalBills, sum(bill.total) as totalAmount FROM customerdetails INNER JOIN bill ON customerdetails.customerId = bill.customerId GROUP BY customerdetails.customerId order by customerId ASC";

        List<CustomerSales> customerBillDetails = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CustomerSales details = new CustomerSales();
                details.setCustomerId(rs.getInt("customerId"));
                details.setCustomerName(rs.getString("CustomerName"));
                details.setTotalBills(rs.getInt("totalBills"));
                details.setTotalAmount(rs.getDouble("totalAmount"));
                customerBillDetails.add(details);
            }
        }
        return customerBillDetails;
    }

	public List<Bill> getCustomerBills(int customerId, String filterType, String sDate, String eDate) {
		SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
    	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:aa");
	    List<Bill> bills = new ArrayList<>();
	    String query = "SELECT * FROM bill WHERE customerId = ?" + getFilterCondition(filterType,sDate,eDate) +"order by billId desc";
	    
	    try (
	         PreparedStatement ps = connection.prepareStatement(query)) {
	        ps.setInt(1, customerId);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Bill bill = new Bill();
	    			int billId = rs.getInt("billId");
	    			int userId = rs.getInt("userId");
	    			String date = dateFormatter.format(rs.getDate("date"));
	    			String time = timeFormatter.format(rs.getTime("time"));
	    			double subtotal = rs.getDouble("subtotal");
	    			String discountType = rs.getString("discountType");
	    			double discountPercentage = rs.getDouble("discountPercentage");
	    			double discountAmount = rs.getDouble("discountAmount");
	    			double tax_percentage = rs.getDouble("tax_percentage");
	    			double taxAmount = rs.getDouble("taxAmount");
	    			double total = rs.getDouble("total");
	    			
	    			bill.setBillId(billId);
	    			bill.setEmployeeId(userId);
	    			bill.setCustomerName(getCustomer(customerId).getCustomerName());
	    			bill.setCustomerId(customerId);
	    			bill.setDate(date);
	    			bill.setTime(time);
	    			bill.setSubTotal(subtotal);
	    			bill.setDiscountType(discountType);
	    			bill.setDiscountPercentage(discountPercentage);
	    			bill.setDiscountAmount(discountAmount);
	    			bill.setTaxPercentage(tax_percentage);
	    			bill.setTaxAmount(taxAmount);
	    			bill.setTotal(total);
	                bills.add(bill);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return bills;
	}

	private String getFilterCondition(String filterType, String sDate, String eDate) {
	    switch (filterType) {
	        case "today":
	            return "and DATE(date) = CURDATE()";
	        case "month":
	            return "and MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())";
	        case "week":
	        	return "and week(date) = week(current_date) and year(date) = year(date)";
	        case "date":
	            return "and DATE(date) = '" + sDate + "'";
	        case "dateRange":
	            return "and DATE(date) BETWEEN '" + sDate + "' AND '" + eDate + "'";
	        default:
	            return " "; 
	    }
	}
	
	public List<CustomerSales> getFilteredCustomerSales(String specificDate, String fromDate, String toDate, String dateFilter, int limit, int offset) {
        List<CustomerSales> customerSalesList = new ArrayList<>();
        String query = "SELECT customerdetails.customerId, customerdetails.customerName, COUNT(bill.billId) AS totalBills, SUM(bill.total) AS totalAmount FROM bill JOIN customerdetails ON bill.customerId = customerdetails.customerId";
        if (specificDate != null && !specificDate.isEmpty()) {
            query += " where DATE(bill.date) = ?";
        } else if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            query += " where DATE(bill.date) BETWEEN ? AND ?";
        } else if (dateFilter != null && !dateFilter.equals("all")) {
            switch (dateFilter) {
                case "today":
                    query += " where DATE(bill.date) = CURDATE()";
                    break;
                case "month":
                    query += " where MONTH(bill.date) = MONTH(CURDATE()) AND YEAR(bill.date) = YEAR(CURDATE())";
                    break;
                case "week":
                    query += " where WEEK(bill.date) = WEEK(CURDATE())";
                    break;
            }
        }

        query += " GROUP BY customerdetails.customerId, customerdetails.customerName order by customerdetails.customerId LIMIT ? OFFSET ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;

            if (specificDate != null && !specificDate.isEmpty()) {
                ps.setString(paramIndex++, specificDate);
            } else if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
                ps.setString(paramIndex++, fromDate);
                ps.setString(paramIndex++, toDate);
            }
            
            ps.setInt(paramIndex++, limit); 
	        ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerSales sales = new CustomerSales();
                    sales.setCustomerId(rs.getInt("customerId"));
                    sales.setCustomerName(rs.getString("customerName"));
                    sales.setTotalBills(rs.getInt("totalBills"));
                    sales.setTotalAmount(rs.getDouble("totalAmount"));
                    customerSalesList.add(sales);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customerSalesList;
    }
	
	public int getTotalCustomerSales(String specificDate, String fromDate, String toDate, String dateFilter) {
        int totalSales = 0;
		String query = "select count(*) from (SELECT count(*) FROM bill JOIN customerdetails ON bill.customerId = customerdetails.customerId";
        if (specificDate != null && !specificDate.isEmpty()) {
            query += " where DATE(bill.date) = ?";
        } else if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            query += " where DATE(bill.date) BETWEEN ? AND ?";
        } else if (dateFilter != null && !dateFilter.equals("all")) {
            switch (dateFilter) {
                case "today":
                    query += " where DATE(bill.date) = CURDATE()";
                    break;
                case "month":
                    query += " where MONTH(bill.date) = MONTH(CURDATE()) AND YEAR(bill.date) = YEAR(CURDATE())";
                    break;
                case "week":
                    query += " where WEEK(bill.date) = WEEK(CURDATE())";
                    break;
            }
        }

        query += " GROUP BY customerdetails.customerId) as totalSales";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;

            if (specificDate != null && !specificDate.isEmpty()) {
                ps.setString(paramIndex++, specificDate);
            } else if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
                ps.setString(paramIndex++, fromDate);
                ps.setString(paramIndex++, toDate);
            }
            

            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    totalSales = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalSales;
    }

}
