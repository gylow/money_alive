import 'package:flutter/foundation.dart';
import 'package:money_alive/models/account.dart';

import './dailyBalance.dart';
import './entryType.dart';

class Entry {
  final String id;
  final EntryType signal;
  DailyBalance balance;

  Entry({
    @required this.id,
    @required this.signal,
    @required DateTime date,
    @required Account account,
    @required double amount,
  }) {
    this.balance = account.addEntryIntoAccount(
      signal == EntryType.positive ? amount : amount * -1,
      date,
    );
  }
}
