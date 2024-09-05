package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import model.CategorySales;
import model.Inventory;
import model.Category;

public class CategoryDao {
	private Connection connection;
	
	public CategoryDao() {
		connection = Database.getConnection();
	}
	
	public String getCategoryName(int categoryId) {
		try {
			String sql = "SELECT category FROM product_category WHERE categoryId = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1,categoryId);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString("category");
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<Category> getAllCategory(){
		List<Category> categories = new ArrayList<>();
		try {
			String sql = "Select * from product_category";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				categories.add(new Category(rs.getInt("categoryId"),rs.getString("category")));
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return null;
		}
		return categories;
	}
	
	public List<Inventory> getCategoryBills(int categoryId,String filterType, String sDate, String eDate){
		List<Inventory> products = new ArrayList<>();
		try {
			String sql ="select bill_product.billId as billId, inventory.productName as productName, bill_product.price as price, bill_product.quantity as quantity from bill_product inner join inventory on inventory.productId = bill_product.productId inner join bill on bill.billId = bill_product.billId where inventory.category = ? " + getFilterCondition(filterType, sDate, eDate);
			sql += "order by bill.billId desc";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, categoryId);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Inventory inventory = new Inventory();
				
				inventory.setProductId(rs.getInt("billId"));
				inventory.setProductName(rs.getString("productName"));
				inventory.setPrice(rs.getDouble("price"));
				inventory.setUnits(rs.getInt("quantity"));
				products.add(inventory);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return products;
	}
	
	private String getFilterCondition(String filterType, String sDate, String eDate) {
	    switch (filterType) {
	        case "today":
	            return "and DATE(bill.date) = CURDATE()";
	        case "month":
	            return "and MONTH(bill.date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE())";
	        case "week":
	        	return " and week(bill.date) = week(current_date) and year(date) = year(date)";
	        case "date":
	            return "and DATE(bill.date) = '" + sDate + "'";
	        case "dateRange":
	            return "and DATE(bill.date) BETWEEN '" + sDate + "' AND '" + eDate + "'";
	        default:
	            return " "; 
	    }
	}
	
	public List<CategorySales> getFilteredCategorySales(String specificDate, String fromDate, String toDate, String dateFilter, int limit, int offset) {
        List<CategorySales> customerSalesList = new ArrayList<>();
        String query = "SELECT inventory.category AS categoryID, COUNT(*) AS totalBills, SUM(bill_product.price * bill_product.quantity) AS totalAmount FROM bill_product JOIN inventory ON bill_product.productId = inventory.productId JOIN bill ON bill_product.billId = bill.billId";

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

        query += " GROUP BY inventory.category ORDER BY inventory.category ASC Limit ? Offset ?";

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
                    CategorySales sales = new CategorySales();
                    sales.setCategoryID(rs.getInt("categoryID"));
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
	
	public int getTotalCategorySales(String specificDate, String fromDate, String toDate, String dateFilter) {
		int total = 0;
		String query = "SELECT count(*) from (SELECT COUNT(*) FROM bill_product JOIN inventory ON bill_product.productId = inventory.productId JOIN bill ON bill_product.billId = bill.billId";

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

        query += " GROUP BY inventory.category ) as totalSales";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;

            if (specificDate != null && !specificDate.isEmpty()) {
                ps.setString(paramIndex++, specificDate);
            } else if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
                ps.setString(paramIndex++, fromDate);
                ps.setString(paramIndex++, toDate);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

}