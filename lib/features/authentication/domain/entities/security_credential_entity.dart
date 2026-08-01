enum SecurityMode { pin, pattern }

class SecurityCredentialEntity {
  const SecurityCredentialEntity({required this.mode, required this.secret});

  final SecurityMode mode;
  final String secret;
}
