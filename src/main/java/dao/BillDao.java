package dao;

import model.Product;
import model.Bill;

import java.util.ArrayList;
import java.util.List;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Comparator;

public class BillDao {

	private Connection connection;
    
    public BillDao() {
        connection = Database.getConnection();
    }

    public int addBill(Bill bill) {
        String sql = "INSERT INTO bill (userId, customerId, date,time, total,tax_percentage,subtotal,taxAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, bill.getEmployeeId());
            stmt.setInt(2, bill.getCustomerId());
            stmt.setDate(3, java.sql.Date.valueOf(bill.getDate()));
            
            String timeStr = bill.getTime();
            String formattedTime = timeStr.substring(0, 2) + ":" + timeStr.substring(2, 4) + ":" + timeStr.substring(4);
            
            stmt.setTime(4, java.sql.Time.valueOf(formattedTime));
            stmt.setDouble(5, bill.getTotal());
            stmt.setDouble(6, bill.getTaxPercentage());
            stmt.setDouble(7, bill.getSubTotal());
            stmt.setDouble(8, bill.getTaxAmount());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating bill failed");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);

                    insertInventorys(generatedId, bill.getInventorys());

                    return generatedId;
                }
                else {
                    throw new SQLException("Creating bill failed");
                }
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            return -1; 
        }
    }
    
    public int addBillWithDiscount(Bill bill) {
        String sql = "INSERT INTO bill (userId, customerId, date,time, total,tax_percentage,subtotal,taxAmount,discountType,discountPercentage,discountAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?,?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, bill.getEmployeeId());
            stmt.setInt(2, bill.getCustomerId());
            stmt.setDate(3, java.sql.Date.valueOf(bill.getDate()));
            
            String timeStr = bill.getTime();
            String formattedTime = timeStr.substring(0, 2) + ":" + timeStr.substring(2, 4) + ":" + timeStr.substring(4);
            
            stmt.setTime(4, java.sql.Time.valueOf(formattedTime));
            stmt.setDouble(5, bill.getTotal());
            stmt.setDouble(6, bill.getTaxPercentage());
            stmt.setDouble(7, bill.getSubTotal());
            stmt.setDouble(8, bill.getTaxAmount());
            stmt.setString(9, bill.getDiscountType());
            stmt.setDouble(10, bill.getDiscountPercentage());
            stmt.setDouble(11, bill.getDiscountAmount());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating bill failed");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);

                    insertInventorys(generatedId, bill.getInventorys());

                    return generatedId;
                }
                else {
                    throw new SQLException("Creating bill failed");
                }
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            return -1; 
        }
    }
    
    public void updateBillTotal(int billId , double total) {
    	try {
    		String sql = "update bill set total = ? where billId = ?";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		pstmt.setDouble(1,total);
    		pstmt.setInt(2, billId);
    		pstmt.executeUpdate();
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    	}
    }

    private void insertInventorys(int billId, Map<Integer, Product> products) throws SQLException {
        String sql = "INSERT INTO bill_product (billId, productId, price, quantity,isExchange) VALUES (?, ?, ?, ?,false)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (Product product : products.values()) {
                stmt.setInt(1, billId);
                stmt.setInt(2, product.getProductId());
                stmt.setDouble(3, product.getPrice());
                stmt.setInt(4, product.getQuantity());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public Bill getBill(int billId) {
        String sql = "SELECT * FROM bill WHERE billId = ?";
        String productSql = "SELECT * FROM bill_product WHERE billId = ? and isReturn = false";
        
        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
    	SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm:aa");
        
        Map<Integer, Product> products = new HashMap<>();

        try (
             PreparedStatement stmt = connection.prepareStatement(sql);
             PreparedStatement productStmt = connection.prepareStatement(productSql)
         )
        {
            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("userId");
                int customerId = rs.getInt("customerId");
                String date = dateFormatter.format(rs.getDate("date"));
                String time = timeFormatter.format(rs.getTime("time"));
                String discountType = rs.getString("discountType");
                double discountPercentage = rs.getDouble("discountPercentage");
                double discountAmount = rs.getDouble("discountAmount");
                double taxPercentage = rs.getDouble("tax_percentage");
                double taxAmount = rs.getDouble("taxAmount");
                double total = rs.getDouble("total");
                double returnCreditedAmount = rs.getDouble("return_Credited_Amount");
                double refundAmount = rs.getDouble("refund_Amount");
                double exchangeAmount = rs.getDouble("exchange_Amount");
                double subtotal = rs.getDouble("subtotal");

                productStmt.setInt(1, billId);
                ResultSet productRs = productStmt.executeQuery();
                while (productRs.next()) {
                    int productId = productRs.getInt("productId");
                    double price = productRs.getDouble("price");
                    int quantity = productRs.getInt("quantity");
                    products.put(productId, new Product(productId, price, quantity));
                }
                Bill bill =  new Bill(userId, customerId, date,time, products, discountType, discountPercentage,discountAmount, taxPercentage,taxAmount, total);
                bill.setBillId(billId);
                bill.setReturnCreditAmount(returnCreditedAmount);
                bill.setRefundAmount(refundAmount);
                bill.setExchangeAmount(exchangeAmount);
                bill.setSubTotal(subtotal);
                return bill;
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public double getTodaySales() {
    	try {
    		String sql = "select sum(total) as todaySales from bill where date(date) = current_date";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		
    		if(rs.next()) {
    			return rs.getDouble("todaySales");
    		}
    	}
    	
    	catch(SQLException e){
    		e.printStackTrace();
    	}
    	
    	return 0.0;
    }
    
    public double getCurrentMonthSales() {
    	try {
    		String sql = "select sum(total) as monthSales from bill where month(date) = month(current_date)";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		
    		if(rs.next()) {
    			return rs.getDouble("monthSales");
    		}
    	}
    	
    	catch(SQLException e){
    		e.printStackTrace();
    	}
    	
    	return 0.0;
    }
    
    public List<Bill> getTodayBills(){
    	List<Bill> todayBills = new ArrayList<>();
    	SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
    	SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm:aa");
    	try {
    		String sql = "select * from bill where date(date) = current_date";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		
    		while(rs.next()) {
    			Bill bill = new Bill();
    			int billId = rs.getInt("billId");
    			int customerId = rs.getInt("customerId");
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
    			
    			todayBills.add(bill);
    		}
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return null;
    	}
    	
    	return todayBills;
    }
    
    public List<Bill> getallBills() {
    	List<Bill> bills = new ArrayList<>();
    	
    	SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
    	SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm:aa");
    	
    	String sql = "select * from bill order by date desc";
    	
    	try {
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		
    		while(rs.next()) {
    			Bill bill = new Bill();
    			
    			int billId = rs.getInt("billId");
    			int userId = rs.getInt("userId");
    			int customerId = rs.getInt("customerId");
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
    	catch(SQLException e) {
    		e.printStackTrace();
    	}
    	
    	return bills;
    }
    
    public List<Bill> getBillsByEmployees(int employeeId) {
    	SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
		SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:aa");
	    List<Bill> bills = new ArrayList<>();
	    
	    String sql = "SELECT * FROM bill WHERE userId = ?";
	    
	    try {
	        PreparedStatement pstmt = connection.prepareStatement(sql);
	        pstmt.setInt(1, employeeId);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Bill bill = new Bill(
	                rs.getInt("billId"),
	                rs.getInt("userId"),
	                rs.getInt("customerId"),
	                dateFormatter.format(rs.getDate("date")),
					timeFormatter.format(rs.getTime("time")),
	                rs.getDouble("total")
	            );
	            bills.add(bill);
	        }
	    }
	    catch (SQLException e) {
	        e.printStackTrace();
	    }
    return bills;
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
	
	public List<Bill> getFilteredBills(String customerName, String dateFilter, String specificDate, String fromDate, String toDate, String discountApplied, int offset, int limit) {
	    List<Bill> bills = new ArrayList<>();
	    SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
	    SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:aa");
	    String query = "SELECT * FROM bill join customerdetails on bill.customerId = customerdetails.customerId";

	    boolean isWhereAppear = false;
	    if (customerName != null && !customerName.isEmpty()) { 
            query += " where customerName LIKE ?";
            isWhereAppear = true;
        }
        
        if (specificDate != null && !specificDate.isEmpty()) {
        	if(isWhereAppear){
        		query += " and DATE(date) = ?" ;
        	}else {
        		query += " where date(date) = ?";
        		isWhereAppear = true;
        	}
        }
        
        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
        	if(isWhereAppear){
        		query += " AND date(date) between ? and ?" ;
        	}else {
        		query += " where date(date) between ? and ?";
        		isWhereAppear = true;
        	}
        }
        
        if (dateFilter != null && !dateFilter.equals("all")) {
            switch (dateFilter) {
                case "today":
                	if(isWhereAppear){
    	        		query += " AND DATE(date) = CURDATE()" ;
    	        	}else {
    	        		query += " where DATE(date) = CURDATE()";
    	        		isWhereAppear = true;
    	        	}
                    break;
                case "month":
                	if(isWhereAppear){
    	        		query += " AND MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())" ;
    	        	}
                	else {
    	        		query += " where MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())";
    	        		isWhereAppear = true;
    	        	}
                    break;
                case "week":
                	if(isWhereAppear){
    	        		query += " AND WEEK(date) = WEEK(CURDATE())" ;
    	        	}
                	else {
    	        		query += " where WEEK(date) = WEEK(CURDATE())";
    	        		isWhereAppear = true;
    	        	}
                    break;
            }
        }

        if (discountApplied != null && !discountApplied.equals("all")) {
            if (discountApplied.equals("yes")) {
            	if(isWhereAppear){
	        		query += " AND discountAmount > 0" ;
	        	}
            	else {
	        		query += " where discountAmount > 0";
	        	}
            } else if (discountApplied.equals("no")) {
                query += (isWhereAppear) ? " AND discountAmount = 0" : " where discountAmount = 0";
            }
        }

	    query += " ORDER BY billId desc LIMIT ? OFFSET ?"; 

	    try (
	         PreparedStatement ps = connection.prepareStatement(query)) {

	        int paramIndex = 1;
	        
	        if (customerName != null && !customerName.isEmpty()) {
                ps.setString(paramIndex++, "%" + customerName.trim() + "%");
            }
            
            if (specificDate != null && !specificDate.isEmpty()) {
                ps.setString(paramIndex++, specificDate);
            }
            if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
	        	ps.setString(paramIndex++, fromDate);
	        	ps.setString(paramIndex++, toDate);
	        }

	        ps.setInt(paramIndex++, limit); 
	        ps.setInt(paramIndex++, offset); 

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Bill bill = new Bill();
	                bill.setBillId(rs.getInt("billId"));
	                bill.setCustomerName(rs.getString("customerName"));
	                bill.setDate(dateFormatter.format(rs.getDate("date")));
	                bill.setTime(timeFormatter.format(rs.getTime("time")));
	                bill.setSubTotal(rs.getDouble("subtotal"));
	                bill.setDiscountType(rs.getString("discountType"));
	                bill.setDiscountPercentage(rs.getDouble("discountPercentage"));
	                bill.setDiscountAmount(rs.getDouble("discountAmount"));
	                bill.setTaxPercentage(rs.getDouble("tax_percentage"));
	                bill.setTaxAmount(rs.getDouble("taxAmount"));
	                bill.setTotal(rs.getDouble("total"));
	                bills.add(bill);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return bills;
	}

	public int getTotalBills(String customerName, String dateFilter, String specificDate, String fromDate, String toDate, String discountApplied) {
	    int totalBills = 0;
	    String query = "SELECT COUNT(*) FROM bill JOIN customerdetails ON bill.customerId = customerdetails.customerId";
	
	    boolean isWhereAppear = false;
	    if (customerName != null && !customerName.isEmpty()) { 
	        query += " where customerName LIKE ?";
	        isWhereAppear = true;
	    }
	
	    if (specificDate != null && !specificDate.isEmpty()) {
	        if(isWhereAppear){
	            query += " and DATE(date) = ?";
	        } else {
	            query += " WHERE DATE(date) = ?";
	            isWhereAppear = true;
	        }
	    }
	
	    if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
	        if(isWhereAppear){
	            query += " and DATE(date) between ? AND ?";
	        } else {
	            query += " WHERE DATE(date) BETWEEN ? AND ?";
	            isWhereAppear = true;
	        }
	    }
	
	    if (dateFilter != null && !dateFilter.equals("all")) {
	        switch (dateFilter) {
	            case "today":
	                if(isWhereAppear){
	                    query += " AND DATE(date) = CURDATE()";
	                } else {
	                    query += " where date(date) = CURDATE()";
	                    isWhereAppear = true;
	                }
	                break;
	            case "month":
	                if(isWhereAppear){
	                    query += " and MONTH(date) = month(CURDATE()) AND year(date) = year(CURDATE())";
	                } else {
	                    query += " where MONTH(date) = MONTH(CURDATE()) AND year(date) = year(CURDATE())";
	                    isWhereAppear = true;
	                }
	                break;
	            case "week":
	                if(isWhereAppear){
	                    query += " and WEEK(date) = week(CURDATE())";
	                } else {
	                    query += " where WEEK(date) = week(CURDATE())";
	                    isWhereAppear = true;
	                }
	                break;
	        }
	    }
	
	    if (discountApplied != null && !discountApplied.equals("all")) {
	        if (discountApplied.equals("yes")) {
	            if(isWhereAppear){
	                query += " AND discountAmount > 0";
	            } else {
	                query += " WHERE discountAmount > 0";
	            }
	        } else if (discountApplied.equals("no")) {
	            if(isWhereAppear) {
	                query += " AND discountAmount = 0";
	            } else {
	                query += " WHERE discountAmount = 0";
	            }
	        }
	    }
	
	    try (PreparedStatement ps = connection.prepareStatement(query)) {
	        int paramIndex = 1;
	        if (customerName != null && !customerName.isEmpty()) {
	            ps.setString(paramIndex++, "%" + customerName.trim() + "%");
	        }
	        if (specificDate != null && !specificDate.isEmpty()) {
	            ps.setString(paramIndex++, specificDate);
	        }
	        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
	            ps.setString(paramIndex++, fromDate);
	            ps.setString(paramIndex++, toDate);
	        }
	
	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                totalBills = rs.getInt(1);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	
	    return totalBills;
	}

	public Map<String, Double> getDayWiseSales(int limit, int offset, String filter, int[] totalRecords) {
	    Map<String, Double> sales = new LinkedHashMap<>();
	    LocalDate startDate = null;
	    LocalDate endDate = null;

	    try {
	        String dateRangeQuery = "";
	        if ("week".equals(filter)) {
	            dateRangeQuery = "SELECT MIN(date) AS start_date, MAX(date) AS end_date FROM bill WHERE week(date) = week(curdate()) AND YEAR(date) = YEAR(CURDATE())";
	        } else if ("month".equals(filter)) {
	            dateRangeQuery = "SELECT IF(DAY(MIN(date)) = 1, MIN(date), DATE_FORMAT(CURDATE(), '%Y-%m-01')) AS start_date, MAX(date) AS end_date FROM bill WHERE MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())";
	        } else if ("year".equals(filter)) {
	            dateRangeQuery = "SELECT MIN(date) AS start_date, MAX(date) AS end_date FROM bill WHERE YEAR(date) = YEAR(CURDATE());";
	        } else {
	            dateRangeQuery = "SELECT MIN(date) AS start_date, MAX(date) AS end_date FROM bill";
	        }

	        try (PreparedStatement statement = connection.prepareStatement(dateRangeQuery)) {
	            try (ResultSet rs = statement.executeQuery()) {
	                if (rs.next()) {
	                    startDate = rs.getDate("start_date").toLocalDate();
	                    endDate = rs.getDate("end_date").toLocalDate();
	                }
	            }
	        }

	        if (startDate != null && endDate != null) {
	            LocalDate currentDate = startDate;
	            while (!currentDate.isAfter(endDate)) {
	                sales.put(currentDate.toString(), 0.0);
	                currentDate = currentDate.plusDays(1);
	            }
	            
	            totalRecords[0] = sales.size();

	            String salesQuery = "SELECT date, SUM(total) AS total_sales FROM bill WHERE date BETWEEN ? AND ? GROUP BY date";
	            try (PreparedStatement statement = connection.prepareStatement(salesQuery)) {
	                statement.setDate(1, java.sql.Date.valueOf(startDate));
	                statement.setDate(2, java.sql.Date.valueOf(endDate));
	                try (ResultSet rs = statement.executeQuery()) {
	                    while (rs.next()) {
	                        String date = rs.getString("date");
	                        double totalSales = rs.getDouble("total_sales");
	                        sales.put(date, totalSales);
	                    }
	                }
	            }
	            
	            

	            List<Map.Entry<String, Double>> sortedEntries = sales.entrySet()
	                    .stream()
	                    .sorted(Map.Entry.<String, Double>comparingByKey(Comparator.reverseOrder()))
	                    .collect(Collectors.toList());

	            int totalDates = sortedEntries.size();
	            int startIndex = Math.min(offset, totalDates);

	            sales = sortedEntries.stream()
	                .skip(startIndex)
	                .limit(limit)
	                .collect(LinkedHashMap::new, (m, v) -> m.put(v.getKey(), v.getValue()), LinkedHashMap::putAll);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return sales;
	}
	
	public boolean refundAmount(Bill bill) {
	    boolean isUpdated = false;
	    try {
	        String query = "UPDATE bill SET refund_Amount = ?, return_credited_Amount = ? WHERE billId = ?";
	        PreparedStatement ps = connection.prepareStatement(query);
	        ps.setDouble(1, bill.getRefundAmount());
	        ps.setDouble(2, bill.getReturnCreditAmount());
	        ps.setInt(3, bill.getBillId());
	        
	        int rowsAffected = ps.executeUpdate();
	        isUpdated = (rowsAffected > 0);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return isUpdated;
	}
	
	public boolean updateBill(Bill bill) {
        String query = "UPDATE bills SET return_credit_amount = ?, total = ?, subtotal = ?, exchange_amount = ? WHERE bill_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setDouble(1, bill.getReturnCreditAmount());
            pstmt.setDouble(2, bill.getTotal());
            pstmt.setDouble(3, bill.getSubTotal());
            pstmt.setDouble(4, bill.getExchangeAmount());
            pstmt.setInt(5, bill.getBillId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void insertExchangeProduct(int billId, int productId, double price, int quantity) {
        String query = "INSERT INTO bill_products (bill_id, product_id, price, quantity, is_exchange) VALUES (?, ?, ?, ?, true)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, billId);
            pstmt.setInt(2, productId);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, quantity);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }}