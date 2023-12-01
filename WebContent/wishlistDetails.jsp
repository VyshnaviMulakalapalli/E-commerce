<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*, javax.servlet.ServletOutputStream, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Wishlist Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color: #FFF;">

    <%-- Checking the user credentials --%>
    <%
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        WishlistServiceImpl wishlist = new WishlistServiceImpl();
        List<WishlistBean> wishlistItems = wishlist.getAllWishlistItems(userName);
        double totAmount = 0;
    %>

    <jsp:include page="header.jsp" />

    <div class="text-center" style="color: green; font-size: 24px; font-weight: bold;">Wishlist Items</div>

    <!-- Start of Wishlist Items List -->
    <div class="container">
        <table class="table table-hover">
            <thead style="background-color: #186188; color: white; font-size: 16px; font-weight: bold;">
                <tr>
                    <th>Picture</th>
                    <th>Products</th>
                    <th colspan="3" style="text-align: center">Actions</th>
                </tr>
            </thead>
            <tbody style="background-color: white; font-size: 15px; font-weight: bold;">
                <%
                    for (WishlistBean item : wishlistItems) {
                        String prodId = item.getProdId();
                        ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
                        boolean inWishlist = new WishlistServiceImpl().isProductInWishlist(userName, product.getProdId());
                        int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
                %>
                <tr>
                    <td><img src="./ShowImage?pid=<%=product.getProdId()%>" style="width: 50px; height: 50px;"></td>
                    <td><%=product.getProdName()%></td>
                    <td>
				        <a href="AddtoWishlist?pid=<%=product.getProdId()%>&inWishlist=true"><i class="fa fa-remove"></i></a>
				    </td>
				    		<%
							if (cartQty == 0) {
							%>
							<td>
							<form method="post">
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
								class="btn btn-success" style="margin-left: 60px;">Add to Cart</button>
							&nbsp;&nbsp;&nbsp;
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
								class="btn btn-primary" style="margin-left: 110px;">Buy Now</button>
							</form>
							</td>
							<%
							} else {
							%>
							<td>
							<form method="post">
							<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
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
            </tbody>
        </table>
    </div>
    <!-- End of Wishlist Items List -->

    <%@ include file="footer.html"%>

</body>
</html>
