import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const _fileName = 'head_soccer_device_id.txt';

Future<String> getOrCreateDeviceId() async {
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
  } catch (_) {}
  return _memoryDeviceId ??= const Uuid().v4();
}

String? _memoryDeviceId;
