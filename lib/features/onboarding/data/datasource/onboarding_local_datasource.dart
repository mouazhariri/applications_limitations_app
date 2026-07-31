import '../../../../core/services/local_storage.dart';

abstract interface class OnboardingLocalDataSource {
  bool isCompleted();
  Future<void> complete();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  bool isCompleted() => _storage.getBool(LocalStorage.onboardingCompleteKey);

  @override
  Future<void> complete() async {
    await _storage.setBool(LocalStorage.onboardingCompleteKey, true);
  }
}
