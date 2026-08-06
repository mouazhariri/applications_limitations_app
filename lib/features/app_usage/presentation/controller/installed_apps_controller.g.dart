// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installed_apps_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InstalledAppsController)
final installedAppsControllerProvider = InstalledAppsControllerProvider._();

final class InstalledAppsControllerProvider
    extends $AsyncNotifierProvider<InstalledAppsController, InstalledAppsState> {
  InstalledAppsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedAppsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedAppsControllerHash();

  @$internal
  @override
  InstalledAppsController create() => InstalledAppsController();
}

String _$installedAppsControllerHash() => r'04cb86140aece86c54fc881f6d07eb04aef5c0d3';

abstract class _$InstalledAppsController extends $AsyncNotifier<InstalledAppsState> {
  FutureOr<InstalledAppsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<InstalledAppsState>, InstalledAppsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<InstalledAppsState>, InstalledAppsState>,
              AsyncValue<InstalledAppsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
