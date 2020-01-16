import 'package:flutter/foundation.dart';

class DailyBalance {
  final String id;
  final DateTime date;
  double balance = 0;

  DailyBalance({
    @required this.id,
    @required this.date,
    @required this.balance,
  });


  void updateBalance(double amount){
    this.balance += amount;
  }
}
