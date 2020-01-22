import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:money_alive/models/account_type.dart';

class Account {
  final String id;
  final String name;
  final AccountType type;
  var balanceMap = new SplayTreeMap<DateTime, double>();

  Account({
    @required this.id,
    @required this.name,
    @required this.type,
  });

  void addEntry(double amount, DateTime date) {
    balanceMap.putIfAbsent(
        date, () => balanceMap[balanceMap?.lastKeyBefore(date)] ?? 0.0);
    updateDailyBalances(date, amount);

    balanceMap.forEach((date, balance) => print(this.name +
        ' ' +
        DateFormat('dd/MM/yyyy').format(date).toString() +
        ' ' +
        balance.toString()));
  }

  void updateDailyBalances(DateTime initialDate, double amount) {
    for (var key = initialDate;
        key != null;
        key = balanceMap.firstKeyAfter(key)) {
      balanceMap[key] += amount;
    }
  }

  double getBalanceByDate(DateTime date) => balanceMap[date] ?? 0.0;
}
