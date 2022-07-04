import 'package:flutter/cupertino.dart';
// import '../db/DatabaseHelper.dart';

// this Transaction class serves as a module
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  static const String TABLENAME = "transactions";

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date});

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{
  //     DatabaseProvider.COLUMN_TITLE: title,
  //     DatabaseProvider.COLUMN_AMOUNT: amount,
  //     DatabaseProvider.COLUMN_DATE: date,
  //   };
  //
  //   if (id != null) {
  //     map[DatabaseProvider.COLUMN_ID] = id;
  //   }
  //
  //   return map;
  // }
  //
  // Transaction.fromMap(Map<String, dynamic> map) {
  //   id = map[DatabaseProvider.COLUMN_ID];
  //   title = map[DatabaseProvider.COLUMN_TITLE];
  //   amount = map[DatabaseProvider.COLUMN_AMOUNT];
  //   date = map[DatabaseProvider.COLUMN_DATE];
  // }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'amount': amount, 'date': date.toString()};
  }
}










