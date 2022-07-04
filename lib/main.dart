import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import '../db/DatabaseHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.orangeAccent,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
            ),
            button: TextStyle(color:  Colors.white),
          ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
              ),
          ),
      )
        ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Transaction> _userTransactions;

  Future<List<Transaction>> readTransactions() async {
    _userTransactions = await DatabaseHelper.instance.retrieveTransactions();
    return _userTransactions;
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      try {
        DatabaseHelper.instance.insertTransaction(newTx);
        _userTransactions.add(newTx);
      } catch (e) {
        // Display error message here
      }
    });
  }

  void _startAddNewTransacion(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) {
        return GestureDetector(
          onTap: () {},
            child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
    },);
  }

  void _deleteTransaction(String id) {
    setState(() {
      try {
        DatabaseHelper.instance.deleteTransaction(id);
        _userTransactions.removeWhere((tx) => tx.id == id);
      } catch (e) {
        // Display error message here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses',),
        actions: <Widget> [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransacion(context),
            ),
        ],
      ),
      body: FutureBuilder<List<Transaction>> (
        future: readTransactions(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(child:
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Chart(_recentTransactions),
                  TransactionList(_userTransactions, _deleteTransaction)
                ],
              ),
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon (Icons.add),
        onPressed: () => _startAddNewTransacion(context),
      ),
    );
  }
}















