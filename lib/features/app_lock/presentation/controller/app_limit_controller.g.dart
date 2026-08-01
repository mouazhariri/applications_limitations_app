// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_limit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppLimitController)
final appLimitControllerProvider = AppLimitControllerFamily._();

final class AppLimitControllerProvider
    extends $AsyncNotifierProvider<AppLimitController, AppLimitState> {
  AppLimitControllerProvider._({
    required AppLimitControllerFamily super.from,
    required ({String packageName, String appName}) super.argument,
  }) : super(
         retry: null,
         name: r'appLimitControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appLimitControllerHash();

  @override
  String toString() {
    return r'appLimitControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AppLimitController create() => AppLimitController();

  @override
  bool operator ==(Object other) {
    return other is AppLimitControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appLimitControllerHash() =>
    r'5c634a98950d4966fa462ab1be0ae4fb624c182d';

final class AppLimitControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AppLimitController,
          AsyncValue<AppLimitState>,
          AppLimitState,
          FutureOr<AppLimitState>,
          ({String packageName, String appName})
        > {
  AppLimitControllerFamily._()
    : super(
        retry: null,
        name: r'appLimitControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppLimitControllerProvider call({
    required String packageName,
    required String appName,
  }) => AppLimitControllerProvider._(
    argument: (packageName: packageName, appName: appName),
    from: this,
  );

  @override
  String toString() => r'appLimitControllerProvider';
}

abstract class _$AppLimitController extends $AsyncNotifier<AppLimitState> {
  late final _$args = ref.$arg as ({String packageName, String appName});
  String get packageName => _$args.packageName;
  String get appName => _$args.appName;

  FutureOr<AppLimitState> build({
    required String packageName,
    required String appName,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppLimitState>, AppLimitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppLimitState>, AppLimitState>,
              AsyncValue<AppLimitState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(packageName: _$args.packageName, appName: _$args.appName),
    );
  }
}
