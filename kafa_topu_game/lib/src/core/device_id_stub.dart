import 'package:uuid/uuid.dart';

Future<String> getOrCreateDeviceId() async {
  return _memoryDeviceId ??= const Uuid().v4();
}

String? _memoryDeviceId;
