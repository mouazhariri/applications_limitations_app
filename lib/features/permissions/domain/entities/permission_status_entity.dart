class PermissionStatusEntity {
  const PermissionStatusEntity({
    required this.key,
    required this.titleKey,
    required this.descriptionKey,
    required this.isGranted,
    required this.isRequired,
  });

  final String key;
  final String titleKey;
  final String descriptionKey;
  final bool isGranted;
  final bool isRequired;

  PermissionStatusEntity copyWith({bool? isGranted}) {
    return PermissionStatusEntity(
      key: key,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      isGranted: isGranted ?? this.isGranted,
      isRequired: isRequired,
    );
  }
}
