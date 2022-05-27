import '../../screens/markets/crypto_market.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class MarketsTab extends StatefulWidget {
  @override
  _MarketsTabState createState() => _MarketsTabState();
}

class _MarketsTabState extends State<MarketsTab> {
  int currentPage = 1; // For switching tabs.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of Tabs.
      child: Scaffold(
        backgroundColor: kDarkGrey,
        appBar: AppBar(
          elevation: 1.5,
          toolbarHeight: kMinInteractiveDimension,
          bottom: TabBar(
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(10),
            tabs: [
              Text(
                'CRYPTO',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CryptoMarketPage(),
          ],
        ),
      ),
    );
  }
}
