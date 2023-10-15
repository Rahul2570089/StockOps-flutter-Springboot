import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:newsapp/Models/WatchlistStock.dart';
import 'package:newsapp/payload/data.dart';
import 'package:url_launcher/url_launcher.dart';

class BSEWatchlist extends StatefulWidget {
  const BSEWatchlist({Key? key}) : super(key: key);

  @override
  State<BSEWatchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<BSEWatchlist> {
  List<WatchlistStock> bsewatchlist = [];

  @override
  void initState() {
    for (var element in Payload.watchlist) {
      if (element.exchange == 'BSE') {
        bsewatchlist.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bsewatchlist.isNotEmpty
            ? ListView.builder(
                itemCount: bsewatchlist.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: ListTile(
                      title: SizedBox(
                        height: 30,
                        width: 90,
                        child: Marquee(
                          text: bsewatchlist[position].name == ''
                              ? '  Name Unavailable  '
                              : "  ${bsewatchlist[position].name}  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bsewatchlist[position].name ==
                                      '  Name Unavailable  '
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ),
                      leading: Padding(
                          padding: const EdgeInsets.only(right: 120.0),
                          child: Text(
                            bsewatchlist[position].symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      onTap: () {
                        launchUrl(Uri.parse(
                            "https://www.google.com/finance/quote/${bsewatchlist[position].number}:BOM"));
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
