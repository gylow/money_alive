import 'package:decimal/decimal.dart';

import './models/account.dart';
import './models/enum_types.dart';
import './models/transaction.dart';

final DateTime _today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

final List<Account> accounts = [
  //Start balance
  Account('a00', 'Saldo Inicial', AccountType.initialBalance),
  //Movement
  Account('a01', 'Dinheiro', AccountType.movement),
  Account('a02', 'C.Corrente BB', AccountType.movement),
  Account('a03', 'C.Corrente Nubank', AccountType.movement),
  Account('a04', 'C.Corrente Easy', AccountType.movement),
  //Investment
  Account('a05', 'Poupança Nubank', AccountType.investment),
  Account('a06', 'Invest. Easy', AccountType.investment),
  //Loan
  Account('a07', 'Empréstimo', AccountType.loan),
  Account('a08', 'Juros', AccountType.loan),
  //Credit
  Account('a09', 'C.Créd. Saraiva', AccountType.credit),
  Account('a10', 'C.Créd. Nubank', AccountType.credit),
  Account('a11', 'C.Créd. Submarino', AccountType.credit),
  Account('a12', 'C.Créd. Americanas', AccountType.credit),
  //Asset
  Account('a13', 'Trabalho', AccountType.asset),
  Account('a14', 'Rendimento', AccountType.asset),
  Account('a15', 'Doações', AccountType.asset),
  //Loss
  Account('a16', 'Atividade Física', AccountType.loss),
  Account('a17', 'Casa', AccountType.loss),
  Account('a18', 'Carro', AccountType.loss),
  Account('a19', 'Luz', AccountType.loss),
  Account('a20', 'Mercado', AccountType.loss),
  Account('a21', 'Telefonia', AccountType.loss),
  Account('a22', 'Educação', AccountType.loss),
  Account('a23', 'Alimentação', AccountType.loss),
  Account('a24', 'Diversão', AccountType.loss),
  Account('a25', 'Doação', AccountType.loss),
  Account('a26', 'Itens Pessoais', AccountType.loss),
  Account('a27', 'Impostos', AccountType.loss),
  Account('a28', 'Presentes', AccountType.loss),
  Account('a29', 'Saúde', AccountType.loss),
  Account('a30', 'Serviços gerais', AccountType.loss),
  Account('a31', 'Transporte', AccountType.loss),
  Account('a32', 'Vestuário', AccountType.loss),
];

final List<Transaction> userTransactions = [
  Transaction(
    DateTime.now().toString(),
    "Saldo inicial",
    Decimal.parse("1.45"),
    _today.subtract(new Duration(days: 7)),
    accounts[4],
    accounts[0],
  ),
  Transaction(
    DateTime.now().toString(),
    "Saldo inicial",
    Decimal.parse("100"),
    _today.subtract(new Duration(days: 7)),
    accounts[1],
    accounts[0],
  ),
  Transaction(
    DateTime.now().toString(),
    "Saldo inicial",
    Decimal.parse("200"),
    _today.subtract(new Duration(days: 7)),
    accounts[2],
    accounts[0],
  ),
  Transaction(
    DateTime.now().toString(),
    "Saldo inicial",
    Decimal.parse("300"),
    _today.subtract(new Duration(days: 7)),
    accounts[3],
    accounts[0],
  ),
  Transaction(
    DateTime.now().toString(),
    "Bom Preço",
    Decimal.parse("67.32"),
    _today,
    accounts[20],
    accounts[1],
  ),
  Transaction(
    DateTime.now().toString(),
    "Lavagem Carro",
    Decimal.parse("30.00"),
    _today.subtract(new Duration(days: 1)),
    accounts[18],
    accounts[3],
  ),
  Transaction(
    DateTime.now().toString(),
    "Bolo",
    Decimal.parse("16.00"),
    _today.subtract(new Duration(days: 2)),
    accounts[23],
    accounts[3],
  ),
  Transaction(
    DateTime.now().toString(),
    "Corte Cabelo",
    Decimal.parse("15"),
    _today.subtract(new Duration(days: 3)),
    accounts[32],
    accounts[1],
  ),
  Transaction(
    DateTime.now().toString(),
    "Presente",
    Decimal.parse("97.3"),
    _today.subtract(new Duration(days: 4)),
    accounts[28],
    accounts[3],
  ),
  Transaction(
    DateTime.now().toString(),
    "Remédio",
    Decimal.parse("27.32"),
    _today.subtract(new Duration(days: 5)),
    accounts[29],
    accounts[3],
  ),
  Transaction(
    DateTime.now().toString(),
    "IPTU",
    Decimal.parse("81.02"),
    _today.subtract(new Duration(days: 6)),
    accounts[17],
    accounts[2],
  ),
];
