class Stock {
  String? name;
  String? symbol;
  int? no;

  Stock({this.name, this.symbol, this.no});

  factory Stock.fromJsonNSE(Map json) {
    return Stock(
      name: json["Company Name"],
      symbol: json["Symbol"],
    );
  }

  factory Stock.fromJsonBSE(Map json) {
    return Stock(
        name: json["Security Name"],
        symbol: json["Security Id"],
        no: json["Security Code"]);
  }
}
