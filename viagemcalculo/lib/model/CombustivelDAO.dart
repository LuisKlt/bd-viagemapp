import 'package:sqflite/sqflite.dart';
import 'package:viagemcalculo/DatabaseHelper.dart';
import 'package:viagemcalculo/model/Combustivel.dart';

class CombustivelDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertCombustivel(Combustivel combustivel) async {
    final db = await _dbHelper.database;
    await db.insert('combustivel', combustivel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCombustivel(Combustivel combustivel) async {
    final db = await _dbHelper.database;
    await db.update('combustivel', combustivel.toMap(),
        where: 'id = ?', whereArgs: [combustivel.id]);
  }

  Future<void> deleteCombustivel(int index) async {
    final db = await _dbHelper.database;
    await db.delete('combustivel', where: 'id = ?', whereArgs: [index]);
  }

  Future<List<Combustivel>> selectCombustiveis() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> tipoJSON = await db.query('combustivel');
    return List.generate(tipoJSON.length, (i) {
      return Combustivel.fromMap(tipoJSON[i]);
    });
  }
}
