import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:newsapp/Models/WatchlistStock.dart';
import 'package:newsapp/payload/data.dart';
import 'package:url_launcher/url_launcher.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<WatchlistStock> nsewatchlist = [];

  @override
  void initState() {
    for (var element in Payload.watchlist) {
      if (element.exchange == 'NSE') {
        nsewatchlist.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: nsewatchlist.isNotEmpty
            ? ListView.builder(
                itemCount: nsewatchlist.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: ListTile(
                      title: SizedBox(
                        height: 30,
                        width: 90,
                        child: Marquee(
                          text: nsewatchlist[position].name == ''
                              ? '  Name Unavailable  '
                              : "  ${nsewatchlist[position].name}  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: nsewatchlist[position].name ==
                                      '  Name Unavailable  '
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ),
                      leading: Padding(
                          padding: const EdgeInsets.only(right: 120.0),
                          child: Text(
                            nsewatchlist[position].symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      onTap: () {
                        launchUrl(Uri.parse(
                            "https://www.google.com/finance/quote/${nsewatchlist[position].symbol}:NSE"));
                      },
                    ),
                  );
                })
            : const Center(
                child: Text(
                'Watchlist is Empty',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )));
  }
}
