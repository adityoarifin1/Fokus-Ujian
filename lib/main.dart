import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'ui/screens/start_screen.dart';
import 'ui/screens/identitas_peserta_screen.dart';
import 'ui/screens/aturan_ujian_screen.dart';
import 'ui/screens/exam_screen.dart';
import 'ui/screens/warning_screen.dart';
import 'ui/screens/hasil_ujian_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/dashboard_guru_screen.dart';
import 'ui/screens/kelola_ujian_screen.dart';
import 'ui/screens/manajemen_soal_screen.dart';
import 'ui/screens/monitoring_ujian_screen.dart';
import 'ui/screens/dashboard_admin_screen.dart';
import 'ui/screens/kelola_guru_screen.dart';
import 'models/ujian.dart';
import 'models/soal.dart';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  // Inisialisasi database SQLite saat aplikasi mulai
  final db = await DatabaseHelper.instance.database;

  // Pastikan data demo terisi agar seluruh layar memiliki data realistis
  final ujianCheck = await db.query('ujian');
  if (ujianCheck.isEmpty) {
    final idUjian = await db.insert('ujian', {
      'nama_ujian': 'UTS Pemrograman Mobile',
      'mata_pelajaran': 'Mobile Programming',
      'durasi': 60,
      'tanggal': '2026-10-20',
      'status': 'AKTIF',
      'kode_ujian': 'FOKUS2026'
    });

    await db.insert('soal', {
      'id_ujian': idUjian,
      'teks_soal': 'Widget utama yang digunakan untuk membuat layout vertikal di Flutter adalah...',
      'opsi_a': 'Row',
      'opsi_b': 'Column',
      'opsi_c': 'Stack',
      'opsi_d': 'Container',
      'jawaban_benar': 'B'
    });

    await db.insert('soal', {
      'id_ujian': idUjian,
      'teks_soal': 'Database relasional lokal yang umum digunakan pada aplikasi Flutter adalah...',
      'opsi_a': 'Firebase',
      'opsi_b': 'SQLite / sqflite',
      'opsi_c': 'MongoDB',
      'opsi_d': 'Redis',
      'jawaban_benar': 'B'
    });

    await db.insert('soal', {
      'id_ujian': idUjian,
      'teks_soal': 'Mekanisme pencegahan contek pada FokusUjian mendeteksi interaksi pengguna di area...',
      'opsi_a': 'Tengah layar',
      'opsi_b': 'Tombol volume',
      'opsi_c': 'Tepi layar (Edge Touch)',
      'opsi_d': 'Sensor kamera',
      'jawaban_benar': 'C'
    });

    final idPeserta = await db.insert('peserta', {
      'id_ujian': idUjian,
      'nama': 'Adityo Arifin',
      'kelas': 'PTI 24 B',
      'identitas': '2453025006'
    });

    await db.insert('jawaban', {
      'id_peserta': idPeserta,
      'id_soal': 1,
      'jawaban': 'B',
      'waktu_jawab': '2026-10-20 08:10:00'
    });
    await db.insert('jawaban', {
      'id_peserta': idPeserta,
      'id_soal': 2,
      'jawaban': 'B',
      'waktu_jawab': '2026-10-20 08:12:00'
    });
    await db.insert('jawaban', {
      'id_peserta': idPeserta,
      'id_soal': 3,
      'jawaban': 'C',
      'waktu_jawab': '2026-10-20 08:14:00'
    });

    await db.insert('pelanggaran', {
      'id_peserta': idPeserta,
      'waktu': '2026-10-20 08:15:20',
      'posisi_x': 4.0,
      'posisi_y': 150.0,
      'jenis_pelanggaran': 'Sentuhan Tepi Kiri (Edge Touch)'
    });
  }

  runApp(const FokusUjianApp());
}

final _demoUjian = Ujian(
  idUjian: 1,
  namaUjian: 'UTS Pemrograman Mobile',
  mataPelajaran: 'Mobile Programming',
  durasi: 60,
  tanggal: '2026-10-20',
  status: 'AKTIF',
  kodeUjian: 'FOKUS2026',
);

class FokusUjianApp extends StatelessWidget {
  const FokusUjianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fokus Ujian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/start': (context) => const StartScreen(),
        '/identitas': (context) => const IdentitasPesertaScreen(),
        '/aturan': (context) => AturanUjianScreen(ujian: _demoUjian, idPeserta: 1),
        '/exam': (context) => ExamScreen(ujian: _demoUjian, idPeserta: 1),
        '/warning': (context) => const WarningScreen(),
        '/hasil': (context) => HasilUjianScreen(ujian: _demoUjian, idPeserta: 1),
        '/login': (context) => const LoginScreen(),
        '/dashboard_guru': (context) => const DashboardGuruScreen(),
        '/kelola_ujian': (context) => KelolaUjianScreen(ujian: _demoUjian),
        '/manajemen_soal': (context) => ManajemenSoalScreen(
          idUjian: 1,
          soal: Soal(
            idSoal: 1,
            idUjian: 1,
            teksSoal: 'Mekanisme pencegahan contek pada FokusUjian mendeteksi interaksi pengguna di area...',
            opsiA: 'Tengah layar',
            opsiB: 'Tombol volume',
            opsiC: 'Tepi layar (Edge Touch)',
            opsiD: 'Sensor kamera',
            jawabanBenar: 'C',
          ),
        ),
        '/monitoring': (context) => MonitoringUjianScreen(ujian: _demoUjian),
        '/dashboard_admin': (context) => const DashboardAdminScreen(),
        '/kelola_guru': (context) => const KelolaGuruScreen(),
      },
    );
  }
}