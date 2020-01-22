import 'package:flutter/foundation.dart';
import 'package:money_alive/models/account.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Account input;
  final Account output;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.input,
    @required this.output,
  }) {
    input.addEntry(amount, date);
    output.addEntry(amount*-1, date);
  }

  void delete(){
    input.addEntry(amount*-1, date);
    output.addEntry(amount, date);
  }

}
