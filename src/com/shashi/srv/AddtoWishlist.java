package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.service.impl.WishlistServiceImpl;


/**
 * Servlet implementation class AddtoWishlist
 */
@WebServlet("/AddtoWishlist")
public class AddtoWishlist extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AddtoWishlist() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		String usertype = (String) session.getAttribute("usertype");
		if (userName == null || password == null || usertype == null || !usertype.equalsIgnoreCase("customer")) {
			response.sendRedirect("login.jsp?message=Session Expired, Login Again to Continue!");
			return;
		}
		
		String userId = userName;
		String prodId = request.getParameter("pid");
		WishlistServiceImpl wishlist = new WishlistServiceImpl();
		
		boolean inwishlist = wishlist.isProductInWishlist(userId, prodId);
		
		PrintWriter pw = response.getWriter();

		response.setContentType("text/html");
		
		if (inwishlist == true) {
			String status = wishlist.removeFromWishlist(userId, prodId);

			RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");

			rd.include(request, response);

			pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
		}
		else {
			String status = wishlist.addToWishlist(userId, prodId);

			RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");

			rd.include(request, response);

			pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
		}
		
		RequestDispatcher rd = request.getRequestDispatcher("wishlistDetails.jsp");

		rd.include(request, response);
        
		

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
