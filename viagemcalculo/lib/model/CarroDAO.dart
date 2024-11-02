import 'package:sqflite/sqflite.dart';
import 'package:viagemcalculo/DatabaseHelper.dart';
import 'package:viagemcalculo/model/Carro.dart';

class CarroDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertCarro(Carro carro) async {
    final db = await _dbHelper.database;
    await db.insert('carro', carro.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCarro(Carro carro) async {
    final db = await _dbHelper.database;
    await db
        .update('carro', carro.toMap(), where: 'id = ?', whereArgs: [carro.id]);
  }

  Future<void> deleteCarro(int index) async {
    final db = await _dbHelper.database;
    await db.delete('carro', where: 'id = ?', whereArgs: [index]);
  }

  Future<List<Carro>> selectCarros() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> tipoJSON = await db.query('carro');
    return List.generate(tipoJSON.length, (i) {
      return Carro.fromMap(tipoJSON[i]);
    });
  }
}
