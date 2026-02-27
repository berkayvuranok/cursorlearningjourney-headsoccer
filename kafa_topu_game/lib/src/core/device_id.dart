import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _keyDeviceId = 'head_soccer_device_id';
const _fileName = 'head_soccer_device_id.txt';

/// Persistent device/session id. Tries SharedPreferences first;
/// on "no implementation found" uses file storage, then in-memory fallback.
Future<String> getOrCreateDeviceId() async {
  // 1) Try SharedPreferences (can throw MissingPluginException on some platforms)
  try {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_keyDeviceId);
    if (id != null && id.isNotEmpty) return id;
    id = const Uuid().v4();
    await prefs.setString(_keyDeviceId, id);
    return id;
  } catch (_) {
    // 2) Fallback: file in application support directory
  }

  try {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/$_fileName');
    if (await file.exists()) {
      final id = await file.readAsString();
      if (id.isNotEmpty) return id.trim();
    }
    final id = const Uuid().v4();
    await file.writeAsString(id);
    return id;
  } catch (_) {
    // 3) In-memory fallback (resets on app restart)
  }

  return _memoryDeviceId ??= const Uuid().v4();
}

String? _memoryDeviceId;
