import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fokusujian.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onConfigure: _onConfigure,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Untuk prototyping, drop semua tabel dan buat ulang saat upgrade versi
    await db.execute('DROP TABLE IF EXISTS pelanggaran');
    await db.execute('DROP TABLE IF EXISTS jawaban');
    await db.execute('DROP TABLE IF EXISTS peserta');
    await db.execute('DROP TABLE IF EXISTS soal');
    await db.execute('DROP TABLE IF EXISTS ujian');
    await db.execute('DROP TABLE IF EXISTS admin');
    await _createDB(db, newVersion);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE admin (
        id_admin $idType,
        username $textType,
        password_hash $textType,
        role $textType
      )
    ''');

    // Akun default admin
    await db.insert('admin', {
      'username': 'admin',
      'password_hash': 'admin123',
      'role': 'admin'
    });

    // Akun default guru
    await db.insert('admin', {
      'username': 'guru',
      'password_hash': 'guru123',
      'role': 'guru'
    });

    await db.execute('''
      CREATE TABLE ujian (
        id_ujian $idType,
        nama_ujian $textType,
        mata_pelajaran $textType,
        durasi $intType,
        tanggal $textType,
        status $textType,
        kode_ujian $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE soal (
        id_soal $idType,
        id_ujian $intType,
        teks_soal $textType,
        opsi_a $textType,
        opsi_b $textType,
        opsi_c $textType,
        opsi_d $textType,
        jawaban_benar $textType,
        FOREIGN KEY (id_ujian) REFERENCES ujian (id_ujian) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE peserta (
        id_peserta $idType,
        id_ujian $intType,
        nama $textType,
        kelas $textType,
        identitas $textType,
        FOREIGN KEY (id_ujian) REFERENCES ujian (id_ujian) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE jawaban (
        id_jawaban $idType,
        id_peserta $intType,
        id_soal $intType,
        jawaban $textType,
        waktu_jawab $textType,
        FOREIGN KEY (id_peserta) REFERENCES peserta (id_peserta) ON DELETE CASCADE,
        FOREIGN KEY (id_soal) REFERENCES soal (id_soal) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE pelanggaran (
        id_pelanggaran $idType,
        id_peserta $intType,
        waktu $textType,
        posisi_x $realType,
        posisi_y $realType,
        jenis_pelanggaran $textType,
        FOREIGN KEY (id_peserta) REFERENCES peserta (id_peserta) ON DELETE CASCADE
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
