import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists the Supabase session in the platform keychain/keystore instead
/// of the library's default (which doesn't survive app restarts unless a
/// storage implementation is provided) — closes the confirmed gap that
/// logged-in state didn't persist before this was wired up.
class _SecureLocalStorage extends LocalStorage {
  const _SecureLocalStorage();

  static const _storage = FlutterSecureStorage();
  static const _key = 'supabase.auth.token';

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() => _storage.read(key: _key);

  @override
  Future<bool> hasAccessToken() async => (await _storage.read(key: _key)) != null;

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _key, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _key);
}

/// Call once from `main()` before `runApp`.
Future<void> initSupabase() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_ANON_KEY'),
    authOptions: const FlutterAuthClientOptions(
      localStorage: _SecureLocalStorage(),
    ),
  );
}

SupabaseClient get supabase => Supabase.instance.client;
