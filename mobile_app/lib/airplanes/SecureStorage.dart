import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();

  SecureStorage._internal();

  Future<void> save(String key, String value) async {
    await _preferences.setString(key, value);
  }

  Future<String?> load(String key) async {
    return await _preferences.getString(key);
  }
}
