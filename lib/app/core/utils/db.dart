import 'package:sqflite/sqflite.dart';

import '../../features/data/data_model.dart';

class DB {
  DB._internal();
  static DB i;

  factory DB() {
    if (i == null) i = DB._internal();
    return i;
  }

  final String dataTable = 'Personal';
  final String id = '_id';
  final String name = 'name';
  final String surname = 'surname';
  final String createdAt = 'createdAt';
  final String age = 'age';

  Future<Database> get _db async => await initializeDatabase();

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + 'mydb.db';
    var result = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $dataTable (
        $id integer primary key autoincrement,
        $name text not null,
        $surname text not null,
        $age integer,
        $createdAt text not null)
        ''');
      },
    );
    return result;
  }

  Future<bool> insertData(DataModel data) async {
    var db = await this._db;
    try {
      db.insert(dataTable, data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<DataModel>> getData() async* {
    var db = await this._db;
    final result = await db.query(dataTable);
    yield List.from(result.map((e) => DataModel.fromJson(e)));
  }

  Future<int> deleteData() async {
    var db = await this._db;
    final result = await db.delete(dataTable);
    return result;
  }
}
