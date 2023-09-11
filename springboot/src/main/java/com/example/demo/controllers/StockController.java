package com.example.demo.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.payload.ApiResponse;
import com.example.demo.payload.StockDto;
import com.example.demo.services.StockService;

@RestController
@RequestMapping("/api/watchlist")
public class StockController {

	@Autowired
	private StockService stockService;
	
	@PostMapping("/add")
	public ResponseEntity<StockDto> addToWatchlist(@RequestBody StockDto stockDto) {
		StockDto stock = this.stockService.addToWatchlist(stockDto);
		return new ResponseEntity<StockDto>(stock, HttpStatus.CREATED);
	}
	
	@DeleteMapping("/remove/{stockId}")
	public ResponseEntity<ApiResponse> removeFromWatchlist(@PathVariable Integer stockId) {
		this.stockService.removeFromWatchlist(stockId);
		return new ResponseEntity<ApiResponse>(new ApiResponse("Stock removed from watchlist succesfully", true), HttpStatus.OK);
	}
	
	@GetMapping("/getAllstocks/{userId}")
	public ResponseEntity<List<StockDto>> getStocksByUserId(@PathVariable Integer userId) {
		List<StockDto> stocks = this.stockService.getStocksByUserId(userId);
		return new ResponseEntity<List<StockDto>>(stocks, HttpStatus.OK);
	}
	
	@GetMapping("/get/{stockId}")
	public ResponseEntity<StockDto> getStockByStockId(@PathVariable Integer stockId) {
		StockDto stock = this.stockService.getStockByStockId(stockId);
		return new ResponseEntity<StockDto>(stock, HttpStatus.OK);
	}

	
}
