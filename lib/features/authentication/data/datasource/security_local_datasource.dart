import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'package:applications_limitations/src/core/services/local_storage.dart';
import '../../domain/entities/security_credential_entity.dart';

abstract interface class SecurityLocalDataSource {
  bool hasCredential();
  Future<void> saveCredential(SecurityCredentialEntity credential);
  Future<bool> verify(String secret);
  SecurityMode? getMode();
  Future<void> clear();
}

class SecurityLocalDataSourceImpl implements SecurityLocalDataSource {
  SecurityLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  bool hasCredential() => (_storage.getString(LocalStorage.securityPinHashKey) ?? '').isNotEmpty;

  @override
  SecurityMode? getMode() {
    final mode = _storage.getString(LocalStorage.securityModeKey);
    return switch (mode) {
      'pattern' => SecurityMode.pattern,
      'pin' => SecurityMode.pin,
      _ => null,
    };
  }

  @override
  Future<void> saveCredential(SecurityCredentialEntity credential) async {
    final salt = _createSalt();
    await _storage.setString(LocalStorage.securityPinSaltKey, salt);
    await _storage.setString(LocalStorage.securityPinHashKey, _hash(credential.secret, salt));
    await _storage.setString(LocalStorage.securityModeKey, credential.mode.name);
  }

  @override
  Future<bool> verify(String secret) async {
    final salt = _storage.getString(LocalStorage.securityPinSaltKey);
    final expectedHash = _storage.getString(LocalStorage.securityPinHashKey);
    if (salt == null || expectedHash == null) return false;
    return _hash(secret, salt) == expectedHash;
  }

  @override
  Future<void> clear() async {
    await _storage.remove(LocalStorage.securityPinSaltKey);
    await _storage.remove(LocalStorage.securityPinHashKey);
    await _storage.remove(LocalStorage.securityModeKey);
  }

  String _createSalt() {
    final random = Random.secure();
    final values = List<int>.generate(24, (_) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  String _hash(String secret, String salt) {
    final normalizedSecret = secret.replaceAll('-', '').trim();
    final bytes = utf8.encode('$salt:$normalizedSecret');
    return sha256.convert(bytes).toString();
  }
}
