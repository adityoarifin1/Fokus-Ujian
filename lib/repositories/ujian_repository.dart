import '../database/db_helper.dart';
import '../models/ujian.dart';

class UjianRepository {
  Future<int> insertUjian(Ujian ujian) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('ujian', ujian.toMap());
  }

  Future<List<Ujian>> getSemuaUjian() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('ujian', orderBy: 'id_ujian DESC');
    return maps.map((e) => Ujian.fromMap(e)).toList();
  }

  Future<int> updateUjian(Ujian ujian) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'ujian',
      ujian.toMap(),
      where: 'id_ujian = ?',
      whereArgs: [ujian.idUjian],
    );
  }

  Future<int> deleteUjian(int idUjian) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'ujian',
      where: 'id_ujian = ?',
      whereArgs: [idUjian],
    );
  }

  Future<Ujian?> getUjianByKode(String kodeUjian) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'ujian',
      where: 'kode_ujian = ?',
      whereArgs: [kodeUjian],
    );
    if (maps.isNotEmpty) {
      return Ujian.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStatusUjian(int idUjian, String status) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'ujian',
      {'status': status},
      where: 'id_ujian = ?',
      whereArgs: [idUjian],
    );
  }
}
