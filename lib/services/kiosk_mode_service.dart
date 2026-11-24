import 'package:flutter/services.dart';

class KioskModeService {
  static const MethodChannel _channel =
      MethodChannel('com.example.flutter_application_1/kiosk');

  static Future<void> enable() async {
    try {
      await _channel.invokeMethod('enableKioskMode');
    } on Exception {
      // Abaikan di platform non-Android atau saat lock task tidak didukung.
    }
  }

  static Future<void> disable() async {
    try {
      await _channel.invokeMethod('disableKioskMode');
    } on Exception {
      // Abaikan di platform non-Android atau saat lock task tidak didukung.
    }
  }
}
