import 'package:sqflite/sqflite.dart' show Database, getDatabasesPath, openDatabase;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';



//1 nom prénom
//2 couleur
//3 dropbox
//4 si
//5 info




class PTSIDatabase {
  static final PTSIDatabase instance = PTSIDatabase._init();

  static Database? _database;

  PTSIDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ptsi_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY '; //AUTOINCREMENT
    const textType = 'TEXT';

    await db.execute('''
    CREATE TABLE settings (
      id $idType,
      value $textType
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> read() async {
    final Database db = await instance.database;
    return await db.query('settings');
  }

  Future getValue(int id) async {
    final Database db = await instance.database;
    return await db.query('settings', where: 'id = ?', whereArgs: [id]);
  }

  Future setValue(String value, int id) async {
    final Database db = await instance.database;
    await db.update('settings', {'value': value},
        where: 'id = ?', whereArgs: [id]);
  }

  Future updateDropboxLink(String value) async {
    final Database db = await instance.database;
    await db.update('settings', {'dropboxlink': value},
        where: 'id = ?', whereArgs: [1]);
  }

  Future update(String value, int id) async {
    final Database db = await instance.database;
    await db.update('settings', {'value': value},
        where: 'id = ?', whereArgs: [id]);
  }

  Future insert(int id, String value) async {
    final Database db = await instance.database;
    await db.insert('settings', {'id': id, 'value': value});
  }

  Future deleteAll() async {
    final Database db = await instance.database;
    await db.delete('settings');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
