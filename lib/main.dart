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
        errorColor: Colors.red,
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
  final List<Transaction> _userTransactions = [
    Transaction(
      DateTime.now().toString(),
      "Bom Preço",
      Decimal.parse("67.32"),
      _today,
      _accounts[20],
      _accounts[1],
    ),
    Transaction(
      DateTime.now().toString(),
      "Lavagem Carro",
      Decimal.parse("30.00"),
      _today.subtract(new Duration(days: 1)),
      _accounts[18],
      _accounts[3],
    ),
    Transaction(
      DateTime.now().toString(),
      "Bolo",
      Decimal.parse("16.00"),
      _today.subtract(new Duration(days: 2)),
      _accounts[23],
      _accounts[3],
    ),
    Transaction(
      DateTime.now().toString(),
      "Corte Cabelo",
      Decimal.parse("15"),
      _today.subtract(new Duration(days: 3)),
      _accounts[32],
      _accounts[1],
    ),
    Transaction(
      DateTime.now().toString(),
      "Presente",
      Decimal.parse("97.3"),
      _today.subtract(new Duration(days: 4)),
      _accounts[28],
      _accounts[3],
    ),Transaction(
      DateTime.now().toString(),
      "Remédio",
      Decimal.parse("27.32"),
      _today.subtract(new Duration(days: 5)),
      _accounts[29],
      _accounts[3],
    ),
    Transaction(
      DateTime.now().toString(),
      "IPTU",
      Decimal.parse("81.02"),
      _today.subtract(new Duration(days: 6)),
      _accounts[17],
      _accounts[2],
    ),

    Transaction(
      DateTime.now().toString(),
      "Saldo inicial",
      Decimal.parse("100"),
      _today.subtract(new Duration(days: 7)),
      _accounts[1],
      _accounts[0],
    ),
    Transaction(
      DateTime.now().toString(),
      "Saldo inicial",
      Decimal.parse("200"),
      _today.subtract(new Duration(days: 7)),
      _accounts[2],
      _accounts[0],
    ),
    Transaction(
      DateTime.now().toString(),
      "Saldo inicial",
      Decimal.parse("300"),
      _today.subtract(new Duration(days: 7)),
      _accounts[3],
      _accounts[0],
    ),
    Transaction(
      DateTime.now().toString(),
      "Saldo inicial",
      Decimal.parse("1.45"),
      _today.subtract(new Duration(days: 7)),
      _accounts[4],
      _accounts[0],
    ),
  ];

  static final List<Account> _accounts = [
    //Start balance
    Account('a00', 'Saldo Inicial', AccountType.initialBalance),
    //Movement
    Account('a01', 'Dinheiro', AccountType.movement),
    Account('a02', 'C.Corrente BB', AccountType.movement),
    Account('a03', 'C.Corrente Nubank', AccountType.movement),
    Account('a04', 'C.Corrente Easy', AccountType.movement),
    //Investment
    Account('a05', 'Poupança Nubank', AccountType.investment),
    Account('a06', 'Invest. Easy', AccountType.investment),
    //Loan
    Account('a07', 'Empréstimo', AccountType.loan),
    Account('a08', 'Juros', AccountType.loan),
    //Credit
    Account('a09', 'C.Créd. Saraiva', AccountType.credit),
    Account('a10', 'C.Créd. Nubank', AccountType.credit),
    Account('a11', 'C.Créd. Submarino', AccountType.credit),
    Account('a12', 'C.Créd. Americanas', AccountType.credit),
    //Asset
    Account('a13', 'Trabalho', AccountType.asset),
    Account('a14', 'Rendimento', AccountType.asset),
    Account('a15', 'Doações', AccountType.asset),
    //Loss
    Account('a16', 'Atividade Física', AccountType.loss),
    Account('a17', 'Casa', AccountType.loss),
    Account('a18', 'Carro', AccountType.loss),
    Account('a19', 'Luz', AccountType.loss),
    Account('a20', 'Mercado', AccountType.loss),
    Account('a21', 'Telefonia', AccountType.loss),
    Account('a22', 'Educação', AccountType.loss),
    Account('a23', 'Alimentação', AccountType.loss),
    Account('a24', 'Diversão', AccountType.loss),
    Account('a25', 'Doação', AccountType.loss),
    Account('a26', 'Itens Pessoais', AccountType.loss),
    Account('a27', 'Impostos', AccountType.loss),
    Account('a28', 'Presentes', AccountType.loss),
    Account('a29', 'Saúde', AccountType.loss),
    Account('a30', 'Serviços gerais', AccountType.loss),
    Account('a31', 'Transporte', AccountType.loss),
    Account('a32', 'Vestuário', AccountType.loss),
  ];

  static final DateTime _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  double _heightAcounts =
      (20.0 * _accounts.where((ac) => ac.isType(AccountType.movement)).length) +
          6;

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
                              account.getName(),
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              account.getBalanceByDate(_today),
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
