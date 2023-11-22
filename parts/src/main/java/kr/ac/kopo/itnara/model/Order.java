package kr.ac.kopo.itnara.model;

import java.util.Date;
import java.util.List;

public class Order {
    private Long orderId;
    private Long productId;
    private Long userId;
    private Long userId2;  // userId2 추가
    private int zip;
    private String address1;
    private String address2;
    private Date orderDate;
    private Long tracking;

    // Getter 및 Setter 메서드...

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId2() {
        return userId2;
    }

    public void setUserId2(Long userId2) {
        this.userId2 = userId2;
    }

    public int getZip() {
        return zip;
    }

    public void setZip(int zip) {
        this.zip = zip;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

	public Long getTracking() {
		return tracking;
	}

	public void setTracking(Long tracking) {
		this.tracking = tracking;
	}



}
