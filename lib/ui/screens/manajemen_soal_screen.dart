import 'package:flutter/material.dart';
import '../../models/soal.dart';
import '../../repositories/soal_repository.dart';

class ManajemenSoalScreen extends StatefulWidget {
  final int idUjian;
  final Soal? soal;

  const ManajemenSoalScreen({super.key, required this.idUjian, this.soal});

  @override
  State<ManajemenSoalScreen> createState() => _ManajemenSoalScreenState();
}

class _ManajemenSoalScreenState extends State<ManajemenSoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teksController = TextEditingController();
  final _opsiAController = TextEditingController();
  final _opsiBController = TextEditingController();
  final _opsiCController = TextEditingController();
  final _opsiDController = TextEditingController();
  String _kunciJawaban = 'A';
  
  final _soalRepo = SoalRepository();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.soal != null) {
      _isEdit = true;
      _teksController.text = widget.soal!.teksSoal;
      _opsiAController.text = widget.soal!.opsiA;
      _opsiBController.text = widget.soal!.opsiB;
      _opsiCController.text = widget.soal!.opsiC;
      _opsiDController.text = widget.soal!.opsiD;
      _kunciJawaban = widget.soal!.jawabanBenar;
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final s = Soal(
        idSoal: widget.soal?.idSoal,
        idUjian: widget.idUjian,
        teksSoal: _teksController.text,
        opsiA: _opsiAController.text,
        opsiB: _opsiBController.text,
        opsiC: _opsiCController.text,
        opsiD: _opsiDController.text,
        jawabanBenar: _kunciJawaban,
      );

      if (_isEdit) {
        await _soalRepo.updateSoal(s);
      } else {
        await _soalRepo.insertSoal(s);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  void _hapus() async {
    if (_isEdit && widget.soal?.idSoal != null) {
      await _soalRepo.deleteSoal(widget.soal!.idSoal!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Soal' : 'Tambah Soal'),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _teksController,
                decoration: const InputDecoration(labelText: 'Teks Soal', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _opsiAController,
                decoration: const InputDecoration(labelText: 'Opsi A', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _opsiBController,
                decoration: const InputDecoration(labelText: 'Opsi B', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _opsiCController,
                decoration: const InputDecoration(labelText: 'Opsi C', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _opsiDController,
                decoration: const InputDecoration(labelText: 'Opsi D', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _kunciJawaban,
                decoration: const InputDecoration(labelText: 'Kunci Jawaban', border: OutlineInputBorder()),
                items: ['A', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    _kunciJawaban = v!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan Soal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
