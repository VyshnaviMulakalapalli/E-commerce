package com.shashi.service;

import java.util.List;

import com.shashi.beans.WishlistBean;

public interface WishlistService {

	public String addToWishlist(String userId, String prodId);

	public List<WishlistBean> getAllWishlistItems(String userId);

	public int getWishlistCount(String userId);

	public String removeFromWishlist(String userId, String prodId);
	
	public boolean isProductInWishlist(String userId, String prodId);

}
