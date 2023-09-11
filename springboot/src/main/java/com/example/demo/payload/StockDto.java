package com.example.demo.payload;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Getter
@Setter
public class StockDto {
	private int stockId;
	private int userId;
	private String name;
	private String symbol;
	private String exchange;
	private int number;
}
