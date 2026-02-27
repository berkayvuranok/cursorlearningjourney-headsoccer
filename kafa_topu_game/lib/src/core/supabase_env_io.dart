import 'dart:io' show Platform;

Map<String, String> getSupabaseEnv() {
  return Map.from(Platform.environment);
}
