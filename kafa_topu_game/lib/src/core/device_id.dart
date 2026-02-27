import 'device_id_stub.dart' if (dart.library.io) 'device_id_io.dart' as impl;

/// Cihaz/session id. Mobil/desktop: dosyaya yazar; web: sadece bellek (sayfa yenilenince sıfırlanır).
Future<String> getOrCreateDeviceId() => impl.getOrCreateDeviceId();
