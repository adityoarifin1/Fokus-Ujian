import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../repositories/jawaban_repository.dart';
import '../../repositories/pelanggaran_repository.dart';
import '../../repositories/soal_repository.dart';

class HasilUjianScreen extends StatefulWidget {
  final Ujian ujian;
  final int idPeserta;

  const HasilUjianScreen({super.key, required this.ujian, required this.idPeserta});

  @override
  State<HasilUjianScreen> createState() => _HasilUjianScreenState();
}

class _HasilUjianScreenState extends State<HasilUjianScreen> {
  final _jawabanRepo = JawabanRepository();
  final _pelanggaranRepo = PelanggaranRepository();
  final _soalRepo = SoalRepository();
  
  bool _isLoading = true;
  int _jumlahBenar = 0;
  int _jumlahSalah = 0;
  int _jumlahPelanggaran = 0;
  int _totalSoal = 0;
  double _nilaiAkhir = 0;

  @override
  void initState() {
    super.initState();
    _kalkulasiHasil();
  }

  Future<void> _kalkulasiHasil() async {
    // Tarik semua soal ujian dan jawaban peserta
    final soalList = await _soalRepo.getSoalByUjian(widget.ujian.idUjian!);
    final jawabanList = await _jawabanRepo.getJawabanPeserta(widget.idPeserta);
    final pelanggaranList = await _pelanggaranRepo.getPelanggaranPeserta(widget.idPeserta);

    // Buat map kunci jawaban: id_soal -> jawaban_benar
    final kunciJawaban = {for (var s in soalList) s.idSoal!: s.jawabanBenar};

    // Buat map jawaban peserta: id_soal -> jawaban
    final jawabanPeserta = {for (var j in jawabanList) j.idSoal: j.jawaban};

    int benar = 0;
    int salah = 0;

    for (var soal in soalList) {
      final jawaban = jawabanPeserta[soal.idSoal];
      final kunci = kunciJawaban[soal.idSoal];
      if (jawaban != null && kunci != null) {
        if (jawaban.toUpperCase() == kunci.toUpperCase()) {
          benar++;
        } else {
          salah++;
        }
      } else {
        // Soal tidak dijawab dihitung salah
        salah++;
      }
    }

    final total = soalList.length;
    final nilai = total > 0 ? (benar / total) * 100 : 0.0;

    setState(() {
      _jumlahBenar = benar;
      _jumlahSalah = salah;
      _jumlahPelanggaran = pelanggaranList.length;
      _totalSoal = total;
      _nilaiAkhir = nilai;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Ujian'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('UJIAN SELESAI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('NILAI AKHIR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        _nilaiAkhir.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _nilaiAkhir >= 75 ? Colors.green : (_nilaiAkhir >= 50 ? Colors.orange : Colors.red),
                        ),
                      ),
                      Text(
                        _nilaiAkhir >= 75 ? 'LULUS' : 'TIDAK LULUS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _nilaiAkhir >= 75 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: const Text('Jawaban Benar'),
                        trailing: Text('$_jumlahBenar / $_totalSoal', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.cancel, color: Colors.red),
                        title: const Text('Jawaban Salah / Tidak Dijawab'),
                        trailing: Text(_jumlahSalah.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.warning, color: Colors.orange),
                        title: const Text('Pelanggaran Terdeteksi'),
                        trailing: Text(_jumlahPelanggaran.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('KEMBALI KE LAYAR UTAMA'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
