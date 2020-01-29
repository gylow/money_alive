import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get totalSpending {
    return groupedTransctionsValues.fold(
      0.0,
      (sum, item) {
        return sum += item['amount'];
      },
    );
  }

  List<Map<String, Object>> get groupedTransctionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var tx in recentTransactions) {
        var date = tx.getDate();
        if (date.day == weekDay.day &&
            date.month == weekDay.month &&
            date.year == weekDay.year) {
          totalSum += tx.getAmount().toDouble();
        }
      }

      //print(DateFormat.E().format(weekDay));
      //print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransctionsValues);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.all(constraints.maxHeight * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransctionsValues.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      data['day'],
                      data['amount'],
                      totalSpending == 0.0
                          ? 0.0
                          : (data['amount'] as double) / totalSpending),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
