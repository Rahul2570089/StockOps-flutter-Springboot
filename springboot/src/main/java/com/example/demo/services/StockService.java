package com.example.demo.services;

import java.util.List;

import com.example.demo.payload.StockDto;

public interface StockService {
	StockDto addToWatchlist(StockDto stockDto);
	void removeFromWatchlist(Integer stockId);
	List<StockDto> getStocksByUserId(Integer userId);
	StockDto getStockByStockId(Integer stockId);
}
