import '../database/db_helper.dart';
import '../models/peserta.dart';

class PesertaRepository {
  Future<int> insertPeserta(Peserta peserta) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('peserta', peserta.toMap());
  }

  Future<Peserta?> getPeserta(int idPeserta) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'peserta',
      where: 'id_peserta = ?',
      whereArgs: [idPeserta],
    );
    if (maps.isNotEmpty) {
      return Peserta.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Peserta>> getPesertaByUjian(int idUjian) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'peserta',
      where: 'id_ujian = ?',
      whereArgs: [idUjian],
    );
    return maps.map((e) => Peserta.fromMap(e)).toList();
  }
}
