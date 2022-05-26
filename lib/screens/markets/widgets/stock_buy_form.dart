import 'package:CrypSim/models/stock.dart';
import 'package:CrypSim/services/database/stock_portfolio_database.dart';
import 'package:CrypSim/services/database/stock_watchlist_database.dart';
import 'package:CrypSim/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockBuyForm extends StatefulWidget {
  final Stock stock;
  StockBuyForm(this.stock);

  @override
  _StockBuyFormState createState() => _StockBuyFormState();
}

class _StockBuyFormState extends State<StockBuyForm> {
  void initState() {
    _c = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  // Form Values
  double _price;
  int _quantity;
  TextEditingController _c;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.stock.ticker.toUpperCase(),
            style: kListTextStyle,
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                'Price:',
                style: kLabelStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 35,
              ),
              Flexible(
                child: TextFormField(
                  controller: _c,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  validator: (val) {
                    if (val != '') {
                      try {
                        double.parse(val);
                        return null;
                      } catch (e) {
                        return 'Enter a valid number';
                      }
                    } else {
                      return 'Enter a valid number';
                    }
                  },
                  onChanged: (val) {
                    setState(() => _price = double.parse(val.trim()));
                  },
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _c.text = "${widget.stock.currentPrice}";
                    _price = widget.stock.currentPrice;
                  });
                },
                child: Text(
                  'CMP',
                  style: kLabelStyle.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                'Amount:',
                style: kLabelStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (val) {
                    if (val != '') {
                      try {
                        int.parse(val);
                        return null;
                      } catch (e) {
                        return 'Enter a valid number';
                      }
                    } else {
                      return 'Enter a valid number';
                    }
                  },
                  onChanged: (val) {
                    setState(() => _quantity = int.parse(val.trim()));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (await StockPortfolioDatabaseService(
                                  uid: FirebaseAuth.instance.currentUser.uid)
                              .checkIfDocExists(
                                  widget.stock.ticker.toUpperCase()) ==
                          false) {
                        await StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .buyStock(
                          name: widget.stock.name,
                          ticker: widget.stock.ticker.toUpperCase(),
                          currentValue: (_quantity * _price),
                          invested: (_quantity * _price),
                          percentage: 0,
                          profit: 0,
                          quantity: _quantity,
                        );
                        StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateTotalInvested();
                        StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateCurrentValue();
                      } else {
                        StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updatePortfolio();
                        await StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .partialBuy(
                          ticker: widget.stock.ticker.toUpperCase(),
                          price: _price,
                          quantity: _quantity,
                          invested: (_price * _quantity),
                        );
                        StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateTotalInvested();
                        StockPortfolioDatabaseService(
                                uid: FirebaseAuth.instance.currentUser.uid)
                            .updateCurrentValue();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(
                            milliseconds: 1500,
                          ),
                          backgroundColor: Colors.green,
                          content: Text(
                            'Your ${widget.stock.ticker.toUpperCase()} Buy Order has been fully executed.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'BUY',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    StockWatchlistDatabaseService(
                            uid: FirebaseAuth.instance.currentUser.uid)
                        .addStock(
                      ticker: widget.stock.ticker.toUpperCase(),
                      name: widget.stock.name,
                      currentPrice: widget.stock.currentPrice,
                      open: widget.stock.open,
                      high: widget.stock.high,
                      low: widget.stock.low,
                      percentage: widget.stock.percentage,
                      volume: widget.stock.volume,
                      closeyest: widget.stock.closeyest,
                      marketcap: widget.stock.marketcap,
                      eps: widget.stock.eps,
                      pe: widget.stock.pe,
                      high52: widget.stock.high52,
                      low52: widget.stock.low52,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text(
                        '${widget.stock.ticker.toUpperCase()} was added to your Watchlist.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ));
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'FAVORITE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
