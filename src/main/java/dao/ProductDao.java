package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import model.Bill;
import model.Product;


public class ProductDao {
	private Connection connection;
	public ProductDao() {
		connection = Database.getConnection();
	}
	public int productReturn(int billId, int productId, String returnDate, int quantity, String returnReason, double amount) {
		try {
			connection.setAutoCommit(false);
			
			String sql = "UPDATE bill_product SET isReturn = true, returnDate = ?, returnReason = ? WHERE billId = ? AND productId = ?";
			try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
				pstmt.setDate(1, Date.valueOf(returnDate));
				pstmt.setString(2, returnReason);
				pstmt.setInt(3, billId);
				pstmt.setInt(4, productId);
				pstmt.executeUpdate();
			}
			
			String billSql = "UPDATE bill SET return_Credited_Amount = return_Credited_Amount + ?, total = total - ?, subtotal = subtotal - ? WHERE billId = ?";
			try (PreparedStatement stmt = connection.prepareStatement(billSql)) {
				BillDao billDao = new BillDao();
				Bill bill = billDao.getBill(billId);
				stmt.setDouble(1, amount);
				stmt.setDouble(2, amount);
				stmt.setDouble(3, amount);
				stmt.setInt(4, billId);
				stmt.executeUpdate();
			}
			
			InventoryDao inventoryDao = new InventoryDao();
			int units = inventoryDao.getProduct(productId).getUnits();
			String inventorySql = "UPDATE inventory SET units = ? WHERE productId = ?";
			try (PreparedStatement ps = connection.prepareStatement(inventorySql)) {
				ps.setInt(1, units + quantity);
				ps.setInt(2, productId);
				ps.executeUpdate();
			}
			connection.commit();
			return 1;
		} catch (SQLException e) {
			e.printStackTrace();
			
			try {
				if (connection != null) {
					connection.rollback();
				}
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
			return -1;
		} finally {
			try {
				if (connection != null) {
					connection.setAutoCommit(true);
				}
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	public boolean isAlreadyExchanged(int billId,int productId) {		
		try {
			String sql = "SELECT * FROM bill_product WHERE billId = ? and productId = ? and isExchange = true";
			PreparedStatement pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, billId);
			pstmt.setInt(2, productId);
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
	
	public int productExchange(int billId, List<Product> exchangeProducts, double amounttotalExchangeAmount) {
		try {
			connection.setAutoCommit(false);	
			for(Product product : exchangeProducts) {
				
				if(isAlreadyExchanged(billId,product.getProductId())) {
					String sql = "update bill_product set price = price + ? , quantity = quantity + ? where billId = ? and productId= ? and isExchange = true";
					try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
						pstmt.setDouble(1, product.getPrice());
						pstmt.setInt(2, product.getQuantity());
						pstmt.setInt(3, billId);
			            pstmt.setInt(4, product.getProductId());
			            pstmt.executeUpdate();
					}
				}
				else {
					String sql = "INSERT INTO bill_product (billId, productId, price, quantity, isExchange) VALUES (?, ?, ?, ?, true)";
					try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
						pstmt.setInt(1, billId);
			            pstmt.setInt(2, product.getProductId());
			            pstmt.setDouble(3, product.getPrice());
			            pstmt.setInt(4, product.getQuantity());
			            pstmt.executeUpdate();
					}
				}
				
				InventoryDao inventoryDao = new InventoryDao();
				int units = inventoryDao.getProduct(product.getProductId()).getUnits();
				String inventorySql = "UPDATE inventory SET units = ? WHERE productId = ?";
				try (PreparedStatement ps = connection.prepareStatement(inventorySql)) {
					ps.setInt(1, units - product.getQuantity());
					ps.setInt(2, product.getProductId());
					ps.executeUpdate();
				}
			}
			String billSql = "UPDATE bill SET return_Credited_Amount = ?, total = total +  ?, subtotal = subtotal + ?, exchange_Amount = exchange_Amount + ? WHERE billId = ?";
			try (PreparedStatement stmt = connection.prepareStatement(billSql)) {
				BillDao billDao = new BillDao();
				Bill bill = billDao.getBill(billId);
				double returnCreditAmount = (bill.getReturnCreditAmount() <= amounttotalExchangeAmount) ? 0.00 : bill.getReturnCreditAmount() - amounttotalExchangeAmount ;
				stmt.setDouble(1, returnCreditAmount);
				stmt.setDouble(2, amounttotalExchangeAmount);
				stmt.setDouble(3, amounttotalExchangeAmount);
				stmt.setDouble(4, amounttotalExchangeAmount);
				stmt.setInt(5, billId);
				stmt.executeUpdate();
			}
			
			connection.commit();
			return 1;
		} catch (SQLException e) {
			e.printStackTrace();
			
			try {
				if (connection != null) {
					connection.rollback();
				}
			} catch (SQLException exp) {
				exp.printStackTrace();
			}
			return -1;
		} finally {
			try {
				if (connection != null) {
					connection.setAutoCommit(true);
				}
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	
	

}
