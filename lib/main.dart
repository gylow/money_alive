import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        //errorColor: Colors.red ,
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
      home: MyHomePage(),
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
    Account(id: 'a0', name: 'Saldo Inicial', type: AccountType.initialBalance),
    Account(id: 'a1', name: 'Dinheiro', type: AccountType.movement),
    Account(id: 'a2', name: 'Conta Corrente', type: AccountType.movement),
    Account(id: 'a3', name: 'Cartão de Crédito', type: AccountType.credit),
    Account(id: 'a4', name: 'Poupança', type: AccountType.investment),
    Account(id: 'a5', name: 'Trabalho', type: AccountType.asset),
    Account(id: 'a6', name: 'Empréstimo', type: AccountType.loan),
    Account(id: 'a7', name: 'Casa', type: AccountType.loss),
    Account(id: 'a8', name: 'Mercado', type: AccountType.loss),
    Account(id: 'a9', name: 'Carro', type: AccountType.loss),
    Account(id: 'a10', name: 'Juros', type: AccountType.loan),
    Account(id: 'a11', name: 'Saúde', type: AccountType.loss),
    Account(id: 'a12', name: 'Diversão', type: AccountType.loss),
    Account(id: 'a13', name: 'Presentes', type: AccountType.loss),
  ];

  static final DateTime _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  double _heightAcounts = (16.0 * _accounts.where((ac) => ac.type == AccountType.movement).length);

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate, Account inputAccount, Account outputAccount,) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate ?? _today,
      input: inputAccount,
      output: outputAccount,
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
            Divider(),
            Container(
              height: _heightAcounts,
              //color: Colors.amber,
              child: Column(
                children: _accounts
                    .where((ac) => ac.type == AccountType.movement)
                    .map((account) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(' ${account.name}'),
                            Text(
                                'R\$ ${account.getBalanceByDate(_today).toString()} '),
                          ],
                        ))
                    .toList(),
              ),
            ),
            Divider(),
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
