import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../models/peserta.dart';
import '../../repositories/peserta_repository.dart';
import '../../repositories/pelanggaran_repository.dart';
import '../../repositories/jawaban_repository.dart';
import '../../repositories/soal_repository.dart';

class MonitoringUjianScreen extends StatefulWidget {
  final Ujian ujian;

  const MonitoringUjianScreen({super.key, required this.ujian});

  @override
  State<MonitoringUjianScreen> createState() => _MonitoringUjianScreenState();
}

class _MonitoringUjianScreenState extends State<MonitoringUjianScreen> {
  final _pesertaRepo = PesertaRepository();
  final _pelanggaranRepo = PelanggaranRepository();
  final _jawabanRepo = JawabanRepository();
  final _soalRepo = SoalRepository();

  List<Peserta> _pesertaList = [];
  Map<int, int> _pelanggaranCount = {};
  Map<int, double> _nilaiPeserta = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final soalList = await _soalRepo.getSoalByUjian(widget.ujian.idUjian!);
    final kunciJawaban = {for (var s in soalList) s.idSoal!: s.jawabanBenar};

    final list = await _pesertaRepo.getPesertaByUjian(widget.ujian.idUjian!);
    Map<int, int> counts = {};
    Map<int, double> nilai = {};

    for (var p in list) {
      final pelanggaran = await _pelanggaranRepo.getPelanggaranPeserta(p.idPeserta!);
      counts[p.idPeserta!] = pelanggaran.length;

      // Hitung nilai peserta
      final jawabanList = await _jawabanRepo.getJawabanPeserta(p.idPeserta!);
      final jawabanPeserta = {for (var j in jawabanList) j.idSoal: j.jawaban};
      int benar = 0;
      for (var soal in soalList) {
        final jwb = jawabanPeserta[soal.idSoal];
        final kunci = kunciJawaban[soal.idSoal];
        if (jwb != null && kunci != null && jwb.toUpperCase() == kunci.toUpperCase()) {
          benar++;
        }
      }
      nilai[p.idPeserta!] = soalList.isNotEmpty ? (benar / soalList.length) * 100 : 0.0;
    }

    setState(() {
      _pesertaList = list;
      _pelanggaranCount = counts;
      _nilaiPeserta = nilai;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring: ${widget.ujian.namaUjian}'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pesertaList.isEmpty
              ? const Center(child: Text('Belum ada peserta yang mengikuti ujian ini.'))
              : ListView.builder(
                  itemCount: _pesertaList.length,
                  itemBuilder: (context, index) {
                    final p = _pesertaList[index];
                    final pCount = _pelanggaranCount[p.idPeserta] ?? 0;
                    final nilai = _nilaiPeserta[p.idPeserta] ?? 0.0;

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: nilai >= 75 ? Colors.green : (nilai > 0 ? Colors.orange : Colors.grey),
                          child: Text(
                            nilai > 0 ? nilai.toStringAsFixed(0) : '-',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        title: Text(p.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Kelas: ${p.kelas} | NIS: ${p.identitas}'),
                        trailing: pCount > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Text(
                                  '$pCount ⚠',
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Text('Aman ✓',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ),
                        onTap: () => _showDetailDialog(p, pCount, nilai),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDetailDialog(Peserta p, int pelanggaranCount, double nilai) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Detail: ${p.nama}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Identitas / NIS: ${p.identitas}'),
            Text('Kelas: ${p.kelas}'),
            const Divider(),
            Row(
              children: [
                const Text('Nilai Akhir: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  nilai.toStringAsFixed(0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: nilai >= 75 ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  nilai >= 75 ? ' (LULUS)' : ' (TIDAK LULUS)',
                  style: TextStyle(color: nilai >= 75 ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total Pelanggaran (Edge Touch): $pelanggaranCount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: pelanggaranCount > 0 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          )
        ],
      ),
    );
  }
}
