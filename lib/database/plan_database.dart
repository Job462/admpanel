import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/plan_model.dart';

class PlanDatabase {
  final DatabaseHelper _dbplan = DatabaseHelper();

  Future<List<Plan>> getPlan() async {
    Database db = await _dbplan.database;
    var result = await db.query('plan');
    return result.map((e) => Plan.fromMap(e)).toList();
  }

  Future<int> insertPlan(Plan plan) async {
    Database db = await _dbplan.database;
    return await db.insert('plan', plan.toMap());
  }

  Future<void> updatePlan(Plan plan) async {
    Database db = await _dbplan.database;
    await db.update(
      'plan',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<void> deletePlan(int id) async {
    Database db = await _dbplan.database;
    await db.delete(
      'plan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
