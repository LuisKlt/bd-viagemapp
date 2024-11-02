import 'package:sqflite/sqflite.dart';
import 'package:viagemcalculo/DatabaseHelper.dart';
import 'package:viagemcalculo/model/Destino.dart';

class DestinoDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertDestino(Destino destino) async {
    final db = await _dbHelper.database;
    await db.insert('destino', destino.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDestino(Destino destino) async {
    final db = await _dbHelper.database;
    await db.update('destino', destino.toMap(),
        where: 'id = ?', whereArgs: [destino.id]);
  }

  Future<void> deleteDestino(int index) async {
    final db = await _dbHelper.database;
    await db.delete('destino', where: 'id = ?', whereArgs: [index]);
  }

  Future<List<Destino>> selectDestinos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> tipoJSON = await db.query('destino');
    return List.generate(tipoJSON.length, (i) {
      return Destino.fromMap(tipoJSON[i]);
    });
  }
}
