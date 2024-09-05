package dao;

import model.Discount;

import java.sql.*;

import java.util.List;
import java.util.ArrayList;

public class DiscountDao {
	private Connection connection;
	public DiscountDao() {
		connection = Database.getConnection();
	}
	
	public int addDiscount(Discount discount) {
		try {
			String sql = "INSERT INTO discount(discountType,conditionAmount,discountPercentage,status) values(?,?,?,?)";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, discount.getDiscountType());
			pstmt.setDouble(2, discount.getConditionAmount());
			pstmt.setDouble(3, discount.getDiscountPercentage());
			pstmt.setString(4, "Active");
			pstmt.executeUpdate();
		}
		catch(SQLException e) {
			e.printStackTrace();
			return -1;
		}
		return 1;
	}
	
	public Discount getDiscount(int discountId) {
		try {
			String sql = "SELECT * from discount WHERE discountId = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, discountId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return new Discount(
						rs.getInt("discountId"),
						rs.getString("discountType"),
						rs.getDouble("conditionAmount"),
						rs.getDouble("discountPercentage")
						);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	public List<Discount> allDiscount(){
		List<Discount> discounts = new ArrayList<>();
		try {
			String sql = "SELECT * FROM discount order by status ASC, discountID ASC";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				discounts.add(new Discount(
						rs.getInt("discountId"),
						rs.getString("discountType"),
						rs.getDouble("conditionAmount"),
						rs.getDouble("discountPercentage"),
						rs.getString("status")
						));
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return null;
		}
		return discounts;
	}
	
	public List<Discount> AvailableDiscount(){
		List<Discount> discounts = new ArrayList<>();
		try {
			String sql = "SELECT * from discount WHERE status = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, "Active");
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				discounts.add(new Discount(
						rs.getInt("discountId"),
						rs.getString("discountType"),
						rs.getDouble("conditionAmount"),
						rs.getDouble("discountPercentage"),
						rs.getString("status")
						));
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return null;
		}
		return discounts;
	}
	
	public boolean isDiscountAlreadyApplied(int discountId,int  customerId) {
		try {
			String sql = "select * from bill as b inner join applied_discounts as ad on b.billId = ad.billId where customerId = ? and discountId = ? and YEAR(date) = YEAR(CURRENT_DATE) AND MONTH(date) = MONTH(CURRENT_DATE)";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, discountId);
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return true;
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public int discountChangeStatus(int discountId,String newStatus) {
		try {
			String sql = "UPDATE discount set status = ? WHERE discountId = ?";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setString(1, newStatus);
			pstmt.setInt(2,discountId);
			pstmt.executeUpdate();
		}
		catch(SQLException e) {
			e.printStackTrace();
			return -1;
		}
		return 1;
	}
	
}
