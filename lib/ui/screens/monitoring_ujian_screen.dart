import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../models/peserta.dart';
import '../../repositories/peserta_repository.dart';
import '../../repositories/pelanggaran_repository.dart';

class MonitoringUjianScreen extends StatefulWidget {
  final Ujian ujian;

  const MonitoringUjianScreen({super.key, required this.ujian});

  @override
  State<MonitoringUjianScreen> createState() => _MonitoringUjianScreenState();
}

class _MonitoringUjianScreenState extends State<MonitoringUjianScreen> {
  final _pesertaRepo = PesertaRepository();
  final _pelanggaranRepo = PelanggaranRepository();
  
  List<Peserta> _pesertaList = [];
  Map<int, int> _pelanggaranCount = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final list = await _pesertaRepo.getPesertaByUjian(widget.ujian.idUjian!);
    Map<int, int> counts = {};

    for (var p in list) {
      final pelanggaran = await _pelanggaranRepo.getPelanggaranPeserta(p.idPeserta!);
      counts[p.idPeserta!] = pelanggaran.length;
    }

    setState(() {
      _pesertaList = list;
      _pelanggaranCount = counts;
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
                    
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(p.nama),
                        subtitle: Text('Kelas: ${p.kelas} | ID: ${p.identitas}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pCount > 0 ? '$pCount Pelanggaran' : 'Aman',
                              style: TextStyle(
                                color: pCount > 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: Detail hasil per peserta (jawaban dan log waktu pelanggaran)
                          _showDetailDialog(p, pCount);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _showDetailDialog(Peserta p, int pelanggaranCount) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Detail: ${p.nama}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Identitas: ${p.identitas}'),
            Text('Kelas: ${p.kelas}'),
            const SizedBox(height: 12),
            Text('Total Pelanggaran (Edge Touch): $pelanggaranCount', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Fitur rekapan detail per jawaban akan ditambahkan di pengembangan lanjutan.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12)),
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
