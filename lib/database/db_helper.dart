import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;
  DatabaseHelper._();
  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'notes.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (d, v) async {
        await d.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          tag TEXT,
          pinned INTEGER,
          locked INTEGER,
          password TEXT,
          updatedAt TEXT
        )
        ''');
      },
    );
    return _db!;
  }

  Future<List<Note>> getAll() async {
    final d = await db;
    final rows = await d.query('notes', orderBy: 'pinned DESC, updatedAt DESC');
    return rows.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> insert(Note n) async {
    final d = await db;
    return d.insert('notes', n.toMap());
  }

  Future<int> update(Note n) async {
    final d = await db;
    return d.update('notes', n.toMap(), where: 'id=?', whereArgs: [n.id]);
  }

  Future<int> delete(int id) async {
    final d = await db;
    return d.delete('notes', where: 'id=?', whereArgs: [id]);
  }
}
