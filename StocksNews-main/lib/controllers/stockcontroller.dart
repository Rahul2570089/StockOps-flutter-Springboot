import 'dart:convert';

import 'package:newsapp/Models/WatchlistStock.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/auth/config.dart';

class StockController {
  static Future<WatchlistStock> addToWatchlist(
      int userId, String name, String symbol, String exchange,
      {int? number}) async {
    var stock = {
      "userId": userId,
      "name": name,
      "symbol": symbol,
      "exchange": exchange,
      "number": number ?? 0
    };

    var response = await http.post(Uri.parse("$url/watchlist/add"),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(stock));

    var jsonResponse = jsonDecode(response.body.toString());

    if (jsonResponse != null) {
      return WatchlistStock(
          stockId: jsonResponse['stockId'],
          userId: jsonResponse['userId'],
          name: jsonResponse['name'],
          symbol: jsonResponse['symbol'],
          exchange: jsonResponse['exchange'],
          number: jsonResponse['number']);
    } else {
      return WatchlistStock(
          stockId: -1,
          userId: -1,
          name: '',
          symbol: '',
          exchange: '',
          number: 0);
    }
  }

  static Future<List<WatchlistStock>> getWatchlist(int userId) async {
    var response = await http.get(
        Uri.parse("$url/watchlist/getAllstocks/$userId"),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body.toString());

    if (jsonResponse != null) {
      List<dynamic> stocks = jsonResponse;
      List<WatchlistStock> watchlist = [];
      for (var element in stocks) {
        watchlist.add(WatchlistStock(
            stockId: element['stockId'],
            userId: element['userId'],
            name: element['name'],
            symbol: element['symbol'],
            exchange: element['exchange'],
            number: element['number']));
      }
      return watchlist;
    } else {
      return [];
    }
  }

  static Future<bool> removeFromWatchlist(int stockId) async {
    var response = await http.delete(
        Uri.parse("$url/watchlist/remove/$stockId"),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body.toString());

    if (jsonResponse != null) {
      return true;
    } else {
      return false;
    }
  }
}
