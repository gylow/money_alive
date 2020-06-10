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
  final Account _input;
  final Account _output;
  TransactionType type;
  final Map<TransactionType, Color> _transactionColor = {
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
    this._input,
    this._output,
  ) {
    _setType();
    _input.addEntry(_amount, _date);
    _output.addEntry(-(_amount), _date);
  }

  void _setType() {
    if (_output.getType() == AccountType.loan ||
        _input.getType() == AccountType.loan) {
      type = TransactionType.loan;
    } else if (_input.getType() == AccountType.loss) {
      type = TransactionType.out;
    } else if (_output.getType() == AccountType.asset ||
        _output.getType() == AccountType.initialBalance) {
      type = TransactionType.entry;
    } else {
      type = TransactionType.transfer;
    }
  }

  void delete() {
    _input.addEntry(-(_amount), _date);
    _output.addEntry(_amount, _date);
  }

  String getAmountFormated() => _amount.toStringAsFixed(2);

  Decimal getAmount() => _amount;

  String getTitle() => _title;

  DateTime getDate() => _date;

  String getDateFormated() => DateFormat('dd/MM/yyyy').format(_date);

  String getInput() => _input.getName();

  String getOutput() => _output.getName();

  Color getColor() => _transactionColor[type];
}
