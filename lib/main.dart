import 'dart:core';
import 'dart:io';
//import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:decimal/decimal.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import './models/account.dart';
import './models/enum_types.dart';
import './dummy_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Money Alive',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          color: Colors.purple,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      /*localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('pt_BR'), // Brazilian Portuguese
      ],*/
      home: MyHomePage(),
      //locale: Locale('pt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageStage createState() => _MyHomePageStage();
}

class _MyHomePageStage extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  DateTime getToday() =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final int _maxTransactionsToDisplay = 10;

  double _heightAcounts =
      (20.0 * accounts.where((ac) => ac.isType(AccountType.movement)).length) +
          6;

  List<Transaction> get _recentTransactions {
    return userTransactions.where((tx) {
      return tx.getDate().isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          );
    }).toList();
  }

  List<Transaction> get _lastOrderedTransactions {
    return userTransactions.reversed.take(_maxTransactionsToDisplay).toList();
  }

  void _addNewTransaction(
    String txTitle,
    Decimal txAmount,
    DateTime chosenDate,
    Account inputAccount,
    Account outputAccount,
  ) {
    final newTx = Transaction(
      DateTime.now().toString(),
      txTitle,
      txAmount,
      chosenDate ?? getToday(),
      inputAccount,
      outputAccount,
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      userTransactions.removeWhere((tx) {
        if (tx.id == id) {
          tx.delete();
          return true;
        }
        return false;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction, accounts),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  PreferredSizeWidget iosAppBar(Text title) {
    return CupertinoNavigationBar(
      middle: title,
      actionsForegroundColor: Colors.white,
      backgroundColor: Colors.purple,
      trailing: GestureDetector(
        child: Icon(CupertinoIcons.add),
        onTap: () => _startAddNewTransaction(context),
      ),
    );
  }

  PreferredSizeWidget androidAppBar(Text title) {
    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = Text("My Money Alyve", style: TextStyle(color: Colors.white));
    final mediaQuery = MediaQuery.of(context);
    final appBar = Platform.isIOS ? iosAppBar(title) : androidAppBar(title);

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top -
                      _heightAcounts) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
            //Divider(),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              height: _heightAcounts,
              //color: Colors.amber,
              child: Column(
                children: accounts
                    .where((ac) => ac.isType(AccountType.movement))
                    .map((account) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              account.getName(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              account.getBalanceByDate(getToday()),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            //Divider(),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top -
                      _heightAcounts) *
                  0.7,
              child:
                  TransactionList(_lastOrderedTransactions, _deleteTransaction),
            ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            /* 
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),              
            ),*/
          );
  }
}
