import 'package:sqflite/sqflite.dart';
import 'package:viagemcalculo/DatabaseHelper.dart';

class CalculoDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertCalculo(double custo) async {
    final db = await _dbHelper.database;
    await db.insert('calculo', {'custo': custo},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<double>> getCalculos() async {
  final db = await _dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('calculo');

  return List.generate(maps.length, (i) {
    return maps[i]['custo'] as double;
  });
}

}