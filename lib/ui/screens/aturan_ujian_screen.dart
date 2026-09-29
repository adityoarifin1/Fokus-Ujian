import 'package:flutter/material.dart';
import '../../models/ujian.dart';
import 'exam_screen.dart';

class AturanUjianScreen extends StatefulWidget {
  final Ujian ujian;
  final int idPeserta;

  const AturanUjianScreen({super.key, required this.ujian, required this.idPeserta});

  @override
  State<AturanUjianScreen> createState() => _AturanUjianScreenState();
}

class _AturanUjianScreenState extends State<AturanUjianScreen> {
  bool _setuju1 = false;
  bool _setuju2 = false;
  bool _setuju3 = false;
  bool _setuju4 = false;

  void _mulaiUjian() {
    if (_setuju1 && _setuju2 && _setuju3 && _setuju4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ExamScreen(
            ujian: widget.ujian,
            idPeserta: widget.idPeserta,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui semua aturan untuk memulai.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aturan Ujian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ATURAN PENGERJAAN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Tetap berada pada halaman ujian.'),
              value: _setuju1,
              onChanged: (val) => setState(() => _setuju1 = val!),
            ),
            CheckboxListTile(
              title: const Text('Jangan menyentuh area tepi layar.'),
              value: _setuju2,
              onChanged: (val) => setState(() => _setuju2 = val!),
            ),
            CheckboxListTile(
              title: const Text('Ujian berakhir saat waktu habis atau disubmit.'),
              value: _setuju3,
              onChanged: (val) => setState(() => _setuju3 = val!),
            ),
            CheckboxListTile(
              title: const Text('Pelanggaran akan dicatat oleh sistem.'),
              value: _setuju4,
              onChanged: (val) => setState(() => _setuju4 = val!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _mulaiUjian,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAYA SETUJU & MULAI'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
