import 'dart:core';
import 'dart:io';
//import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:decimal/decimal.dart';
import 'package:money_alive/models/account.dart';
import 'package:money_alive/models/account_type.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Money Alive',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red ,
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),

        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
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

class _MyHomePageStage extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [];

  static final List<Account> _accounts = [
    Account('a1', 'Dinheiro', AccountType.movement),
    Account('a2', 'Conta Corrente', AccountType.movement),
    Account('a0', 'Saldo Inicial', AccountType.initialBalance),
    Account('a3', 'Cartão de Crédito', AccountType.credit),
    Account('a4', 'Poupança', AccountType.investment),
    Account('a5', 'Trabalho', AccountType.asset),
    Account('a6', 'Empréstimo', AccountType.loan),
    Account('a7', 'Casa', AccountType.loss),
    Account('a8', 'Mercado', AccountType.loss),
    Account('a9', 'Carro', AccountType.loss),
    Account('a10', 'Juros', AccountType.loan),
    Account('a11', 'Saúde', AccountType.loss),
    Account('a12', 'Diversão', AccountType.loss),
    Account('a13', 'Presentes', AccountType.loss),
  ];

  static final DateTime _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  double _heightAcounts =
  (20.0 * _accounts.where((ac) => ac.isType(AccountType.movement)).length) + 6 ;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.getDate().isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
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
      chosenDate ?? _today,
      inputAccount,
      outputAccount,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
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
          child: NewTransaction(_addNewTransaction, _accounts),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  PreferredSizeWidget iosAppBar(Text title) {
    return CupertinoNavigationBar(
      middle: title,
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
    final title = Text("My Money Alyve");
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
                children: _accounts
                    .where((ac) => ac.isType(AccountType.movement))
                    .map((account) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              ' ${account.getName()}',
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              'R\$ ${account.getBalanceByDate(_today).toString()} ',
                              style: Theme.of(context).textTheme.title,
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
              child: TransactionList(_userTransactions, _deleteTransaction),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
