<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>UNH Electronics</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #FFF;">
	<%
	String currentView = (String) session.getAttribute("view");
	if (currentView == null) {
	    currentView = "grid"; 
	}
	session.setAttribute("view", currentView);
	%>

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	String userType = (String) session.getAttribute("usertype");

	boolean isValidUser = true;

	if (userType == null || userName == null || password == null || !userType.equals("customer")) {

		isValidUser = false;
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>

	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
	<div class="text-center" id="message"
		style="color: black; font-size: 14px; font-weight: bold;"></div>
	<!-- Start of Product Items List -->
	<div id="gridViewContainer" class="view-container">
		<div class="container">
			<div class="row text-center">
	
				<%
				for (ProductBean product : products) {
					int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
				%>
				<div class="col-sm-4" style='height: 350px;'>
					<div class="thumbnail">
						<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
							style="height: 150px; max-width: 180px">
						<p class="productname"><%=product.getProdName()%>
						</p>
						<%
						String description = product.getProdInfo();
						description = description.substring(0, Math.min(description.length(), 100));
						%>
						<p class="productinfo"><%=description%>..
						</p>
						<p class="price">
							$
							<%=product.getProdPrice()%>
						</p>
						<form method="post">
							<%
							if (cartQty == 0) {
							%>
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&view=<%=currentView%>"
								class="btn btn-success">Add to Cart</button>
							&nbsp;&nbsp;&nbsp;
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&view=<%=currentView%>"
								class="btn btn-primary">Buy Now</button>
							<%
							} else {
							%>
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&view=<%=currentView%>"
								class="btn btn-danger">Remove From Cart</button>
							&nbsp;&nbsp;&nbsp;
							<button type="submit" formaction="cartDetails.jsp"
								class="btn btn-success">Checkout</button>
							<%
							}
							%>
						</form>
						<br />
					</div>
				</div>
	
				<%
				}
				%>
	
			</div>
		</div>
	</div>
	
	<div id="listViewContainer" class="view-container">
		<div class="container-fluid">
			<div class="table-responsive ">
			
				<table class="table table-hover">
					<thead
						style="background-color: #2c6c4b; color: white; font-size: 18px;">
						<tr>
							<th>Image</th>
							<th>Name</th>
							<!-- <th>Description</th> -->
							<th>Type</th>
							<th>Price</th>
							<th colspan="2" style="text-align: center">Actions</th>
						</tr>
					</thead>
					<tbody style="background-color: white; font-size: 16px;">
	
						<%
						for (ProductBean product : products) {
							int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
						
						%>
						
						<tr>
							<td><img src="./ShowImage?pid=<%=product.getProdId()%>"
								style="width: 50px; height: 50px;"></td>
							
							<%
							String name = product.getProdName();
							name = name.substring(0, Math.min(name.length(), 100));
							%>
							<td><%=name%></td>
							<%
						String description = product.getProdInfo();
						description = description.substring(0, Math.min(description.length(), 25)) + "..";
						%>
						<!-- <td><%=description%></td> -->
							<td><%=product.getProdType().toUpperCase()%></td>
							<td><%=product.getProdPrice()%></td>
							
							
							
							<%
							if (cartQty == 0) {
							%>
							<td>
							<form method="post">
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&view=<%=currentView%>"
								class="btn btn-success" style="margin-left: 60px;">Add to Cart</button>
							&nbsp;&nbsp;&nbsp;
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&view=<%=currentView%>"
								class="btn btn-primary" style="margin-left: 110px;">Buy Now</button>
							</form>
							</td>
							<%
							} else {
							%>
							<td>
							<form method="post">
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&view=<%=currentView%>"
								class="btn btn-danger" style="margin-left: 60px;">Remove From Cart</button>
							&nbsp;&nbsp;&nbsp;
							<button type="submit" formaction="cartDetails.jsp"
								class="btn btn-success" style="margin-left: 60px;">Checkout</button>
							</form>
							
							</td>
							<%
							}
							%>
	
						</tr>
						<%
						}
						%>
	
						
						<%
						if (products.size() == 0) {
						%>
						<tr style="background-color: grey; color: white;">
							<td colspan="7" style="text-align: center;">No Items
								Available</td>
	
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- ENd of Product Items List -->
	
	<div style="position: fixed; bottom: 20px; right: 20px;">
	    <!-- <label for="viewDropdown" style="font-size: 10px;">Select View:</label>!> -->
	    <select id="viewDropdown" style="width: 50px; font-size: 12px;">
	        <option value="grid">Grid View</option>
	        <option value="list">List View</option>
	    </select>
	</div>
	
	<script>
	document.addEventListener("DOMContentLoaded", function() {
	    var viewDropdown = document.getElementById("viewDropdown");
	    var gridViewContainer = document.getElementById("gridViewContainer");
	    var listViewContainer = document.getElementById("listViewContainer");
	    
	    var currentView = "<%= session.getAttribute("view") %>";
	    viewDropdown.value = currentView;
	
	    if (currentView === "grid") {
	        gridViewContainer.style.display = "block";
	        listViewContainer.style.display = "none";
	    } else if (currentView === "list") {
	        gridViewContainer.style.display = "none";
	        listViewContainer.style.display = "block";
	    }
	
	    viewDropdown.addEventListener("change", function() {
	        var selectedView = viewDropdown.value;
	        fetch('updateView.jsp?view=' + selectedView)
	
	        if (selectedView === "grid") {
	            gridViewContainer.style.display = "block";
	            listViewContainer.style.display = "none";
	        } else if (selectedView === "list") {
	            gridViewContainer.style.display = "none";
	            listViewContainer.style.display = "block";
	        }
	    });
	});
	</script>

	<%@ include file="footer.html"%>

</body>
</html>