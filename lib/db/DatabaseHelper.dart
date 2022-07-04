import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as Trans;

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'transaction_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE " + Trans.Transaction.TABLENAME + "(id TEXT, title TEXT, amount REAL, date TEXT)");
        });
  }

  insertTransaction(Trans.Transaction transaction) async {
    final db = await database;
    var res = await db.insert(Trans.Transaction.TABLENAME, transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  deleteTransaction(String id) async {
    var db = await database;
    db.delete(Trans.Transaction.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Trans.Transaction>> retrieveTransactions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(Trans.Transaction.TABLENAME);

    return List.generate(maps.length, (i) {
      return Trans.Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date'])
      );
    });
  }
}