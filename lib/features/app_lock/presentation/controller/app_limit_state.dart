class AppLimitState {
  const AppLimitState({required this.packageName, required this.appName, this.currentLimit, this.customMinutes = '', this.isSaving = false});

  final String packageName;
  final String appName;
  final Duration? currentLimit;
  final String customMinutes;
  final bool isSaving;

  AppLimitState copyWith({Duration? currentLimit, String? customMinutes, bool? isSaving, bool clearLimit = false}) {
    return AppLimitState(
      packageName: packageName,
      appName: appName,
      currentLimit: clearLimit ? null : currentLimit ?? this.currentLimit,
      customMinutes: customMinutes ?? this.customMinutes,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
