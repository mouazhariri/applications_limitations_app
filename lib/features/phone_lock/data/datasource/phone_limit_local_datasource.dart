import 'package:applications_limitations/src/core/services/local_storage.dart';

abstract interface class PhoneLimitLocalDataSource {
  Duration getLimit();
  Future<void> setLimit(Duration limit);

  /// How long the phone stays locked once the daily limit is reached.
  Duration getLockDuration();
  Future<void> setLockDuration(Duration lockDuration);

  Future<void> reset();
}

class PhoneLimitLocalDataSourceImpl implements PhoneLimitLocalDataSource {
  PhoneLimitLocalDataSourceImpl(this._storage);
  final LocalStorage _storage;

  @override
  Duration getLimit() => Duration(milliseconds: _storage.getInt(LocalStorage.phoneLimitMsKey, fallback: const Duration(hours: 2).inMilliseconds));

  @override
  Future<void> setLimit(Duration limit) async {
    await _storage.setInt(LocalStorage.phoneLimitMsKey, limit.inMilliseconds);
  }

  @override
  Duration getLockDuration() => Duration(milliseconds: _storage.getInt(LocalStorage.phoneLockMsKey, fallback: const Duration(hours: 2).inMilliseconds));

  @override
  Future<void> setLockDuration(Duration lockDuration) async {
    await _storage.setInt(LocalStorage.phoneLockMsKey, lockDuration.inMilliseconds);
  }

  @override
  Future<void> reset() async {
    await _storage.remove(LocalStorage.phoneLimitMsKey);
    await _storage.remove(LocalStorage.phoneLockMsKey);
  }
}
