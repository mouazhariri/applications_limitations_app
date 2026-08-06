// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SecurityController)
final securityControllerProvider = SecurityControllerProvider._();

final class SecurityControllerProvider
    extends $AsyncNotifierProvider<SecurityController, SecurityState> {
  SecurityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityControllerHash();

  @$internal
  @override
  SecurityController create() => SecurityController();
}

String _$securityControllerHash() => r'0061f4e17e4a79dea05be0bd3387e783813d406f';

abstract class _$SecurityController extends $AsyncNotifier<SecurityState> {
  FutureOr<SecurityState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SecurityState>, SecurityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SecurityState>, SecurityState>,
              AsyncValue<SecurityState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
