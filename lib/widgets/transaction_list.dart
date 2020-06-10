import 'package:flutter/material.dart';

import 'package:money_alive/models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover),
                    height: constraints.maxHeight * 0.6,
                  ),
                ],
              );
            },
          )
        : ListView( children: transactions.map((tx) => TransactionItem(
                  key: ValueKey(tx.id),
                  transaction: tx,
                  deleteTx: deleteTx)).toList() ,
            padding: EdgeInsets.all(0),            
          );
  }
}
