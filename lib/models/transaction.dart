import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './enum_types.dart';
import './account.dart';

class Transaction {
  final String id;
  final String _title;
  final Decimal _amount;
  final DateTime _date;
  final Account _to;
  final Account _from;
  TransactionType type;
  final Map<TransactionType, Color> _transactionColor = {
    TransactionType.start: Colors.grey[300],
    TransactionType.entry: Colors.green[300],
    TransactionType.out: Colors.red[300],
    TransactionType.loan: Colors.orange[300],
    TransactionType.transfer: Colors.yellow[300],
  };

  Transaction(
    this.id,
    this._title,
    this._amount,
    this._date,
    this._to,
    this._from,
  ) {
    _setType();
    _to.addEntry(_amount, _date);
    _from.addEntry(-(_amount), _date);
  }

  void _setType() {
    if (_from.getType() == AccountType.loan ||
        _to.getType() == AccountType.loan) {
      type = TransactionType.loan;
    } else if (_to.getType() == AccountType.loss) {
      type = TransactionType.out;
    } else if (_from.getType() == AccountType.initialBalance) {
      type = TransactionType.start;
    } else if (_from.getType() == AccountType.asset) {
      type = TransactionType.entry;
    } else {
      type = TransactionType.transfer;
    }
  }

  void delete() {
    _to.addEntry(-(_amount), _date);
    _from.addEntry(_amount, _date);
  }

  String getAmountFormated() => _amount.toStringAsFixed(2);

  Decimal getAmount() => _amount;

  String getTitle() => _title;

  DateTime getDate() => _date;

  String getDateFormated() => DateFormat('dd/MM/yyyy').format(_date);

  String getToAccountName() => _to.getName();

  String getFromAccountName() => _from.getName();

  Color getColor() => _transactionColor[type];
}
