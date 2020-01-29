import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:money_alive/models/account.dart';

class Transaction {
  final String id;
  final String _title;
  final Decimal _amount;
  final DateTime _date;
  final Account _input;
  final Account _output;
  final _negative = Decimal.fromInt(-1);

  Transaction(
    this.id,
    this._title,
    this._amount,
    this._date,
    this._input,
    this._output,
  ) {
    _input.addEntry(_amount, _date);
    _output.addEntry((_amount*_negative), _date);
  }

  void delete(){
    _input.addEntry(_amount*_negative, _date);
    _output.addEntry(_amount, _date);
  }

  String getAmountFormated() => _amount.toStringAsFixed(2);

  Decimal getAmount() => _amount;

  String getTitle() => _title;

  DateTime getDate() => _date;

  String getDateFormated() => DateFormat('dd/MM/yyyy').format(_date);



}
