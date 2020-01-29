import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              child: SizedBox(
                child: Text('R\$${spendingAmount.toStringAsFixed(0)}'),
              ),
              height: constraints.maxHeight * 0.15,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.02,
            ),
            Container(
              height: constraints.maxHeight * 0.69,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  FractionallySizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    heightFactor: spendingPctOfTotal,
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.02,
            ),
            Container(
              height: constraints.maxHeight * 0.12,
              child: FittedBox(
                child: Text('$label'),
              ),
            ),
          ],
        );
      },
    );
  }
}
