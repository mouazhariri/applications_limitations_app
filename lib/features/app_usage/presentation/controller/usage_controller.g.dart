// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UsageController)
final usageControllerProvider = UsageControllerProvider._();

final class UsageControllerProvider
    extends $AsyncNotifierProvider<UsageController, UsageState> {
  UsageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageControllerHash();

  @$internal
  @override
  UsageController create() => UsageController();
}

String _$usageControllerHash() => r'51950c122605839fec6b3cc627566cd76aeb7093';

abstract class _$UsageController extends $AsyncNotifier<UsageState> {
  FutureOr<UsageState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UsageState>, UsageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UsageState>, UsageState>,
              AsyncValue<UsageState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
