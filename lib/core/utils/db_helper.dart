import 'package:path/path.dart';
import 'package:qr_scanner/models/generate_history_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  final String _generateTable = 'generate';
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
        'Create table $_generateTable($_columnText text primary key,$_columnType text,$_columnPhoto blob)');
  }

  Future<List<GenerateHistoryModel>> getGenereteHistory() async {
    var db = await database;
    var result = await db!.query('$_generateTable');
    return List.generate(result.length, (i) {
      return GenerateHistoryModel.fromMap(result[i]);
    });
  }

  Future<int> insert(GenerateHistoryModel historyModel) async {
    var db = await database;
    var result = await db!.insert('$_generateTable', historyModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    var result =
        await db!.rawDelete('delete from $_generateTable where id=$id');
    return result;
  }
}
