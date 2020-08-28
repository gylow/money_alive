import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Name"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Account Name:"),
                Text("Initial Balance:"),
                Text("Initial Date:"),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("Avatars:"),
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 5,
                    children: List.generate(
                      15,
                      (index) => Container(
                        padding: const EdgeInsets.all(8),
                        child: Center(child: Text('Item $index')),
                        color: Colors.teal[100],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
