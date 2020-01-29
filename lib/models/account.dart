import 'dart:collection';

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:money_alive/models/account_type.dart';

import './account_type.dart';

class Account {
  final String id;
  final String _name;
  final AccountType _type;
  var balanceMap = new SplayTreeMap<DateTime, Decimal>();

  Account(
    this.id,
    this._name,
    this._type,
  );

  void addEntry(Decimal amount, DateTime date) {
    balanceMap.putIfAbsent(date,
        () => balanceMap[balanceMap?.lastKeyBefore(date)] ?? Decimal.zero);
    updateDailyBalances(date, amount);

    balanceMap.forEach((date, balance) => print(this._name +
        ' ' +
        DateFormat('dd/MM/yyyy').format(date).toString() +
        ' ' +
        balance.toString()));
  }

  void updateDailyBalances(DateTime initialDate, Decimal amount) {
    for (var key = initialDate;
        key != null;
        key = balanceMap.firstKeyAfter(key)) {
      balanceMap[key] += amount;
    }
  }

  String getBalanceByDate(DateTime date) => (balanceMap[date] ??
          balanceMap[balanceMap?.lastKeyBefore(date)] ??
          Decimal.zero)
      .toStringAsFixed(2);

  String getName() => _name;

  String getType() => _type.toString();

  bool isType(AccountType accountTest) => _type == accountTest;
}
