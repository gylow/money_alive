import 'package:flutter/material.dart';

import '../models/enum_types.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  Function delete() {
    return transaction.type != TransactionType.start
        ? deleteTx(transaction.id)
        : Null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          foregroundColor: Colors.black,
          backgroundColor: transaction.getColor(),
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
            "${transaction.getDateFormated()}\n${transaction.getFromAccountName()} >> ${transaction.getToAccountName()}"),
        trailing: MediaQuery.of(context).size.width > 500
            ? FlatButton.icon(
                onPressed: delete,
                icon: Icon(Icons.delete),
                label: Text('delete'),
                textColor: transaction.type == TransactionType.start
                    ? transaction.getColor()
                    : Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: transaction.type == TransactionType.start
                    ? transaction.getColor()
                    : Theme.of(context).errorColor,
                onPressed: delete,
              ),
      ),
    );
  }
}
