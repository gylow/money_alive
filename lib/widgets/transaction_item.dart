import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: FittedBox(
              child: Text(transaction.getAmountFormated()),
            ),
          ),
        ),
        title: Text(
          transaction.getTitle(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
            "${transaction.getDateFormated()}\n${transaction.getOutput()} >> ${transaction.getInput()}"),

        trailing: MediaQuery.of(context).size.width > 500
            ? FlatButton.icon(
                onPressed: () => deleteTx(transaction.id),
                icon: Icon(Icons.delete),
                label: Text('delete'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTx(transaction.id),
              ), //trailing: ,
      ),
    );
  }
}
