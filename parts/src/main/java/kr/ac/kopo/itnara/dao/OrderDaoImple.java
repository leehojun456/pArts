package kr.ac.kopo.itnara.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.kopo.itnara.model.Order;

@Repository
public class OrderDaoImple implements OrderDao {

	@Autowired
	SqlSession sql;
	
	@Override
	public List<Order> list(Long userId) {
		// TODO Auto-generated method stub
		return sql.selectList("order.list", userId);
	}

	@Override
	public List<Order> purchaseList(Long userId) {
		// TODO Auto-generated method stub
		return sql.selectList("order.purchaseList", userId);
	}

	@Override
	public void updateTracking(Order order) {
		// TODO Auto-generated method stub
		sql.update("order.updateTracking", order);
	}

}
