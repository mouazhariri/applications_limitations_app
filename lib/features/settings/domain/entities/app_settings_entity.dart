class AppSettingsEntity {
  const AppSettingsEntity({required this.languageCode, required this.themeMode, required this.protectionEnabled});

  final String languageCode;
  final String themeMode;
  final bool protectionEnabled;
}
