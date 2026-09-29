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
    _loadUjian(); // Refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
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
                        ? const Center(child: Text('Belum ada ujian. Silakan buat baru.'))
                        : ListView.builder(
                            itemCount: _ujianList.length,
                            itemBuilder: (context, index) {
                              final u = _ujianList[index];
                              return Card(
                                child: ListTile(
                                  title: Text(u.namaUjian),
                                  subtitle: Text('${u.mataPelajaran} - ${u.durasi} menit (${u.status})'),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.monitor, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MonitoringUjianScreen(ujian: u),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => KelolaUjianScreen(ujian: u),
                                            ),
                                          );
                                          _loadUjian();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Hapus Ujian'),
                                              content: const Text('Apakah Anda yakin ingin menghapus ujian ini? Semua data soal dan nilai terkait juga akan terhapus.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                          
                                          if (confirm == true && u.idUjian != null) {
                                            await _ujianRepo.deleteUjian(u.idUjian!);
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Ujian berhasil dihapus')),
                                              );
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
