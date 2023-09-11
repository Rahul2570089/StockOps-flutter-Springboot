package com.example.demo.services.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.entites.Stock;
import com.example.demo.exceptions.ResourceNotFoundExceptionHandler;
import com.example.demo.payload.StockDto;
import com.example.demo.repositories.StockRepository;
import com.example.demo.services.StockService;


@Service
public class StockServiceImpl implements StockService {

	@Autowired
	private StockRepository stockRepository;
	
	@Autowired
	private ModelMapper modelMapper;
	
	@Override
	public StockDto addToWatchlist(StockDto stockDto) {
		Stock stock = toStock(stockDto);
		Stock newStock = this.stockRepository.save(stock);
		return toStockDto(newStock);
	}

	@Override
	public void removeFromWatchlist(Integer stockId) {
		Stock stock = this.stockRepository.findById(stockId).orElseThrow(() -> new ResourceNotFoundExceptionHandler("Stock", "id", stockId));
		this.stockRepository.delete(stock);
	}

	@Override
	public List<StockDto> getStocksByUserId(Integer userId) {
		List<Stock> stocks = this.stockRepository.getStocksByUserId(userId);
		List<StockDto> stocksDto = stocks.stream().map(stock -> toStockDto(stock)).collect(Collectors.toList());
		return stocksDto;
	}

	@Override
	public StockDto getStockByStockId(Integer stockId) {
		Stock stock = this.stockRepository.findById(stockId).orElseThrow(() -> new ResourceNotFoundExceptionHandler("Stock", "id", stockId));
		return toStockDto(stock);
	}
	
	private StockDto toStockDto(Stock stock) {
		return this.modelMapper.map(stock, StockDto.class);
	}
	
	private Stock toStock(StockDto stockDto) {
		return this.modelMapper.map(stockDto, Stock.class);
	}
	
	
}
