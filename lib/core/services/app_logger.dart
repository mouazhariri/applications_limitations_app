import 'dart:developer' as developer;

abstract interface class Logger {
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warning(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
}

class AppLogger implements Logger {
  const AppLogger();

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'PhoneLimiter', level: 800, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'PhoneLimiter', level: 900, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'PhoneLimiter', level: 1000, error: error, stackTrace: stackTrace);
  }
}
