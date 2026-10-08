import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/ujian.dart';
import '../../models/soal.dart';
import '../../models/jawaban.dart';
import '../../repositories/soal_repository.dart';
import '../../repositories/jawaban_repository.dart';
import '../../models/pelanggaran.dart';
import '../../repositories/pelanggaran_repository.dart';
import 'hasil_ujian_screen.dart';
import 'warning_screen.dart';

class ExamScreen extends StatefulWidget {
  final Ujian ujian;
  final int idPeserta;

  const ExamScreen({super.key, required this.ujian, required this.idPeserta});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final _soalRepo = SoalRepository();
  final _jawabanRepo = JawabanRepository();
  final _pelanggaranRepo = PelanggaranRepository();

  List<Soal> _soalList = [];
  Map<int, String> _jawabanPeserta = {}; // Menyimpan sementara jawaban per soal
  int _currentIndex = 0;
  bool _isLoading = true;

  late Timer _timer;
  int _sisaWaktuDetik = 0;

  @override
  void initState() {
    super.initState();
    _sisaWaktuDetik = widget.ujian.durasi * 60;
    _startTimer();
    _loadSoal();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sisaWaktuDetik > 0) {
        setState(() {
          _sisaWaktuDetik--;
        });
      } else {
        _timer.cancel();
        _submitUjian();
      }
    });
  }

  Future<void> _loadSoal() async {
    final list = await _soalRepo.getSoalByUjian(widget.ujian.idUjian!);
    // Tarik jawaban sebelumnya jika ada (opsional jika terputus)
    final jawabanList = await _jawabanRepo.getJawabanPeserta(widget.idPeserta);
    
    Map<int, String> initJawaban = {};
    for (var j in jawabanList) {
      initJawaban[j.idSoal] = j.jawaban;
    }

    setState(() {
      _soalList = list;
      _jawabanPeserta = initJawaban;
      _isLoading = false;
    });
  }

  Future<void>? _pendingSave;

  void _pilihJawaban(int idSoal, String opsi) {
    setState(() {
      _jawabanPeserta[idSoal] = opsi;
    });
    
    // Simpan ke SQLite secara lokal
    final jwb = Jawaban(
      idPeserta: widget.idPeserta,
      idSoal: idSoal,
      jawaban: opsi,
      waktuJawab: DateTime.now().toIso8601String(),
    );
    _pendingSave = _jawabanRepo.saveAnswer(jwb);
  }

  void _submitUjian() async {
    if (_pendingSave != null) {
      await _pendingSave;
    }
    if (_timer.isActive) _timer.cancel();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HasilUjianScreen(
          ujian: widget.ujian,
          idPeserta: widget.idPeserta,
        ),
      ),
    );
  }

  String _formatWaktu(int detik) {
    final m = (detik / 60).floor().toString().padLeft(2, '0');
    final s = (detik % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  bool _isViolationOnCooldown = false;

  void _checkEdgeTouch(PointerDownEvent event) {
    // Cegah double-trigger pelanggaran dalam waktu singkat (debounce 3 detik)
    if (_isViolationOnCooldown) return;

    final margin = 24.0;
    final size = MediaQuery.of(context).size;
    final pos = event.position;

    if (pos.dx <= margin ||
        pos.dx >= size.width - margin ||
        pos.dy <= margin ||
        pos.dy >= size.height - margin) {

      // Aktifkan cooldown
      _isViolationOnCooldown = true;
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _isViolationOnCooldown = false);
      });

      // Log pelanggaran
      final p = Pelanggaran(
        idPeserta: widget.idPeserta,
        waktu: DateTime.now().toIso8601String(),
        posisiX: pos.dx,
        posisiY: pos.dy,
        jenisPelanggaran: 'Edge Touch',
      );
      _pelanggaranRepo.logViolation(p);

      // Navigasi ke peringatan
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WarningScreen()),
      ).then((_) {
        // Reset cooldown setelah kembali dari warning screen
        if (mounted) setState(() => _isViolationOnCooldown = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_soalList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.ujian.namaUjian)),
        body: const Center(child: Text('Tidak ada soal dalam ujian ini.')),
      );
    }

    final soal = _soalList[_currentIndex];
    final jawabanTerpilih = _jawabanPeserta[soal.idSoal];

    return Listener(
      onPointerDown: _checkEdgeTouch,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.ujian.namaUjian),
          automaticallyImplyLeading: false, // Matikan tombol back native
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Header waktu dan progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sisa waktu: ${_formatWaktu(_sisaWaktuDetik)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text('Soal ${_currentIndex + 1}/${_soalList.length}'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _soalList.length,
              ),
              const SizedBox(height: 24),
              // Soal
              Text(
                '${_currentIndex + 1}. ${soal.teksSoal}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Opsi jawaban
              RadioGroup<String>(
                groupValue: jawabanTerpilih ?? '',
                onChanged: (val) { if (val != null) _pilihJawaban(soal.idSoal!, val); },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(soal.opsiA),
                      value: 'A',
                    ),
                    RadioListTile<String>(
                      title: Text(soal.opsiB),
                      value: 'B',
                    ),
                    RadioListTile<String>(
                      title: Text(soal.opsiC),
                      value: 'C',
                    ),
                    RadioListTile<String>(
                      title: Text(soal.opsiD),
                      value: 'D',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Navigasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                    child: const Text('Sebelumnya'),
                  ),
                  if (_currentIndex < _soalList.length - 1)
                    ElevatedButton(
                      onPressed: () => setState(() => _currentIndex++),
                      child: const Text('Berikutnya'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submitUjian,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text('SUBMIT UJIAN'),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}
