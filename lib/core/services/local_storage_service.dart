import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyUid = 'user_uid';
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';
  static const _keyRole = 'user_role';

  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String role,
  }) async {
    await _prefs.setString(_keyUid, uid);
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyRole, role);
  }

  Map<String, String>? getUser() {
    final uid = _prefs.getString(_keyUid);
    if (uid == null) return null;
    return {
      'uid': uid,
      'name': _prefs.getString(_keyName) ?? '',
      'email': _prefs.getString(_keyEmail) ?? '',
      'role': _prefs.getString(_keyRole) ?? 'learner',
    };
  }

  Future<void> clearUser() async {
    await _prefs.remove(_keyUid);
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyRole);
  }
}