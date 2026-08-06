class PhoneLimitEntity {
  const PhoneLimitEntity({required this.limit, required this.lockDuration});

  /// How much the whole phone may be used before it is blocked.
  final Duration limit;

  /// How long the phone stays locked once the limit is reached, before the
  /// usage cycle resets and the phone may be used again.
  final Duration lockDuration;
}
