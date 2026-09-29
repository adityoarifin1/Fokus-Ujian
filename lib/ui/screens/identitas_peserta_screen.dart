import 'package:flutter/material.dart';
import '../../models/peserta.dart';
import '../../models/ujian.dart';
import '../../repositories/ujian_repository.dart';
import '../../repositories/peserta_repository.dart';
import 'aturan_ujian_screen.dart';

class IdentitasPesertaScreen extends StatefulWidget {
  const IdentitasPesertaScreen({super.key});

  @override
  State<IdentitasPesertaScreen> createState() => _IdentitasPesertaScreenState();
}

class _IdentitasPesertaScreenState extends State<IdentitasPesertaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _nisController = TextEditingController();
  final _kodeController = TextEditingController();

  final _ujianRepo = UjianRepository();
  final _pesertaRepo = PesertaRepository();

  bool _isLoading = false;

  void _lanjut() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Cari Ujian berdasarkan kode
      final kode = _kodeController.text.trim();
      final Ujian? ujian = await _ujianRepo.getUjianByKode(kode);

      if (ujian == null) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ujian dengan kode tersebut tidak ditemukan.')),
          );
        }
        return;
      }

      // Validasi status ujian
      if (ujian.status != 'Aktif' && ujian.status != 'Draft') { // Bisa disesuaikan lagi
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ujian belum aktif atau sudah selesai.')),
          );
        }
        return;
      }

      // Simpan data peserta
      final peserta = Peserta(
        idUjian: ujian.idUjian!,
        nama: _namaController.text.trim(),
        kelas: _kelasController.text.trim(),
        identitas: _nisController.text.trim(),
      );

      final idPeserta = await _pesertaRepo.insertPeserta(peserta);
      
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AturanUjianScreen(
              ujian: ujian,
              idPeserta: idPeserta,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identitas Peserta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap Siswa'),
                validator: (v) => v!.isEmpty ? 'Harap isi nama lengkap' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(labelText: 'Kelas'),
                validator: (v) => v!.isEmpty ? 'Harap isi kelas' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nisController,
                decoration: const InputDecoration(labelText: 'NIS / ID'),
                validator: (v) => v!.isEmpty ? 'Harap isi NIS / ID' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kodeController,
                decoration: const InputDecoration(labelText: 'Kode Ujian'),
                validator: (v) => v!.isEmpty ? 'Harap isi Kode Ujian' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _lanjut,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('LANJUT'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
