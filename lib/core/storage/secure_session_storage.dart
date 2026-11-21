import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'secure_storage.dart';

class SecureSessionStorage extends sb.LocalStorage {
  SecureSessionStorage();

  final _storage = SecureStorage();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async =>
      await _storage.read(SecureStorageKey.supabaseSession) != null;

  @override
  Future<String?> accessToken() =>
      _storage.read(SecureStorageKey.supabaseSession);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(SecureStorageKey.supabaseSession, persistSessionString);

  @override
  Future<void> removePersistedSession() =>
      _storage.delete(SecureStorageKey.supabaseSession);
}
