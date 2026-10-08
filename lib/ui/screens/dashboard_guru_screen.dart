import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../repositories/ujian_repository.dart';
import 'kelola_ujian_screen.dart';
import 'login_screen.dart';
import 'monitoring_ujian_screen.dart';

class DashboardGuruScreen extends StatefulWidget {
  const DashboardGuruScreen({super.key});

  @override
  State<DashboardGuruScreen> createState() => _DashboardGuruScreenState();
}

class _DashboardGuruScreenState extends State<DashboardGuruScreen> {
  final _ujianRepo = UjianRepository();
  List<Ujian> _ujianList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUjian();
  }

  Future<void> _loadUjian() async {
    setState(() => _isLoading = true);
    final list = await _ujianRepo.getSemuaUjian();
    setState(() {
      _ujianList = list;
      _isLoading = false;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _tambahUjian() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KelolaUjianScreen()),
    );
    _loadUjian();
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'AKTIF':
        return Colors.green;
      case 'BERLANGSUNG':
        return Colors.blue;
      case 'SELESAI':
        return Colors.grey;
      case 'DIBATALKAN':
        return Colors.red;
      default:
        return Colors.orange; // DRAFT
    }
  }

  String _nextStatus(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Aktif';
      case 'AKTIF':
        return 'Selesai';
      default:
        return '';
    }
  }

  void _ubahStatus(Ujian u) async {
    final next = _nextStatus(u.status);
    if (next.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status "${u.status}" tidak dapat diubah lagi.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Status Ujian'),
        content: Text('Ubah status "${u.namaUjian}" dari "${u.status}" menjadi "$next"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Jadikan $next'),
          ),
        ],
      ),
    );

    if (confirm == true && u.idUjian != null) {
      await _ujianRepo.updateStatusUjian(u.idUjian!, next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status ujian diubah menjadi "$next"')),
        );
        _loadUjian();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout)
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Ujian',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _tambahUjian,
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Ujian Baru'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _ujianList.isEmpty
                        ? const Center(
                            child: Text('Belum ada ujian. Silakan buat baru.'))
                        : ListView.builder(
                            itemCount: _ujianList.length,
                            itemBuilder: (context, index) {
                              final u = _ujianList[index];
                              return Card(
                                child: ListTile(
                                  title: Text(u.namaUjian,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${u.mataPelajaran} · ${u.durasi} menit · Kode: ${u.kodeUjian}'),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _statusColor(u.status),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          u.status.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_nextStatus(u.status).isNotEmpty)
                                        IconButton(
                                          icon: const Icon(Icons.play_circle,
                                              color: Colors.green),
                                          tooltip:
                                              'Ubah ke ${_nextStatus(u.status)}',
                                          onPressed: () => _ubahStatus(u),
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.monitor,
                                            color: Colors.blue),
                                        tooltip: 'Monitoring',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    MonitoringUjianScreen(
                                                        ujian: u)),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit',
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    KelolaUjianScreen(
                                                        ujian: u)),
                                          );
                                          _loadUjian();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        tooltip: 'Hapus',
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Hapus Ujian'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus ujian ini? Semua data soal dan nilai terkait juga akan terhapus.'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child:
                                                        const Text('Batal')),
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: const Text('Hapus',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                              ],
                                            ),
                                          );
                                          if (confirm == true &&
                                              u.idUjian != null) {
                                            await _ujianRepo
                                                .deleteUjian(u.idUjian!);
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Ujian berhasil dihapus')));
                                              _loadUjian();
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
