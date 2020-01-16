import 'package:flutter/foundation.dart';
import 'package:money_alive/models/account.dart';
import 'package:money_alive/models/entryType.dart';

import './entry.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  Entry input;
  Entry output;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required Account inputAccount,
    @required Account outputAccount,
  }) {
    this.input = Entry(
      id: DateTime.now().toString(),
      account: inputAccount,
      date: date,
      amount: amount,
      signal: EntryType.positive,
    );

    this.output = Entry(
      id: DateTime.now().toString(),
      account: outputAccount,
      date: date,
      amount: amount,
      signal: EntryType.negative,
    );
  }
}
