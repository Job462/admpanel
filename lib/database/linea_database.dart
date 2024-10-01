import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/linea_model.dart';

class LineaDatabase {
  final DatabaseHelper _dblinea = DatabaseHelper();

  Future<List<Linea>> getLinea() async {
    Database db = await _dblinea.database;
    var result = await db.query('linea');
    return result.map((e) => Linea.fromMap(e)).toList();
  }

  Future<int> insertLinea(Linea linea) async {
    Database db = await _dblinea.database;
    return await db.insert('linea', linea.toMap());
  }

  Future<void> updateLinea(Linea linea) async{
    Database db = await _dblinea.database;
    await db.update(
      'linea', 
      linea.toMap(),
      where: 'id = ?',
      whereArgs: [linea.id],
    );
  }

  Future<void> deleteLinea(int id) async{
    Database db = await _dblinea.database;
     await db.delete(
      'linea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
