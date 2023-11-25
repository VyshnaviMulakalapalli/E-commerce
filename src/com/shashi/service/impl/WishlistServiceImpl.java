package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.WishlistBean;
import com.shashi.service.WishlistService;
import com.shashi.utility.DBUtil;

public class WishlistServiceImpl implements WishlistService {

    @Override
    public String addToWishlist(String userId, String prodId) {
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            // Check if the product is already in the wishlist
            if (!isProductInWishlist(userId, prodId)) {
                ps = con.prepareStatement("INSERT INTO wishlist (username, prodid) VALUES (?, ?)");
                ps.setString(1, userId);
                ps.setString(2, prodId);
                ps.executeUpdate();
                return "Product added to wishlist successfully";
            } else {
                return "Product is already in the wishlist";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error adding product to wishlist";
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }
    }

    @Override
    public List<WishlistBean> getAllWishlistItems(String userId) {
        List<WishlistBean> wishlistItems = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM wishlist WHERE username = ?");
            ps.setString(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                WishlistBean item = new WishlistBean(rs.getString("username"), rs.getString("prodid"), true);
                wishlistItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
        	DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return wishlistItems;
    }

    @Override
    public int getWishlistCount(String userId) {
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            ps = con.prepareStatement("SELECT COUNT(*) FROM wishlist WHERE username = ?");
            ps.setString(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
        	DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return count;
    }

    @Override
    public String removeFromWishlist(String userId, String prodId) {
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            if (isProductInWishlist(userId, prodId)) {
                ps = con.prepareStatement("DELETE FROM wishlist WHERE username = ? AND prodid = ?");
                ps.setString(1, userId);
                ps.setString(2, prodId);
                ps.executeUpdate();
                return "Product removed from wishlist successfully";
            } else {
                return "Product is not in the wishlist";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error removing product from wishlist";
        } finally {
        	DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }
    }

    @Override
    public boolean isProductInWishlist(String userId, String prodId) {
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM wishlist WHERE username = ? AND prodid = ?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            rs = ps.executeQuery();

            return rs.next();
        } catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
        	DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
    }
}
