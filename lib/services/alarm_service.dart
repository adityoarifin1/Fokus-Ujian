import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class AlarmService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  /// Membuat suara "ting tung" menggunakan Web Audio API
  /// (berjalan di browser tanpa perlu file MP3)
  void _playWebTingTung() {
    if (_isPlaying) return;
    _isPlaying = true;
    _scheduleTingTungLoop();
  }

  void _scheduleTingTungLoop() {
    if (!_isPlaying) return;
    // Ting (frekuensi tinggi)
    js.context.callMethod('eval', ['''
      (function() {
        var ctx = new (window.AudioContext || window.webkitAudioContext)();
        function playNote(freq, start, duration) {
          var osc = ctx.createOscillator();
          var gain = ctx.createGain();
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.type = 'sine';
          osc.frequency.setValueAtTime(freq, ctx.currentTime + start);
          gain.gain.setValueAtTime(0.8, ctx.currentTime + start);
          gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + start + duration);
          osc.start(ctx.currentTime + start);
          osc.stop(ctx.currentTime + start + duration);
        }
        playNote(1200, 0, 0.4);   // Ting
        playNote(900, 0.45, 0.5); // Tung
      })();
    ''']);

    // Ulangi setiap 1.5 detik selama alarm aktif
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_isPlaying) _scheduleTingTungLoop();
    });
  }

  Future<void> triggerAlarmEvent() async {
    try {
      if (kIsWeb) {
        // Gunakan Web Audio API untuk suara ting-tung di browser
        _playWebTingTung();
      } else {
        // Mobile: gunakan audioplayers dan naikkan volume ke 100%
        _isPlaying = true;
        _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource('alarm.mp3'));
      }
      debugPrint('ALARM TRIGGERED!');
    } catch (e) {
      debugPrint('Error triggering alarm: $e');
    }
  }

  Future<void> stopAlarmEvent() async {
    try {
      _isPlaying = false;
      if (!kIsWeb) {
        await _player.stop();
      }
      debugPrint('ALARM STOPPED!');
    } catch (e) {
      debugPrint('Error stopping alarm: $e');
    }
  }
}

