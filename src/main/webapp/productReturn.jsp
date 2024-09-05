<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Bill" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="dao.InventoryDao" %>
<%@ page import ="dao.CustomerDao"%>
<%@ page import="dao.BillDao" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product Return Section</title>
<style>
    .body {
        font-family: Arial, sans-serif;
        min-width:1000px;
        margin-left: 200px;
        margin-top: 30px;
    }

    h1 {
        text-align: center;
        color: #333;
    }

    .centered-form {
        display: flex;
        justify-content: center;
        margin: 20px 0;
    }

    .centered-form input[type="text"] {
        padding: 10px;
        width: 300px;
        margin-right: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    .centered-form input[type="submit"] {
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        background-color: steelblue;
        color: white;
        cursor: pointer;
    }

    .centered-form input[type="submit"]:hover {
        background-color: purple;
    }

    .bill-details {
	    width: 60%;
	    margin: 20px auto;
	    background-color: #f9f9f9;
	    padding: 20px;
	    border-radius: 5px;
	    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
	    display: flex;
	    gap: 20px; 
	}
	
	.bill-details .left-column,
	.bill-details .right-column {
		margin:auto;
	    display: grid;
	    gap: 10px; 
	}
	
	.bill-details .detail-row {
	    display: flex;
	    justify-content: left;
	}
	
	.bill-details .detail-row label, .return-credit label {
	    font-weight: bold;
	    color: #555;
	}
	
	.bill-details .return-credit {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    width: 100%;
	}
	
	.return-credit span {
	    font-size: 1.1em;
	    color: #333;
	}
	
	.return-credit-buttons {
	    display: flex;
	    gap: 10px;
	}
	
	.return-credit-buttons button {
	    background-color: #4CAF50;
	    color: white;
	    border: none;
	    padding: 10px 20px;
	    border-radius: 5px;
	    cursor: pointer;
	}
	
	.return-credit-buttons button:hover {
	    background-color: #45a049;
	}

    table {
        width: 60%;
        margin: 20px auto;
        border-collapse: collapse;
        margin-bottom: 50px;
    }

    table, th, td {
        border: 1px solid #ddd;
    }

    th, td {
        padding: 12px;
        text-align: center;
    }

    th {
        background-color: steelblue;
        color: white;
    }
    
    .action-buttons{
    	display: flex;
    	justify-content: end;
    	gap: 10px;
    }

    .action-button {
        background-color: #f44336;
        color: white;
        border: none;
        padding: 10px 20px;
        text-align: center;
        text-decoration: none;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
    }

    .action-button:hover {
        background-color: #e53935;
    }

    .modal {
        display: none; 
        position: fixed; 
        z-index: 1; 
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0, 0, 0, 0.4); 
    }

    .modal-content {
        background-color: #fff;
        margin: 10% auto; 
        padding: 20px;
        border: 1px solid #888;
        width: 40%; 
        border-radius: 10px;
        position: relative;
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-header .close {
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }

    .modal-header .close:hover,
    .modal-header .close:focus {
        color: black;
        text-decoration: none;
        cursor: pointer;
    }

    .modal-body p {
        margin: 10px 0;
    }

    .modal-body textarea {
        width: 95%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        margin-bottom: 20px;
    }
    	
    button {
        background-color: #f44336;
        border: none;
        border-radius: 3px;
        padding:5px;
        color: white;
        font-size:16px;
    }
    .success-message {
	    color: green;
	    font-weight: bold;
	    text-align: center;
	    margin-bottom: 20px;
	}
	
	.error-message {
	    color: red;
	    font-weight: bold;
	    text-align: center;
	    margin-bottom: 20px;
	}
</style>
</head>
<body class="body">
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
    <h1>Product Return</h1>

    <div class="centered-form">
        <form action="ProductReturningServlet" method="get">
            <label for="billId">Enter Bill ID:</label>
            <input type="text" id="billId" name="billId" required>
            <input type="submit" value="Search">
        </form>
    </div>

    <% 
        Bill bill = (Bill) request.getAttribute("bill");
        
        if (bill != null) {
        	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        	BillDao billDao = new BillDao();
        	InventoryDao inventoryDao = new InventoryDao();
        	CustomerDao customerDao = new CustomerDao();
	        Map<Integer, Product> products = bill.getInventorys();
            if (products != null && !products.isEmpty()) {
    %>
    
    <div class="bill-details">
	    <div class="left-column">
	        <div class="detail-row">
	            <label>Bill ID:</label>
	            <span><%= bill.getBillId() %></span>
	        </div>
	        <div class="detail-row">
	            <label>Customer ID:</label>
	            <span><%= bill.getCustomerId() %></span>
	        </div>
	        <div class="detail-row">
	            <label>Customer Name:</label>
	            <span><%= customerDao.getCustomer(bill.getCustomerId()).getCustomerName() %></span>
	        </div>
	        <div class="detail-row">
	            <label>Customer Phone:</label>
	            <span><%= customerDao.getCustomer(bill.getCustomerId()).getPhoneNo() %></span>
	        </div>
	    </div>
	
	    <div class="right-column">
	        <div class="detail-row">
	            <label>Subtotal:</label>
	            <span><%= currencyFormatter.format(bill.getSubTotal()) %></span>
	        </div>
	        <div class="detail-row">
	            <label>Discount Amount:</label>
	            <span><%= currencyFormatter.format(bill.getDiscountAmount()) %></span>
	        </div>
	        <div class="detail-row">
	            <label>Tax Amount:</label>
	            <span><%= currencyFormatter.format(bill.getTaxAmount()) %></span>
	        </div>
	        <div class="detail-row">
	            <label>Total:</label>
	            <span><%= currencyFormatter.format(bill.getTotal()) %></span>
	        </div>
	    </div>
	</div>

    <div class="bill-details" style="margin-top: 20px;">
	    <div class="return-credit">
	    	<div>
		        <label>Return Credit:</label>
		        <span><%= currencyFormatter.format(billDao.getBill(bill.getBillId()).getReturnCreditAmount()) %></span>
	    	</div>
	        <div class="action-buttons" style="float: right;">
			    <form action="RefundServlet" method="post">
			        <input type="hidden" name="billId" value="<%= bill.getBillId() %>" id="hiddenBillId">
			        <button class="action-button" type="submit">Refund</button>
			    </form>
			    <button class="action-button" type="button" id="ExchangeButton">Exchange</button>
			</div>
	    </div>
	</div>
	
	<%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <div class="<%= message.equals("Successfully Refunded") ? "success-message" : "error-message" %>">
            <%= message %>
        </div>
    <%
        }
    %>
    
    <table>
        <tr><th>Product Name</th><th>Price</th><th>Quantity</th><th>Action</th></tr>
        <% 
            for (Product product : products.values()) { 
        %>
        <tr>
            <td><%= inventoryDao.getProduct(product.getProductId()).getProductName() %></td>
            <td><%= currencyFormatter.format(product.getPrice()) %></td>
            <td><%= product.getQuantity() %></td>
            <td><button class="action-button" onclick="openModal('<%= bill.getBillId() %>', '<%= product.getProductId() %>', '<%= inventoryDao.getProduct(product.getProductId()).getProductName() %>',' <%= product.getPrice() %>',' <%= product.getQuantity() %>')">Return</button></td>
        </tr>
        <% 
            } 
        %>
    </table>
    
    <div id="returnModal" class="modal">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h2>Return Product</h2>
	            <span class="close" onclick="closeModal()">&times;</span>
	        </div>
	        <div class="modal-body">
	            <form id="returnForm" action="ProductReturnServlet"  method="post">
	                <input type="hidden" name="billId" value="<%= bill.getBillId()%>" id="hiddenBillId">
	                <input type="hidden" name="productId" id="hiddenProductId">
	                <input type="hidden" name="date" id="hiddenDate">
	                <input type="hidden" name="amount" id="hiddenAmount">
	                <input type="hidden" name="quantity" id="hiddenQuantity">
	                
	                <p>Bill ID: <span id="modalBillId"></span></p>
	                <p>Product ID: <span id="modalProductId"></span></p>
	                <p>Product Name: <span id="modalProductName"></span></p>
	                <p>Date: <span id="modalDate"></span></p>
	                <p>Amount: <span id="modalAmount"></span></p>
	
	                <p>Reason for Return:</p>
	                <textarea id="returnReason" name="returnReason" rows="4" placeholder="Enter reason for return..." required></textarea>
		            <button class="return-button" type="submit">Return</button>
	            </form>
	        </div>
	    </div>
	</div>
	
	
	<div id="exchangeModal" class="modal">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h2>Exchange Products</h2>
	            <span class="close" onclick="closeExchangeModal()">&times;</span>
	        </div>
	        <div class="modal-body">
	            <div id="pickedProducts">
	                <h3>Picked Products</h3>
	                <table id="pickedProductsTable">
	                    <thead>
	                        <tr>
	                            <th>Product ID</th>
	                            <th>Product Name</th>
	                            <th>Price</th>
	                            <th>Quantity</th>
	                            <th>Amount</th>
	                            <th>Action</th>
	                        </tr>
	                    </thead>
	                    <tbody></tbody>
	                </table>
	                <p>Total Exchange Amount: <span id="totalExchangeAmount">0.00</span></p>
	            </div>
	            <button onclick="processExchange()">Confirm Exchange</button>
	            <div id="availableProducts">
	                <h3>Available Products</h3>
	                <table id="availableProductsTable">
	                    <thead>
	                        <tr>
	                            <th>Product ID</th>
	                            <th>Product Name</th>
	                            <th>Price</th>
	                            <th>Available Quantity</th>
	                            <th>Action</th>
	                        </tr>
	                    </thead>
	                    <tbody></tbody>
	                </table>
	            </div>
	        </div>
	    </div>
	</div>


    
    <script>
    function closeModal() {
        document.getElementById('returnModal').style.display = 'none';
    }

    function closeExchangeModal() {
        document.getElementById('exchangeModal').style.display = 'none';
    }

    function processReturn(action) {
        const billId = document.getElementById('modalBillId').innerText;
        const productId = document.getElementById('modalProductId').innerText;
        const reason = document.getElementById('returnReason').value;
        
        if (reason.trim() === '') {
            alert('Please enter a reason for the return.');
            return;
        }

        console.log('Processing return:', { billId, productId, reason, action });
        closeModal();
    }

    function openModal(billId, productId, productName, price, quantity) {
        const today = new Date().toISOString().split('T')[0];
        const amount = parseFloat(price) * parseInt(quantity);
        
        document.getElementById('modalBillId').innerText = billId;
        document.getElementById('modalProductId').innerText = productId;
        document.getElementById('modalProductName').innerText = productName;
        document.getElementById('modalDate').innerText = today;
        document.getElementById('modalAmount').innerText = amount.toFixed(2);

        document.getElementById('hiddenBillId').value = billId;
        document.getElementById('hiddenProductId').value = productId;
        document.getElementById('hiddenDate').value = today;
        document.getElementById('hiddenAmount').value = amount.toFixed(2);
        document.getElementById('hiddenQuantity').value = quantity;

        document.getElementById('returnModal').style.display = 'block';
    }

    function submitReturnForm(servletName) {
        const returnForm = document.getElementById('returnForm');
        returnForm.action = servletName;
        returnForm.submit();
    }

    function openExchangeModal() {
        document.getElementById('pickedProductsTable').getElementsByTagName('tbody')[0].innerHTML = '';
        document.getElementById('totalExchangeAmount').innerText = '0.00';
        fetchProducts();

        document.getElementById('exchangeModal').style.display = 'block';
    }

    function fetchProducts() {
        fetch('ExchangeServlet')
            .then(response => response.json()) 
            .then(data => {
                const tableBody = document.querySelector('#availableProductsTable tbody');
                tableBody.innerHTML = '';

                data.forEach(product => {
                    const row = document.createElement('tr');
                    
                    const productIdCell = document.createElement('td');
                    productIdCell.textContent = product.productId;
                    
                    const productNameCell = document.createElement('td');
                    productNameCell.textContent = product.productName;
                    
                    const priceCell = document.createElement('td');
                    priceCell.textContent = product.price;
                    
                    const unitsCell = document.createElement('td');
                    unitsCell.textContent = product.units; 
                    
                    const buttonCell = document.createElement('td');
                    const addButton = document.createElement('button');
                    addButton.textContent = 'Add';
                    addButton.onclick = () => addToExchange(product.productId, product.productName, product.price);
                    buttonCell.appendChild(addButton);
                    
                    row.appendChild(productIdCell);
                    row.appendChild(productNameCell);
                    row.appendChild(priceCell);
                    row.appendChild(unitsCell);
                    row.appendChild(buttonCell);
                                                            
                    tableBody.appendChild(row);
                });
            })
            .catch(error => console.error('Error fetching product data:', error));
    }

    function addToExchange(productId, productName, price) {
        const quantity = prompt(`Enter quantity for ${productName}:`, '1');
        if (quantity === null || quantity.trim() === '' || isNaN(quantity) || parseInt(quantity) <= 0) {
            alert('Please enter a valid quantity.');
            return;
        }

        const tableBody = document.getElementById('pickedProductsTable').getElementsByTagName('tbody')[0];
        const total = parseFloat(price) * parseInt(quantity);

        const row = tableBody.insertRow();
        const productIdCell = row.insertCell();
        productIdCell.textContent = productId;

        const productNameCell = row.insertCell();
        productNameCell.textContent = productName;

        const priceCell = row.insertCell();
        priceCell.textContent = price.toFixed(2);

        const quantityCell = row.insertCell();
        quantityCell.textContent = quantity;

        const totalCell = row.insertCell();
        totalCell.textContent = total.toFixed(2);

        const buttonCell = row.insertCell();
        const removeButton = document.createElement('button');
        removeButton.textContent = 'Remove';
        removeButton.onclick = function() {
            removeFromExchange(this); 
        };
        buttonCell.appendChild(removeButton);

        updateTotalExchangeAmount();
    }

    function removeFromExchange(button) {
        const row = button.parentNode.parentNode;
        row.parentNode.removeChild(row);
        updateTotalExchangeAmount();
    }

    function updateTotalExchangeAmount() {
        const tableBody = document.getElementById('pickedProductsTable').getElementsByTagName('tbody')[0];
        let total = 0;

        for (let i = 0; i < tableBody.rows.length; i++) {
            total += parseFloat(tableBody.rows[i].cells[4].innerText);
        }

        document.getElementById('totalExchangeAmount').innerText = total.toFixed(2);
    }

    function processExchange() {
        const billId = document.getElementById('hiddenBillId').value;
        const pickedProducts = [];
        const tableBody = document.getElementById('pickedProductsTable').getElementsByTagName('tbody')[0];

        for (let i = 0; i < tableBody.rows.length; i++) {
            const row = tableBody.rows[i];
            pickedProducts.push({
                productId: row.cells[0].innerText,
                productName: row.cells[1].innerText,
                price: parseFloat(row.cells[2].innerText),
                quantity: parseInt(row.cells[3].innerText)
            });
        }

        const totalExchangeAmount = parseFloat(document.getElementById('totalExchangeAmount').innerText);

        fetch('ExchangeServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                billId: billId,
                exchangeProducts: pickedProducts,
                totalExchangeAmount: totalExchangeAmount
            })
        })
        .then(response => response.text())
        .then(result => {
            closeExchangeModal();
            location.reload(); 
        })
        .catch(error => console.error('Error:', error));
    }

    setTimeout(function() {
        var messageBox = document.getElementById("message-box");
        if (messageBox) {
            messageBox.style.display = "none";
        }
    }, 5000);

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('#ExchangeButton').onclick = function() {
            openExchangeModal();
        };
        
        document.querySelector('#ConfirmExchangeButton').onclick = function() {
            processExchange();
        };
    });


</script>   
    
    <% } else { %>
        <p>No products found for the provided Bill ID.</p>
    <% } } %>
</body>
</html>
