import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'models/transaction.dart';
import 'widgets/newTransaction.dart';
import 'widgets/transactionList.dart';
import 'widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // these three line force device to be in a certain Orientation
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'QuickSand',
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'QuickSand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    // new Transaction(
    //   id: 't1',
    //   title: 'new shoes',
    //   amount: 159.99,
    //   date: DateTime.now(),
    // ),
    // new Transaction(
    //   id: 't2',
    //   title: 'T-shirt',
    //   amount: 127.99,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          new Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTx(String id) {
    setState(() {
      _userTransactions.removeWhere((element) {
        return id == element.id;
      });
    });
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
          );
        });
  }

  List<Widget> _buildLandScapeWidget(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          // NewTransaction(),
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitWidget(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.39,
        child: Chart(_recentTransactions),
      ),
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.61,
        child: TransactionList(
          userTransactions: _userTransactions,
          deleteTx: _deleteTx,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
            trailing: Row(
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () {
                    startAddNewTransaction(context);
                  },
                ),
              ],
            ),
          )
        : AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  startAddNewTransaction(context);
                },
              ),
            ],
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: TransactionList(
        userTransactions: _userTransactions,
        deleteTx: _deleteTx,
      ),
    );
    final _pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isLandScape)
              ..._buildPortraitWidget(mediaQuery, appBar, txListWidget),

            if (isLandScape)
              ..._buildLandScapeWidget(mediaQuery, appBar, txListWidget),

            // UserTransaction(),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: _pageBody)
        : Scaffold(
            appBar: appBar,
            body: _pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      startAddNewTransaction(context);
                    },
                    child: Icon(Icons.add),
                  ),
          );
  }
}
