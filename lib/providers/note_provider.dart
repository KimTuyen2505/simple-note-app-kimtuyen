import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Note> _items = [];
  String _search = '';
  List<Note> get notes {
    var list = _items;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q))
          .toList();
    }
    list.sort((a, b) {
      if (a.pinned != b.pinned) return b.pinned ? 1 : -1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return list;
  }

  Future<void> load() async {
    _items = await _db.getAll();
    notifyListeners();
  }

  Future<void> add(Note n) async {
    await _db.insert(n);
    await load();
  }

  Future<void> edit(Note n) async {
    await _db.update(n);
    await load();
  }

  Future<void> remove(int id) async {
    await _db.delete(id);
    await load();
  }

  void setSearch(String s) {
    _search = s;
    notifyListeners();
  }
}
