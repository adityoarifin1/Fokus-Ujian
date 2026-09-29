import '../database/db_helper.dart';
import '../models/soal.dart';

class SoalRepository {
  Future<int> insertSoal(Soal soal) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('soal', soal.toMap());
  }

  Future<List<Soal>> getSoalByUjian(int idUjian) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'soal',
      where: 'id_ujian = ?',
      whereArgs: [idUjian],
    );
    return maps.map((e) => Soal.fromMap(e)).toList();
  }

  Future<int> updateSoal(Soal soal) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'soal',
      soal.toMap(),
      where: 'id_soal = ?',
      whereArgs: [soal.idSoal],
    );
  }

  Future<int> deleteSoal(int idSoal) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'soal',
      where: 'id_soal = ?',
      whereArgs: [idSoal],
    );
  }
}
