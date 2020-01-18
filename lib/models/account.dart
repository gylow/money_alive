import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

//import './dailyBalance.dart';

class Account {
  final String id;
  final String name;
  var balanceMap = new SplayTreeMap<DateTime, double>();
  //List<DailyBalance> balanceList = [];

  Account({
    @required this.id,
    @required this.name,
  });

  void addEntryIntoAccount(double amount, DateTime date) {
    //DailyBalance balance = getDailyBalance(date);

    var balanceBefore = balanceMap[balanceMap?.lastKeyBefore(date)] ?? 0.0;
    balanceMap.putIfAbsent(date, () => balanceBefore);

    updateDailyBalances(date, amount);

    //print(balanceMap);

    balanceMap.forEach((date, balance) => print(this.name +
        ' ' +
        DateFormat('dd/MM/yyyy').format(date).toString() +
        ' ' +
        balance.toString()));
  }

  /*DailyBalance getDailyBalance(DateTime dateToSearch) {
    var beforeDailyBalance;
    for (final balance in balanceList) {
      switch (balance.date.compareTo(dateToSearch)) {
        case 0:
          return balance;
        case -1:
          if (beforeDailyBalance == null ||
              balance.date.compareTo(beforeDailyBalance.date) > 0) {
            beforeDailyBalance = balance;
          }
          break;
        default:
          break;
      }
    }

    return beforeDailyBalance == null
        ? newDailyBalance(dateToSearch, 0)
        : newDailyBalance(dateToSearch, beforeDailyBalance.balance);
  }*/

  /*DailyBalance newDailyBalance(DateTime date, double balance) {
    //TODO add in a ordered list

    var newDailyBalance = DailyBalance(
      id: DateTime.now().toString(),
      date: date,
      balance: balance,
    );
    balanceList.add(newDailyBalance);
    return newDailyBalance;
  }*/

  void updateDailyBalances(DateTime initialDate, double amount) {
    for (var key = initialDate;
        key != null;
        key = balanceMap.firstKeyAfter(key)) {
      balanceMap[key] += amount;
    }

    /*balanceList.forEach((day) {
      if (day.date.compareTo(initialDate) >= 0) {
        day.updateBalance(amount);
      }
    });*/
  }

  /*double getBalanceByLastDay() =>
      balanceList.isNotEmpty ? balanceList.last.balance : 0.0;*/

  double getBalanceByDate(DateTime date) => balanceMap[date] ?? 0.0;
}
