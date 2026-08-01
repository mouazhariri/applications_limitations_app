import '../../domain/entities/security_credential_entity.dart';

class SecurityState {
  const SecurityState({this.mode = SecurityMode.pin, this.secret = '', this.confirmSecret = '', this.isSaving = false, this.errorKey});

  final SecurityMode mode;
  final String secret;
  final String confirmSecret;
  final bool isSaving;
  final String? errorKey;

  bool get canSave => secret.replaceAll('-', '').length >= 4 && secret == confirmSecret;

  SecurityState copyWith({SecurityMode? mode, String? secret, String? confirmSecret, bool? isSaving, String? errorKey, bool clearError = false}) {
    return SecurityState(
      mode: mode ?? this.mode,
      secret: secret ?? this.secret,
      confirmSecret: confirmSecret ?? this.confirmSecret,
      isSaving: isSaving ?? this.isSaving,
      errorKey: clearError ? null : errorKey ?? this.errorKey,
    );
  }
}
