import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newsapp/Stockslist/bse.dart';
import 'package:newsapp/News/news.dart';
import 'package:newsapp/Watchlist/BSE_watchlist.dart';
import 'package:newsapp/auth/createuser_page.dart';
import 'package:newsapp/controllers/stockcontroller.dart';
import 'package:newsapp/Stockslist/nse.dart';
import 'package:newsapp/Watchlist/nse_watchlist.dart';
import 'package:newsapp/payload/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedindex = 0;

  static List<Widget> widgetOptions = [
    const Stocks(),
    const News(),
    const Watchlist(),
  ];

  @override
  void initState() {
    super.initState();
    StockController.getWatchlist(Payload.user.id!).then((value) => {
          Payload.watchlist = value,
          for (var element in value)
            {
              if (element.exchange == 'NSE')
                {Payload.nsewatchlist.add(element)}
              else
                {Payload.bsewatchlist.add(element)}
            }
        });

    log(Payload.watchlist.toString());
    log(Payload.nsewatchlist.toString());
    log(Payload.bsewatchlist.toString());
    log(Payload.user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 233, 233),
        appBar: AppBar(
            title: Text(
              selectedindex == 0
                  ? 'Stocks'
                  : selectedindex == 1
                      ? 'News'
                      : 'Watchlist',
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateUserPage()),
                                        (route) => false);
                                  },
                                  child: const Text("Yes")),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
            ],
            bottom: selectedindex == 0 || selectedindex == 2
                ? const TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          "NSE",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "BSE",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  )
                : null),
        body: selectedindex == 1
            ? Center(
                child: widgetOptions.elementAt(selectedindex),
              )
            : selectedindex == 0
                ? const TabBarView(children: [Stocks(), BSE()])
                : const TabBarView(children: [Watchlist(), BSEWatchlist()]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/stocks.png",
                width: 35,
                height: 35,
              ),
              label: "Stocks",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/news.png",
                  width: 35,
                  height: 35,
                ),
                label: "News",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/watchlist.png",
                  width: 40,
                  height: 40,
                ),
                label: "Watchlist",
                backgroundColor: Colors.white),
          ],
          currentIndex: selectedindex,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            setState(() {
              selectedindex = index;
            });
          },
        ),
      ),
    );
  }
}
