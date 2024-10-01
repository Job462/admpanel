import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/zona_model.dart';

class ZonaDatabase {
  final DatabaseHelper _dbzona = DatabaseHelper();

  Future<List<Zona>> getZona() async {
    Database db = await _dbzona.database;
    var result = await db.query('zona');
    return result.map((e) => Zona.fromMap(e)).toList();
  }

  Future<int> insertZona(Zona zona) async {
    Database db = await _dbzona.database;
    return await db.insert('zona', zona.toMap());
  }

  Future<void> updateZona(Zona zona) async {
    Database db = await _dbzona.database;
    await db.update(
      'zona',
      zona.toMap(),
      where: 'id = ?',
      whereArgs: [zona.id],
    );
  }

  Future<void> deleteZona(int id) async {
    Database db = await _dbzona.database;
    await db.delete(
      'zona',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
