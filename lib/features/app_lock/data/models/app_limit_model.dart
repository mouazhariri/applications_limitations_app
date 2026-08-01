import '../../domain/entities/app_limit_entity.dart';

class AppLimitModel extends AppLimitEntity {
  const AppLimitModel({required super.packageName, required super.limit});

  Map<String, Object?> toMap() => {'packageName': packageName, 'limitMs': limit.inMilliseconds};
}
