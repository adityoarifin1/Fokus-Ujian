import 'package:audioplayers/audioplayers.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:flutter/foundation.dart';

class AlarmService {
  final AudioPlayer _player = AudioPlayer();
  
  Future<void> triggerAlarmEvent() async {
    try {
      // Set volume to 100% (1.0) hanya jika bukan di Web
      // karena plugin perfect_volume_control tidak mendukung Web
      if (!kIsWeb) {
        await PerfectVolumeControl.setVolume(1.0);
      }
      
      // Play a ringing sound ("ting tung")
      // Pastikan ada file alarm.mp3 di folder assets dan terdaftar di pubspec.yaml
      _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('alarm.mp3'));
      
      debugPrint('ALARM TRIGGERED!');
    } catch (e) {
      debugPrint('Error triggering alarm: $e');
    }
  }

  Future<void> stopAlarmEvent() async {
    try {
      await _player.stop();
      debugPrint('ALARM STOPPED!');
    } catch (e) {
      debugPrint('Error stopping alarm: $e');
    }
  }
}
