class WatchlistStock {
  int stockId;
  int userId;
  String name;
  String symbol;
  String exchange;
  int number;

  WatchlistStock(
      {required this.stockId,
      required this.userId,
      required this.name,
      required this.symbol,
      required this.exchange,
      required this.number});
}
