import 'package:path/path.dart';
import 'package:qr_scanner/models/generate_history_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;

  String _generateTable = "generate";
  String _columnID = "id";
  String _columnType = "type";
  String _columnText = "text";
  String _columnPhoto = "photo";

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String dbPath = join(await getDatabasesPath(), "generate.db");
    var generateDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return generateDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table $_generateTable($_columnID integer primary key,$_columnType text,$_columnText text,$_columnPhoto blob)");
  }

  Future<List<GenerateHistoryModel>> getGenereteHistory() async {
    Database db = await this.database;
    var result = await db.query("$_generateTable");
    return List.generate(result.length, (i) {
      return GenerateHistoryModel.fromMap(result[i]);
    });
  }

  Future<int> insert(GenerateHistoryModel historyModel) async {
    Database db = await this.database;
    var result = await db.insert("$_generateTable", historyModel.toMap());

    return await result;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete("delete from $_generateTable where id=$id");
    return result;
  }

  Future<int> query() {
    return Future.value(1);
  }
}
