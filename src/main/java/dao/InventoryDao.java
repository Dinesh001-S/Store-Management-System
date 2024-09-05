package dao;

import model.Inventory;
import model.Category;

import java.util.ArrayList;
import java.util.List;

import java.sql.*;

public class InventoryDao {

	private Connection connection;
    
    public InventoryDao() {
        connection = Database.getConnection();
    }

    public int addProduct(Inventory inventory) {
        String sql = "INSERT INTO inventory (productName, price, units, category) VALUES (?, ?, ?, ?)";
        try (
        	PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        	)
        {
            stmt.setString(1, inventory.getProductName());
            stmt.setDouble(2, inventory.getPrice());
            stmt.setInt(3, inventory.getUnits());
            stmt.setInt(4, inventory.getCategoryId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating product failed");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    inventory.setProductId(generatedId);
                    return generatedId;
                } else {
                    throw new SQLException("Creating product failed");
                }
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public Inventory getProduct(int productId) {
        String sql = "SELECT * FROM inventory WHERE productId = ?";
        try (
        		PreparedStatement stmt = connection.prepareStatement(sql)
        	)
        {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Inventory(
                    rs.getInt("productId"),
                    rs.getString("productName"),
                    rs.getDouble("price"),
                    rs.getInt("units"),
                    rs.getInt("category")
                );
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Inventory> getAllProducts() {
    	List<Inventory> products = new ArrayList<>(); 
        String sql = "SELECT * FROM inventory";
        try (
        		Statement stmt = connection.createStatement();
        		ResultSet rs = stmt.executeQuery(sql)
        	)
        {
            while (rs.next()) {
                    products.add(new Inventory(
                         rs.getInt("productId"),
                         rs.getString("productName"),
                         rs.getDouble("price"),
                         rs.getInt("units"),
                         rs.getInt("category")
                    ));
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return products;
    }  
    
    public int updateProductUnits(int productId, int units) {
        try {	
        	String sql = "UPDATE inventory SET units = units - ? WHERE productId = ?";
        	PreparedStatement pstmt = connection.prepareStatement(sql);
            pstmt.setDouble(1, units);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
        }
        catch(SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return 1;
    }
    
    public List<String> allCategory(){
    	List<String> categories = new ArrayList<>();
    	try {
    		String sql = "SELECT category FROM product_category";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		while(rs.next()) {
    			categories.add(rs.getString("category"));
    		}
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return null;
    	}
    	return categories;
    }
    
    public int addNewCategory(int categoryId, String category) {
    	List<String> categories = allCategory();
    	for(String categoryName : categories) {
    		if(categoryName.equals(category)) {
    			return 2;
    		}
    	}
    	try {
    		String sql = "Insert into product_category(categoryId,category) values(?,?)";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		pstmt.setInt(1,categoryId);
    		pstmt.setString(2, category);
    		pstmt.executeUpdate();
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return -1;
    	}
    	return 1;
    }
    
    public List<Category> getProductCategories() {
        List<Category> categories = new ArrayList<>();

        try {
        	String sql = "SELECT categoryId, category FROM product_category";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("categoryId");
                String categoryName = rs.getString("category");
                categories.add(new Category(id, categoryName));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    public int updateProductCategory(int productId, String category) {
    	if(getProduct(productId) == null){
    		return 2;
    	}
    	try {
    		String sql = "UPDATE inventory SET category = ? WHERE productId = ?";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		
    		pstmt.setString(1, category);
    		pstmt.setInt(2, productId);
    		
    		pstmt.executeUpdate();
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return -1;
    	}
    	return 1;
    }
    
    public double getProductPrice(int productId) {
    	double price = 0.0;
    	try {
	    	String sql = "SELECT price FROM inventory where productId = ?";
	    	PreparedStatement pstmt = connection.prepareStatement(sql);
	    	pstmt.setInt(1, productId);
	    	ResultSet rs = pstmt.executeQuery();
	    	if(rs.next()) {
	    		price = rs.getDouble("price");
	    	}
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    	}
    	return price;
    }
    
    public List<Inventory> getLowUnitsProducts(){
    	List<Inventory> lowUnits = new ArrayList<>();
    	
    	try {
    		String sql = "select * from Inventory where units < 6 order by units asc";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		ResultSet rs = pstmt.executeQuery();
    		
    		while(rs.next()) {
    			lowUnits.add(
    					new Inventory(rs.getInt("productId"),rs.getString("productName"),rs.getDouble("price"),rs.getInt("units"),rs.getInt("category"))
    					);
    		}
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return null;
    	}
    	return lowUnits;
    }
    
    public int editProduct(Inventory inventory) {
    	Inventory inventoryCheck = getProduct(inventory.getProductId());
    	
    	if((inventory.getPrice() == inventoryCheck.getPrice())&&(inventory.getUnits() == inventoryCheck.getUnits()) && (inventory.getCategoryId() == inventoryCheck.getCategoryId())) {
    		return 0;
    	}
    	
    	try {
    		String sql = "UPDATE inventory SET productName = ? ,category = ?, price = ? ,units = ? WHERE productId = ?";
    		PreparedStatement pstmt = connection.prepareStatement(sql);
    		
    		pstmt.setString(1, inventory.getProductName());
    		pstmt.setInt(2, inventory.getCategoryId());
    		pstmt.setDouble(3, inventory.getPrice());
    		pstmt.setInt(4, inventory.getUnits());
    		pstmt.setInt(5, inventory.getProductId());
    		
    		pstmt.executeUpdate();
    	}
    	catch(SQLException e) {
    		e.printStackTrace();
    		return -1;
    	}
    	return 1;
    }

    public void deleteProduct(int productId) {
        try {
        	String sql = "DELETE FROM inventory WHERE productId = ?";
        	PreparedStatement pstmt = connection.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.executeUpdate();
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
    }
}