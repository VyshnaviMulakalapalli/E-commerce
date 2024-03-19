<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="java.io.*,java.net.*,java.util.*,com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*"%>
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
    <!-- Your existing head content -->
</head>
<body style="background-color: #FFF;">
	<%
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	String userType = (String) session.getAttribute("usertype");
	
	boolean isValidUser = true;
	
	if (userType == null || userName == null || password == null || !userType.equals("customer")) {
	
		isValidUser = false;
	}
	%>
	<jsp:include page="header.jsp" />
	<%
    // Fetch product data from the API
    String apiUrl = "https://fakestoreapi.com/products";
    String jsonData = "";
    try {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.connect();

        // Read the response
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        while ((line = rd.readLine()) != null) {
            jsonData += line;
        }
        rd.close();
    } catch (Exception e) {
        out.println("Error fetching data from API: " + e.getMessage());
    }
	%>
	
	<%@ include file="footer.html"%>


</body>
</html>
	