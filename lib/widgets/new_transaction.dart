import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/account.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  final List<Account> accountList;

  NewTransaction(this.addTx, this.accountList);

  @override
  State<StatefulWidget> createState() => _NewTransactionState();
}

class CurrencyInputFormatter extends TextInputFormatter {
  final String myLocate;

  CurrencyInputFormatter(this.myLocate);

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.simpleCurrency(locale: myLocate);
    String newText = formatter.format(value / (100));

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleControler = TextEditingController();
  final _amountControler = TextEditingController();
  final _inputAccount = FixedExtentScrollController();
  final _outputAccount = FixedExtentScrollController();
  final _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDate;

  void _submitData() {
    if (_amountControler.text.isEmpty) {
      return;
    }

    print(_titleControler.text);
    print(_amountControler.text);

    final enteredTitle = _titleControler.text;
    var onlyNumbers = RegExp(r"([^0-9])");

    final enteredAmount = Decimal.tryParse(
          _amountControler.text.replaceAll(onlyNumbers, ''),
        ) /
        Decimal.fromInt(100);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= Decimal.zero) {
      print('vazio ou valor negativo');
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
      widget.accountList.reversed.elementAt(_inputAccount.selectedItem),
      widget.accountList[_outputAccount.selectedItem],
    );

    Navigator.of(context).pop();
  }

  Widget _scrollAccountsView(
      FixedExtentScrollController controller, bool reversed) {
    return Platform.isIOS
        ? //TODO implements the CupertinoPicker(
        ListWheelScrollView(
            magnification: 1.1,
            useMagnifier: true,
            itemExtent: Theme.of(context).textTheme.bodyText1.fontSize,
            controller: controller,
            children:
                (reversed ? widget.accountList.reversed : widget.accountList)
                    .map((account) => Text(account.getName()))
                    .toList(),
          )
        : ListWheelScrollView(
            magnification: 1.1,
            useMagnifier: true,
            itemExtent: Theme.of(context).textTheme.bodyText1.fontSize,
            controller: controller,
            children:
                (reversed ? widget.accountList.reversed : widget.accountList)
                    .map((account) => Text(account.getName()))
                    .toList(),
          );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _today,
      firstDate: DateTime(_today.year - 1),
      lastDate: DateTime(_today.year + 2),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 10,
              right: 10,
              top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleControler,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountControler,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter('pt_BR'),
                ],
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(height: 30),
              Row(
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 50.0,
                        maxWidth: (MediaQuery.of(context).size.width * 0.4),
                      ),
                      child: _scrollAccountsView(_outputAccount, false)),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('  ==>  '),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 50.0,
                      maxWidth: (MediaQuery.of(context).size.width * 0.4),
                    ),
                    child: _scrollAccountsView(_inputAccount, true),
                  ),
                ],
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text('Date: '),
                          AdaptiveFlatButton(
                              '${DateFormat('dd/MM/yyyy').format(_selectedDate == null ? _today : _selectedDate)}',
                              _presentDatePicker),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: _submitData,
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
