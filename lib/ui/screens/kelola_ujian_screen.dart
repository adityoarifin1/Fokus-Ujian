import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import '../../models/soal.dart';
import '../../repositories/ujian_repository.dart';
import '../../repositories/soal_repository.dart';
import 'manajemen_soal_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:typed_data';
import 'package:desktop_drop/desktop_drop.dart';


class KelolaUjianScreen extends StatefulWidget {
  final Ujian? ujian;

  const KelolaUjianScreen({super.key, this.ujian});

  @override
  State<KelolaUjianScreen> createState() => _KelolaUjianScreenState();
}

class _KelolaUjianScreenState extends State<KelolaUjianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mapelController = TextEditingController();
  final _durasiController = TextEditingController();
  final _kodeController = TextEditingController();
  
  final _ujianRepo = UjianRepository();
  final _soalRepo = SoalRepository();

  bool _isEdit = false;
  List<Soal> _soalList = [];

  @override
  void initState() {
    super.initState();
    if (widget.ujian != null) {
      _isEdit = true;
      _namaController.text = widget.ujian!.namaUjian;
      _mapelController.text = widget.ujian!.mataPelajaran;
      _durasiController.text = widget.ujian!.durasi.toString();
      _kodeController.text = widget.ujian!.kodeUjian;
      _loadSoal();
    }
  }

  Future<void> _loadSoal() async {
    if (widget.ujian?.idUjian != null) {
      final list = await _soalRepo.getSoalByUjian(widget.ujian!.idUjian!);
      setState(() {
        _soalList = list;
      });
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final u = Ujian(
        idUjian: widget.ujian?.idUjian,
        namaUjian: _namaController.text.trim(),
        mataPelajaran: _mapelController.text.trim(),
        durasi: int.tryParse(_durasiController.text.trim()) ?? 0,
        tanggal: DateTime.now().toIso8601String(),
        status: widget.ujian?.status ?? 'Draft',
        kodeUjian: _kodeController.text.trim(),
      );

      try {
        if (_isEdit) {
          await _ujianRepo.updateUjian(u);
        } else {
          await _ujianRepo.insertUjian(u);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: $e')),
          );
        }
      }
    }
  }

  void _hapus() async {
    if (_isEdit && widget.ujian?.idUjian != null) {
      await _ujianRepo.deleteUjian(widget.ujian!.idUjian!);
      if (mounted) Navigator.pop(context);
    }
  }

  bool _isDragging = false;

  Future<void> _processExcelBytes(Uint8List bytes) async {
    try {
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;
        
        // Mulai dari row 1 (mengabaikan row 0 sebagai header)
        for (int i = 1; i < sheet.maxRows; i++) {
          var row = sheet.row(i);
          String getStr(int index) {
            if (index >= row.length) return '';
            return row[index]?.value?.toString().trim() ?? '';
          }

          final teksSoal = getStr(0);
          final opsiA = getStr(1);
          final opsiB = getStr(2);
          final opsiC = getStr(3);
          final opsiD = getStr(4);
          final kunciRaw = getStr(5);
          final kunci = kunciRaw.isNotEmpty ? kunciRaw : 'A';

          if (teksSoal.isNotEmpty) {
            final s = Soal(
              idUjian: widget.ujian!.idUjian!,
              teksSoal: teksSoal,
              opsiA: opsiA,
              opsiB: opsiB,
              opsiC: opsiC,
              opsiD: opsiD,
              jawabanBenar: kunci.toUpperCase(),
            );
            await _soalRepo.insertSoal(s);
          }
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil mengimpor soal dari Excel!')),
        );
        _loadSoal();
      }
    } catch (e, st) {
      if (mounted) {
        print('Error Excel: $e\n$st');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal impor: File rusak atau tidak valid.')),
        );
      }
    }
  }

  Future<void> _importExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        if (!result.files.single.name.toLowerCase().endsWith('.xlsx')) {
          throw Exception('File harus berformat .xlsx');
        }
        await _processExcelBytes(result.files.single.bytes!);
      }
    } catch (e, st) {
      if (mounted) {
        print('Error FilePicker: $e\n$st');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal pilih file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Kelola Ujian' : 'Buat Ujian Baru'),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _hapus,
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Ujian'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _mapelController,
                    decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _durasiController,
                    decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _kodeController,
                    decoration: const InputDecoration(labelText: 'Kode Ujian'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _simpan,
                    child: const Text('Simpan Ujian'),
                  ),
                ],
              ),
            ),
            if (_isEdit) ...[
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Soal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _importExcel,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Import Excel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ManajemenSoalScreen(idUjian: widget.ujian!.idUjian!),
                            ),
                          );
                          _loadSoal();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Soal'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropTarget(
                onDragEntered: (details) {
                  setState(() => _isDragging = true);
                },
                onDragExited: (details) {
                  setState(() => _isDragging = false);
                },
                onDragDone: (details) async {
                  setState(() => _isDragging = false);
                  if (details.files.isNotEmpty) {
                    final file = details.files.first;
                    if (!file.name.toLowerCase().endsWith('.xlsx')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hanya file .xlsx yang didukung')),
                      );
                      return;
                    }
                    try {
                      final bytes = await file.readAsBytes();
                      await _processExcelBytes(bytes);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal membaca file: $e')),
                        );
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isDragging ? Colors.green.withOpacity(0.1) : Colors.transparent,
                    border: _isDragging 
                      ? Border.all(color: Colors.green, width: 2)
                      : Border.all(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _soalList.isEmpty 
                    ? const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Belum ada soal. Anda bisa menambahkan soal secara manual atau drag-and-drop file .xlsx ke sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _soalList.length,
                        itemBuilder: (context, index) {
                          final soal = _soalList[index];
                          return Card(
                            child: ListTile(
                              title: Text(soal.teksSoal),
                              subtitle: Text('Kunci: ${soal.jawabanBenar}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ManajemenSoalScreen(
                                            idUjian: widget.ujian!.idUjian!,
                                            soal: soal,
                                          ),
                                        ),
                                      );
                                      _loadSoal();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Hapus Soal'),
                                          content: const Text('Apakah Anda yakin ingin menghapus soal ini?'),
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
                                      
                                      if (confirm == true && soal.idSoal != null) {
                                        await _soalRepo.deleteSoal(soal.idSoal!);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Soal berhasil dihapus')),
                                          );
                                          _loadSoal();
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
              ),
            ]
          ],
        ),
      ),
    );
  }
}
