import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../model/generate_history_model.dart';

class DatabaseHelper {
  static Database? _database;
  final String _generateTable = 'generate';
  final String _columnID = 'id';
  final String _columnType = 'type';
  final String _columnText = 'text';
  final String _columnPhoto = 'photo';

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dbPath = join(await getDatabasesPath(), 'database.db');
    var generateDb = await openDatabase(dbPath, version: 1, onCreate: createDb);

    return generateDb;
  }

  Future<void> createDb(Database db, int version) async {
    await db.execute(
        'Create table $_generateTable($_columnID integer primary key,$_columnType text,$_columnText text,$_columnPhoto blob)');
  }

  Future<List<GenerateHistoryModel>> getgeneretaHistory() async {
    var db = await database;
    var result = await db!.query('$_generateTable');
    return List.generate(result.length, (i) {
      return GenerateHistoryModel.fromMap(result[i]);
    });
  }

  Future<int> insert(GenerateHistoryModel historyModel) async {
    var db = await database;
    var result = await db!.insert('$_generateTable', historyModel.toMap());

    return result;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    var result =
        await db!.rawDelete('delete from $_generateTable where id=$id');
    return result;
  }
}
