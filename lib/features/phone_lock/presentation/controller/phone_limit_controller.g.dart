// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_limit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhoneLimitController)
final phoneLimitControllerProvider = PhoneLimitControllerProvider._();

final class PhoneLimitControllerProvider
    extends $AsyncNotifierProvider<PhoneLimitController, PhoneLimitState> {
  PhoneLimitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneLimitControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneLimitControllerHash();

  @$internal
  @override
  PhoneLimitController create() => PhoneLimitController();
}

String _$phoneLimitControllerHash() => r'a1ab3dcceb49f37b84065a30d66c94204510c7ee';

abstract class _$PhoneLimitController extends $AsyncNotifier<PhoneLimitState> {
  FutureOr<PhoneLimitState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PhoneLimitState>, PhoneLimitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PhoneLimitState>, PhoneLimitState>,
              AsyncValue<PhoneLimitState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
