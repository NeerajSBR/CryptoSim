import 'package:CrypSim/screens/settings/user_screen.dart';
import 'package:CrypSim/screens/watchlist/crypto_watchlist.dart';
import 'package:CrypSim/services/database/auth.dart';
import 'package:CrypSim/tabs/nested_tabs/news_tab.dart';
import 'package:CrypSim/tabs/nested_tabs/portfolio_tab.dart';

import 'package:CrypSim/tabs/nested_tabs/watchlist_tab.dart';

import '../screens/markets/crypto_market.dart';
import '../screens/news/crypto_news.dart';
import '../screens/portfolio/crypto_portfolio.dart';
import '../shared/constants.dart';
import 'package:flutter/material.dart';

import 'nested_tabs/markets_tab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final AuthService _auth = AuthService();

  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.star),
          label: 'Watchlist'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.show_chart_rounded),
          label: 'Markets'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.web_rounded),
          label: 'News'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.account_balance_wallet),
          label: 'Portfolio'),
    ];
    PageController _controller = PageController(
      initialPage: currentPage,
    );

    void onTapIcon(int index) => _controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: <Widget>[
          PopupMenuButton<String>(
            color: kMediumGrey,
            padding: EdgeInsets.all(0),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((Map choice) {
                return PopupMenuItem<String>(
                  padding: EdgeInsets.all(0),
                  value: choice["text"],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      choice["icon"],
                      Text(
                        choice["text"],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
        centerTitle: true,
        title: kAppName,
        elevation: 0,
      ),
      backgroundColor: kDarkGrey,
      body: PageView(
        controller: _controller,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: [
          Center(
            child: CryptoWatchlist(),
          ),
          Center(
            child: CryptoMarketPage(),
          ),
          Center(
            child: CryptoNews(),
          ),
          Center(
            child: CryptoPortfolio(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        backgroundColor: kDarkGrey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        onTap: onTapIcon,
        items: items,
      ),
    );
  }

  void choiceAction(String choice) async {
    if (choice == Constants.Settings) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserScreen()));
    } else if (choice == Constants.SignOut) {
      await _auth.signOut();
    }
  }
}

class Constants {
  static const String Settings = 'Settings';
  static const String SignOut = 'Sign out';
  static const Icon SettingsIcon = Icon(Icons.settings);
  static const Icon SignOutIcon = Icon(Icons.logout);

  static const List<Map> choices = <Map>[
    {"text": Settings, "icon": SettingsIcon},
    {"text": SignOut, "icon": SignOutIcon},
  ];
  // static const List<Icon> icons = <Icon>[SettingsIcon, SignOutIcon];
}
