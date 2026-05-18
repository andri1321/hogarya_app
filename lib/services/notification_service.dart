import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple per-user notification preferences service with persistence.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final Map<String, bool> _enabled = {};

  final ValueNotifier<int> notifier = ValueNotifier(0);

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('notification_service_enabled');
    if (raw != null) {
      final Map<String, dynamic> map = json.decode(raw);
      map.forEach((k, v) {
        _enabled[k] = v as bool;
      });
    }

    _initialized = true;
    notifier.value++;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_service_enabled', json.encode(_enabled));
  }

  bool isEnabled(String userId) {
    return _enabled[userId] ?? false;
  }

  void setEnabled(String userId, bool enabled) {
    _enabled[userId] = enabled;
    _save();
    notifier.value++;
  }

  void toggle(String userId) {
    final current = isEnabled(userId);
    setEnabled(userId, !current);
  }
}
