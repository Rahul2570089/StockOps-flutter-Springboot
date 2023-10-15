import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:newsapp/Models/WatchlistStock.dart';
import 'package:newsapp/Models/stock.dart';
import 'package:newsapp/controllers/stockcontroller.dart';
import 'package:newsapp/payload/data.dart';
import 'package:url_launcher/url_launcher.dart';

class BSE extends StatefulWidget {
  const BSE({Key? key}) : super(key: key);

  @override
  State<BSE> createState() => _BSEState();
}

class _BSEState extends State<BSE> {
  List? mapresponse;
  TextEditingController c = TextEditingController();
  List<Stock> list = [];
  List<Stock> list2 = [];
  bool show = false;
  TabController? tabController;

  Future<List<Stock>> apicall() async {
    http.Response response;
    response = await http.get(
        Uri.parse("https://rahul2570089.github.io/jsonAPI/BSE_stocks.json"));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          mapresponse = json.decode(response.body);
          var resp = mapresponse as List;
          list = resp.map((json) => Stock.fromJsonBSE(json)).toList();
        });
      }
    }
    return list;
  }

  Widget listview(List<Stock> stocks) {
    return ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              title: SizedBox(
                height: 50,
                width: 90,
                child: Row(
                  children: [
                    Expanded(
                      child: Marquee(
                        text: stocks[position].name! == ''
                            ? '  Name Unavailable  '
                            : "  ${stocks[position].name!}  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: stocks[position].name! == ''
                                ? Colors.red
                                : Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: Payload.bsewatchlist.any((element) =>
                                element.symbol == stocks[position].symbol)
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: Payload.bsewatchlist.isEmpty ||
                              Payload.bsewatchlist.any((element) =>
                                  element.symbol != stocks[position].symbol)
                          ? () async {
                              setState(() {
                                StockController.addToWatchlist(
                                        Payload.user.id!,
                                        stocks[position].name!,
                                        stocks[position].symbol!,
                                        "BSE",
                                        number: stocks[position].no!)
                                    .then((value) {
                                  Payload.watchlist.add(
                                    WatchlistStock(
                                      name: value.name,
                                      symbol: value.symbol,
                                      exchange: "BSE",
                                      stockId: value.stockId,
                                      userId: value.userId,
                                      number: value.number,
                                    ),
                                  );

                                  Payload.bsewatchlist.add(
                                    WatchlistStock(
                                      name: value.name,
                                      symbol: value.symbol,
                                      exchange: "BSE",
                                      stockId: value.stockId,
                                      userId: value.userId,
                                      number: value.number,
                                    ),
                                  );
                                });
                              });
                              Fluttertoast.showToast(
                                  msg: "Added to watchlist",
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                          : () async {
                              int stockid = -1;
                              for (var element in Payload.bsewatchlist) {
                                if (element.symbol == stocks[position].symbol) {
                                  stockid = element.stockId;
                                  break;
                                }
                              }
                              if (stockid != -1) {
                                setState(() {
                                  StockController.removeFromWatchlist(
                                    stockid,
                                  ).then((value) {
                                    Payload.watchlist.removeWhere((element) =>
                                        element.stockId == stockid);
                                    Payload.bsewatchlist.removeWhere(
                                        (element) =>
                                            element.stockId == stockid);
                                  });
                                });
                              }
                              Fluttertoast.showToast(
                                  msg: "Removed from watchlist",
                                  toastLength: Toast.LENGTH_SHORT);
                            },
                    ),
                  ],
                ),
              ),
              leading: Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  child: Text(
                    stocks[position].symbol!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              onTap: () {
                launchUrl(Uri.parse(
                    "https://www.google.com/finance/quote/${stocks[position].no}:BOM"));
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: TextField(
            onChanged: ((value) => {
                  setState(() {
                    value = value.toUpperCase();
                    list2 = list
                        .where((element) => element.symbol!.contains(value))
                        .toList();
                    show = true;
                  })
                }),
            controller: c,
            decoration: const InputDecoration(
              hintText: "Enter stock",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const Divider(
          thickness: 0.6,
          color: Colors.black,
        ),
        Expanded(
          child: !show
              ? FutureBuilder<List<Stock>>(
                  future: apicall(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? listview(snapshot.data!)
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                  })
              : listview(list2),
        ),
      ],
    );
  }
}
