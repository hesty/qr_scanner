import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../model/scan_history_model.dart';

class ScanQrHistoryDbService {
  static Database? _database;

  final String _scanTable = 'scan';
  final String _columnID = 'id';
  final String _columnText = 'text';
  final String _columnPhoto = 'photo';

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dbPath = join(await getDatabasesPath(), 'database2.db');
    var scan =
        await openDatabase(dbPath, version: 1, onCreate: createDbForScan);

    return scan;
  }

  void createDbForScan(Database db, int version) async {
    await db.execute(
      'Create table $_scanTable($_columnID integer primary key,$_columnText text,$_columnPhoto blob)',
    );
  }

  Future<List<ScanHistoryModel>> getScanHistory() async {
    var db = await database;
    var result = await db!.query('$_scanTable');
    return List.generate(result.length, (i) {
      return ScanHistoryModel.fromMap(result[i]);
    });
  }

  Future<int> insertForScan(ScanHistoryModel historyModel) async {
    var db = await database;
    var result = await db!.insert('$_scanTable', historyModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return result;
  }

  Future<int> deleteForScan(int? id) async {
    var db = await database;
    var result = await db!.rawDelete('delete from $_scanTable where id=$id');
    return result;
  }
}
