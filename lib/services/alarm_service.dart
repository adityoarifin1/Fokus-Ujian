import 'package:audioplayers/audioplayers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:flutter/foundation.dart';
// Conditional import: jika dikompilasi ke Web (punya pustaka dart:html),
// gunakan alarm_web_helper.dart. Jika tidak, gunakan alarm_mobile_helper.dart.
import 'alarm_mobile_helper.dart' if (dart.library.html) 'alarm_web_helper.dart' as web_helper;

class AlarmService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  void _scheduleTingTungLoop() {
    if (!_isPlaying) return;
    // web_helper otomatis merujuk ke fungsi kosong (di Mobile)
    // atau merujuk ke fungsi dart:js (di Web)
    web_helper.playWebTingTung(_isPlaying, _scheduleTingTungLoop);
  }

  Future<void> triggerAlarmEvent() async {
    try {
      if (kIsWeb) {
        if (!_isPlaying) {
          _isPlaying = true;
          _scheduleTingTungLoop();
        }
      } else {
        _isPlaying = true;
        // Kembalikan plugin volume_controller khusus untuk Mobile
        VolumeController.instance.setVolume(1.0);
        
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
