import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final enteredAmount = double.parse(_amountControler.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      print('vazio ou valor negativo');
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
      widget.accountList[_inputAccount.selectedItem],
      widget.accountList[_outputAccount.selectedItem],
    );

    Navigator.of(context).pop();
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 50.0,
                      maxWidth: (MediaQuery.of(context).size.width / 2) - 26.0,
                    ),
                    child: ListWheelScrollView(
                      itemExtent: Theme.of(context).textTheme.display2.fontSize,
                      controller: _outputAccount,
                      children: widget.accountList
                          .map((acc) => Text(acc.name))
                          .toList(),
                    ),
                  ),
                  Text(' >> '),
                  new ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 50.0,
                      maxWidth: (MediaQuery.of(context).size.width / 2) - 26.0,
                    ),
                    child: ListWheelScrollView(
                      itemExtent: Theme.of(context).textTheme.display2.fontSize,
                      controller: _inputAccount,
                      children: widget.accountList.reversed
                          .map((acc) => Text(acc.name))
                          .toList(),
                    ),
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
