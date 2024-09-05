<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.User" %>
<%@ page import="model.Discount"%>
<%@ page import="model.Inventory" %>
<%@ page import="model.FormData" %>
<%@ page import="dao.DiscountDao"%>
<%@ page import="dao.CustomerDao"%>
<%@ page import="dao.CategoryDao" %>
<%@ page import="dao.InventoryDao"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing System</title>
    <% 
    	User user = (User)session.getAttribute("user");
    	String admin = "";
    	if (user != null && user.getUserRoleId() == 101) {
    		admin = "admin";
	}%>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin-left: 200px;
            margin-top: 30px;
            min-width:1000px;
            padding: 20px;
            background-color: whitesmoke;
        }
        h2{
        	margin-top: 0px;
        }
        #container {
            display: flex;
            justify-content: space-between;
            margin: 0 auto;
        }
        #leftPart, #rightPart {
            width: 48%;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            height: 100vh;
        }
        
        #rightPart{
        	min-height: 100vh;
        	height:fit-content;
        }
        
        #leftPart{
            overflow-y: scroll;        	
        }
        
        table { 	
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid lightgray;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: steelblue;
        }
        input[type = "text"], input[type = "number"] , input[type = "date"] {
            width: calc(100% - 10px);
            padding: 5px;
            margin: 5px 0;
        }
        button {
            padding: 10px 15px;
            background-color: steelblue;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        button:hover {
            background-color: purple;
        }
        #discountContainer {
            margin-top: 20px;
        }
        #totals {
            margin-top: 20px;
        }
        #alert {
            color: red;
            margin-top: 10px;
        }
        #billDetails{
        	margin-top: 5px;
        }
        
	    .employee-navbar {
	        display: flex;
	        justify-content: space-between;
	        background-color: #77c6f7;
	        padding: 5px;
	        margin: 0 auto;
	    }
	
	    .employee-navbar a {
	    	background-color: black;
	        color: white;
	        padding: 10px 20px;
	        text-decoration: none;
	        text-align: center;
	    }
	
	    .employee-navbar a:hover {
	        background-color: #3a3a3a;
	        color: white;
	    }
	
	    .employee-navbar .left {
	        float: left;
	    }
	
	    .employee-navbar .right {
	        float: right;
	    }
	    
	    .admin{
	    	margin-left: 200px;
	    	margin-top: 10px;
	    }
</style>


</head>
<body class="<%= admin %>">
    	<%
	    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	    response.setHeader("Pragma", "no-cache");
	    response.setDateHeader("Expires", 0);
	
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect("login.jsp");
	    } 
	    else {
	        if (((User) session.getAttribute("user")).getUserRoleId() == 101) {
	            %>
	            <%@ include file="header.jsp" %>
	        <% }
	        if (((User) session.getAttribute("user")).getUserRoleId() == 102) {
	        %>
				<%@ include file="employeeHeader.jsp" %>
	    <% }}
	    
	    
	    %>
    <div id="container">
        <div id="leftPart">
            <h2>Available Products</h2>
            <table id="productsTable" border="1">
                <thead>
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Price (₹)</th>
                        <th>Category</th>
                        <th>Units</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    InventoryDao productDAO = new InventoryDao();
                    CategoryDao categoryDAO = new CategoryDao();
                    List<Inventory> products = productDAO.getAllProducts();
                    for (Inventory product : products) {
                        String categoryName = categoryDAO.getCategoryName(product.getCategoryId());
                        String rowColor = product.getUnits() <= 5 ? "style='background-color: #ffb4ac;'" : ((5 < product.getUnits() && product.getUnits() <= 10) ? "style='background-color: #ffff62;'" : "");
                    %>
                    <tr <%= rowColor %> data-product-id="<%= product.getProductId() %>" data-product-price="<%= product.getPrice() %>" data-product-units="<%= product.getUnits() %>">
                        <td><%= product.getProductId() %></td>
                        <td><%= product.getProductName() %></td>
                        <td>₹<%= product.getPrice() %></td>
                        <td><%= categoryName %></td>
                        <td><%= product.getUnits() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <div id="rightPart">
            <h2>Bill</h2>
            <form id="billForm" action="BillingServlet" method="post">
                <input type="date" id="date" name="date" required>
                <input type="text" id="customerPhoneNo" name="customerPhoneNo" placeholder="Customer Phone Number" required>
                <div id="billDetailsContainer">
                    <table id="billDetails" border="1">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Price (₹)</th>
                                <th>Quantity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <button type="button" id="addRow">+ Add Row</button>
                <div id="discountContainer"></div>
                <div id="totals">
                    <p>Subtotal: <span id="subtotal">₹0.00</span></p>
                    <p id="discountAmountRow" style="display:none;">Discount: <span id="discountAmount">₹0.00</span></p>
                    <p>GST (3%): <span id="gstAmount">₹0.00</span></p>
                    <p>Total: <span id="total">₹0.00</span></p>
                </div>
                <input type="hidden" id="selectedDiscountId" name="selectedDiscountId" value="">
                <input type="hidden" id="discountedAmount" name="discountAmount" value="">
                <input type="hidden" id="gstAmountHidden" name="gstAmount" value="">
                <input type="hidden" id="totalHidden" name="total" value="">
                <button type="submit">Generate Bill</button>
                <button type="button" id="resetButton">Reset</button>
                <p id="alert"></p>
            </form>
        </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function () {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('date').value = today;

        let customerTotalSpending = 0;
        let subtotal = 0;
        let selectedDiscountPercentage = 0;
        let selectedDiscountId = null;
        const gstRate = 0.03;
        const productsTable = document.getElementById("productsTable");
        const billDetailsTable = document.getElementById("billDetails").getElementsByTagName("tbody")[0];
    	<% 
	    if(request.getParameter("outcome") != null && request.getParameter("outcome") == "Invalid Input"){%>
	    	alert("Invalid Input");
	    <%}
        FormData formdata = (FormData) session.getAttribute("formData");
        if (formdata != null) {
            String date = formdata.getDate();
            String customerPhoneNo = formdata.getCustomerPhoneNo();
            String[] productIds = formdata.getProductIds();
            String[] quantities = formdata.getQuantities();
    %>
        document.getElementById("customerPhoneNo").value = "<%= customerPhoneNo %>";
        document.querySelector("form #customerPhoneNo").value = "<%= customerPhoneNo %>";

        <% 
            for (int i = 0; i < productIds.length; i++) {
            	System.out.println(productIds[i]);
        %>
            (function() {
                var productId = "<%= productIds[i] %>";
                var quantity = "<%= quantities[i] %>";
                console.log(quantity);
                fetch("ProductPriceServlet?productId=" + productId)
                    .then(response => response.json())
                    .then(data => {
                   	 addOrUpdateProductRow(productId, data.price, quantity);
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
                
                calculateTotal();
            })();
        <% 
            }
        }
        %>

        function addOrUpdateProductRow(productId, price, quantity = 1) {
            const availableUnits = getProductUnits(productId);
            
            if (quantity > availableUnits) {
                alert("Insufficient units available");
                return;
            }

            const existingRow = Array.from(billDetailsTable.getElementsByTagName("tr"))
                .find(row => row.querySelector(".productId") && row.querySelector(".productId").value == productId);

            if (existingRow) {
                const quantityInput = existingRow.querySelector(".quantity");
                const newQuantity = parseInt(quantityInput.value) + quantity;

                if (newQuantity > availableUnits) {
                    alert("Insufficient units available");
                    return;
                }

                quantityInput.value = newQuantity;
            } else {
                const row = billDetailsTable.insertRow();
                row.innerHTML = `
                    <td><input type="number" class="productId" name="productId" readonly></td>
                    <td class="price">₹0.00</td>
                    <td><input type="number" name="quantity" class="quantity" value="1" min="1" required></td>
                    <td><button type="button" class="removeRow">Remove</button></td>
                `;
                row.querySelector(".productId").value = productId;
                row.querySelector(".price").innerText = "₹" + price.toFixed(2);

                const productIdInput = row.querySelector(".productId");
                productIdInput.addEventListener("change", function () {
                    fetchProductPrice(this.value, row);
                });

                row.querySelector(".quantity").addEventListener("input", function () {
                    const currentQuantity = parseInt(this.value);
                    if (currentQuantity > getProductUnits(productId)) {
                        alert("Insufficient units available");
                        this.value = getProductUnits(productId);
                    }
                    calculateTotal();
                });

                row.querySelector(".removeRow").addEventListener("click", function () {
                    billDetailsTable.removeChild(row);
                    calculateTotal();
                });
            }
            calculateTotal();
        }

        productsTable.addEventListener("click", function (event) {
            const target = event.target.closest("tr");
            if (target && target.dataset.productId) {
            	if(target.dataset.productUnits === "0"){
	        		alert("Insufficient Units");
	        	}
	        	else{
	                const productId = target.dataset.productId;
	                const price = parseFloat(target.dataset.productPrice);	
	                addOrUpdateProductRow(productId, price,1);
	        	}
            }
        });
        
        function getProductUnits(productId) {
        	console.log(productId);
            const productRow = Array.from(productsTable.getElementsByTagName("tr"))
                .find(row => row.dataset.productId == productId);
            return productRow ? parseInt(productRow.dataset.productUnits) : 0;
        }
        
        document.getElementById("addRow").addEventListener("click", function () {
            const row = billDetailsTable.insertRow();
            row.innerHTML = `
                <td><input type="number" class="productId" name="productId" required></td>
                <td class="price">₹0.00</td>
                <td><input type="number" name="quantity" class="quantity" value="1" min="1" required></td>
                <td><button type="button" class="removeRow">Remove</button></td>
            `;
            const productIdInput = row.querySelector(".productId");
            productIdInput.addEventListener("change", function () {
                fetchProductPrice(this.value, row,row.querySelector(".quantity").value);
            });
            row.querySelector(".quantity").addEventListener("input", calculateTotal);
            row.querySelector(".removeRow").addEventListener("click", function () {
                billDetailsTable.removeChild(row);
                calculateTotal();
            });
        });


        function fetchProductPrice(productId, row, quantity) {
            fetch("ProductPriceServlet?productId=" + productId)
                .then(response => response.json())
                .then(data => {
                    row.cells[1].innerText = "₹" + data.price.toFixed(2);
                    calculateTotal();
                    if(quantity > getProductUnits(productId)){
                    	alert("Insufficient Stocks.");
                    	return;	
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    row.cells[1].innerText = "₹0.00";
                });
        }

        function calculateTotal() {
            subtotal = 0;
            const rows = billDetailsTable.getElementsByTagName("tr");
            for (let i = 0; i < rows.length; i++) {
                const price = parseFloat(rows[i].querySelector(".price").innerText.replace('₹', ''));
                const quantity = parseInt(rows[i].querySelector(".quantity").value);
                if (!isNaN(price) && !isNaN(quantity)) {
                    subtotal += price * quantity;
                }
            }
            updateTotalDisplay();
            checkDiscountEligibility(subtotal);
        }

        function updateTotalDisplay() {
            const discountAmount = (subtotal * selectedDiscountPercentage) / 100;
            const totalAfterDiscount = subtotal - discountAmount;
            const gstAmount = totalAfterDiscount * gstRate;
            const total = totalAfterDiscount + gstAmount;

            document.getElementById("subtotal").innerText = "₹" + subtotal.toFixed(2);
            document.getElementById("discountAmount").innerText = "₹" + discountAmount.toFixed(2);
            document.getElementById("gstAmount").innerText = "₹" + gstAmount.toFixed(2);
            document.getElementById("total").innerText = "₹" + total.toFixed(2);

            document.getElementById("selectedDiscountId").value = selectedDiscountId;
            document.getElementById("discountedAmount").value = discountAmount.toFixed(2);
            document.getElementById("gstAmountHidden").value = gstAmount.toFixed(2);
            document.getElementById("totalHidden").value = total.toFixed(2);

            document.getElementById("discountAmountRow").style.display = discountAmount > 0 ? "block" : "none";
        }
        
        function checkDiscountEligibility(billTotal = 0) {
            fetch("AvailableDiscountServlet")
                .then(response => response.json())
                .then(discounts => {
                    const discountContainer = document.getElementById("discountContainer");
                    discountContainer.innerHTML = "";

                    discounts.forEach(discount => {
                        if ((discount.discountType === "Monthly Discount" && customerTotalSpending > discount.conditionAmount) ||
                            (discount.discountType === "Single Bill Discount" && billTotal > discount.conditionAmount)) {
                            addDiscountOption(discount);
                        }
                 });
              })
                .catch(error => {
                    console.error('Error:', error);
                });
        }

        function addDiscountOption(discount) {
            const discountContainer = document.getElementById("discountContainer");
            const radioButton = document.createElement("input");
            radioButton.type = "radio";
            radioButton.name = "discount";
            radioButton.value = discount.discountPercentage;
            radioButton.id = "discount_" + discount.discountId;

            radioButton.addEventListener("change", function () {
                if (this.checked) {
                    selectedDiscountPercentage = parseFloat(this.value);
                    selectedDiscountId = discount.discountId;
                } 
             else {
                    selectedDiscountPercentage = 0;
                    selectedDiscountId = null;
                }
                updateTotalDisplay();
            });

            const label = document.createElement("label");
            label.htmlFor = radioButton.id;
            label.innerText = "Apply " + discount.discountType + " (" + discount.discountPercentage + "%)";

            discountContainer.appendChild(radioButton);
            discountContainer.appendChild(label);
            discountContainer.appendChild(document.createElement("br"));
        }

        function resetDiscountSelection() {
            selectedDiscountPercentage = 0;
            selectedDiscountId = null;
            document.getElementById("discountContainer").innerHTML = "";
            updateTotalDisplay();
        }
        
        function fetchCustomerTotalSpending(mobileNumber) {
            fetch("CustomerTotalSpendingServlet?mobileNumber=" + mobileNumber)
                .then(response => response.json())
                .then(data => {
                    customerTotalSpending = data.totalSpending;
                    checkDiscountEligibility(subtotal);
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById("alert").innerText = "Error fetching customer data";
                });
        }

        document.getElementById("billForm").addEventListener("submit", function (event) {
            if (billDetailsTable.rows.length === 0) {
                alert("Please add at least one product to the bill.");
                event.preventDefault();
            }
            const customerPhoneNo = document.getElementById("customerPhoneNo").value.trim();
			 if (customerPhoneNo.length !== 10) {
                event.preventDefault();
                alert("Enter 10-digit valid phone Number...");
            }
            
        });

        document.getElementById("resetButton").addEventListener("click", function () {
            document.getElementById("billForm").reset();
            document.getElementById("date").value = today;
            billDetailsTable.innerHTML = "";
            resetDiscountSelection();
            calculateTotal();
            document.getElementById("alert").innerText = "";
        });

        document.getElementById("customerPhoneNo").addEventListener("blur", function () {
            const customerPhoneNo = this.value.trim();
            if (customerPhoneNo !== "") {
                fetchCustomerTotalSpending(customerPhoneNo);
            } else {
                resetDiscountSelection();
            }
        });
    });
    </script>
</body>
</html>