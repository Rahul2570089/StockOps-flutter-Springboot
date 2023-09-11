package com.example.demo.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.demo.entites.Stock;

public interface StockRepository extends JpaRepository<Stock, Integer> {
	@Query("select s from Stock s where s.userId = :userId")
	public List<Stock> getStocksByUserId(@Param(value = "userId") Integer userId);
}
