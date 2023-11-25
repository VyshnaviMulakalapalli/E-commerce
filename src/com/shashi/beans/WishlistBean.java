package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class WishlistBean implements Serializable {

	public WishlistBean() {
	}

	public String userId;

	public String prodId;

	public boolean inWishlist;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProdId() {
		return prodId;
	}

	public void setProdId(String prodId) {
		this.prodId = prodId;
	}
	
	public boolean isInWishlist() {
        return inWishlist;
    }

    public void setInWishlist(boolean inWishlist) {
        this.inWishlist = inWishlist;
    }

	public WishlistBean(String userId, String prodId, boolean inWishlist) {
		super();
		this.userId = userId;
		this.prodId = prodId;
		this.inWishlist = inWishlist;
	}
	
}
