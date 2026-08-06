class PhoneLimitState {
  const PhoneLimitState({
    required this.currentLimit,
    required this.currentLockDuration,
    this.customMinutes = '',
    this.customLockMinutes = '',
    this.isSaving = false,
  });

  final Duration currentLimit;
  final Duration currentLockDuration;
  final String customMinutes;
  final String customLockMinutes;
  final bool isSaving;

  PhoneLimitState copyWith({
    Duration? currentLimit,
    Duration? currentLockDuration,
    String? customMinutes,
    String? customLockMinutes,
    bool? isSaving,
  }) {
    return PhoneLimitState(
      currentLimit: currentLimit ?? this.currentLimit,
      currentLockDuration: currentLockDuration ?? this.currentLockDuration,
      customMinutes: customMinutes ?? this.customMinutes,
      customLockMinutes: customLockMinutes ?? this.customLockMinutes,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
