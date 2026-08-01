class PhoneLimitState {
  const PhoneLimitState({required this.currentLimit, this.customMinutes = '', this.isSaving = false});

  final Duration currentLimit;
  final String customMinutes;
  final bool isSaving;

  PhoneLimitState copyWith({Duration? currentLimit, String? customMinutes, bool? isSaving}) {
    return PhoneLimitState(
      currentLimit: currentLimit ?? this.currentLimit,
      customMinutes: customMinutes ?? this.customMinutes,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
