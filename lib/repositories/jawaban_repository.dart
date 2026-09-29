import '../database/db_helper.dart';
import '../models/jawaban.dart';

class JawabanRepository {
  Future<void> saveAnswer(Jawaban jawaban) async {
    final db = await DatabaseHelper.instance.database;
    
    // Cek apakah jawaban sudah ada, kalau ada update, kalau belum insert
    final maps = await db.query(
      'jawaban',
      where: 'id_peserta = ? AND id_soal = ?',
      whereArgs: [jawaban.idPeserta, jawaban.idSoal],
    );

    if (maps.isNotEmpty) {
      await db.update(
        'jawaban',
        jawaban.toMap(),
        where: 'id_peserta = ? AND id_soal = ?',
        whereArgs: [jawaban.idPeserta, jawaban.idSoal],
      );
    } else {
      await db.insert('jawaban', jawaban.toMap());
    }
  }

  Future<List<Jawaban>> getJawabanPeserta(int idPeserta) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'jawaban',
      where: 'id_peserta = ?',
      whereArgs: [idPeserta],
    );
    return maps.map((e) => Jawaban.fromMap(e)).toList();
  }
}
