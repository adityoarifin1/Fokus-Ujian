import '../database/db_helper.dart';
import '../models/pelanggaran.dart';

class PelanggaranRepository {
  Future<int> logViolation(Pelanggaran p) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('pelanggaran', p.toMap());
  }

  Future<List<Pelanggaran>> getPelanggaranPeserta(int idPeserta) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'pelanggaran',
      where: 'id_peserta = ?',
      whereArgs: [idPeserta],
    );
    return maps.map((e) => Pelanggaran.fromMap(e)).toList();
  }
}
