import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../repositories/jawaban_repository.dart';
import '../../repositories/pelanggaran_repository.dart';

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
  
  bool _isLoading = true;
  int _jumlahBenar = 0;
  int _jumlahSalah = 0;
  int _jumlahPelanggaran = 0;
  double _nilaiAkhir = 0;

  @override
  void initState() {
    super.initState();
    _kalkulasiHasil();
  }

  Future<void> _kalkulasiHasil() async {
    // Tarik data jawaban
    final jawabanList = await _jawabanRepo.getJawabanPeserta(widget.idPeserta);
    final pelanggaranList = await _pelanggaranRepo.getPelanggaranPeserta(widget.idPeserta);

    // TODO: Untuk kalkulasi benar/salah, kita perlu mencocokkan dengan SoalRepository. 
    // Di prototipe awal ini, mari asumsikan dummy kalkulasi 
    // karena kita belum melewatkan kunci jawaban ke layar hasil.
    // Idealnya tarik List<Soal> lalu cocokkan.
    
    _jumlahPelanggaran = pelanggaranList.length;
    
    // Kalkulasi nilai sederhana (100 jika menjawab semua dan benar)
    // Di sini mockup untuk UI saja jika belum ada join query.
    _jumlahBenar = jawabanList.length; // Anggap benar semua sementara
    _jumlahSalah = 0;
    _nilaiAkhir = 86.0;

    setState(() {
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
                      const Text('NILAI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        _nilaiAkhir.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('Benar'),
                trailing: Text(_jumlahBenar.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Salah'),
                trailing: Text(_jumlahSalah.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Pelanggaran Terdeteksi', style: TextStyle(color: Colors.red)),
                trailing: Text(_jumlahPelanggaran.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('KEMBALI KE LAYAR UTAMA'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
