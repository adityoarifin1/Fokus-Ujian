import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  final _alarmService = AlarmService();

  @override
  void initState() {
    super.initState();
    _alarmService.triggerAlarmEvent();
  }

  void _hentikanAlarm() async {
    await _alarmService.stopAlarmEvent();
    if (mounted) {
      Navigator.pop(context); // Kembali ke ExamScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 100, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'PERINGATAN',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                'AREA TEPI TERDETEKSI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sentuhan pada area terlarang telah dicatat. Alarm aktif dan volume perangkat diatur ke maksimum.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _hentikanAlarm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('HENTIKAN ALARM KEMBALI KE UJIAN'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
