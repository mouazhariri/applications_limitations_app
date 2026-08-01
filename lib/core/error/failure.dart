class Failure {
  const Failure({required this.message, this.code, this.exception});

  final String message;
  final String? code;
  final Object? exception;
}
