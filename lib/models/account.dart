import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import './dailyBalance.dart';

class Account {
  final String id;
  final String name;
  List<DailyBalance> balanceList = [];

  Account({
    @required this.id,
    @required this.name,
  });

  DailyBalance addEntryIntoAccount(double amount, DateTime date) {
    DailyBalance balance = getDailyBalance(date);

    updateDailyBalances(date, amount);

    balanceList.forEach((balance) => print(this.name +
        ' ' +
        DateFormat('dd/MM/yyyy').format(balance.date).toString() +
        ' ' +
        balance.balance.toString()));

    return balance;
  }

  DailyBalance getDailyBalance(DateTime dateToSearch) {
    var beforeDailyBalance;
    for (final balance in balanceList) {
      switch (DateFormat('yyyyMMdd')
          .format(balance.date)
          .compareTo(DateFormat('yyyyMMdd').format(dateToSearch))) {
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
  }

  DailyBalance newDailyBalance(DateTime date, double balance) {
    //TODO add in a ordered list

    var newDailyBalance = DailyBalance(
      id: DateTime.now().toString(),
      date: date,
      balance: balance,
    );
    balanceList.add(newDailyBalance);
    return newDailyBalance;
  }

  void updateDailyBalances(DateTime initialDate, double amount) {
    //TODO implement only in next daily balances

    balanceList.forEach((day) {
      if (DateFormat('dd/MM/yyyy').format(day.date).compareTo(DateFormat('dd/MM/yyyy').format(initialDate)) >= 0) {
        day.updateBalance(amount);
      }
    });
  }

  double getBalanceByLastDay() => balanceList.isNotEmpty ? balanceList.last.balance : 0.0 ;


}
