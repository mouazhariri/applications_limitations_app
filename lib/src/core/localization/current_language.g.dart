// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_language.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentLanguage)
final currentLanguageProvider = CurrentLanguageProvider._();

final class CurrentLanguageProvider
    extends $NotifierProvider<CurrentLanguage, String> {
  CurrentLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLanguageHash();

  @$internal
  @override
  CurrentLanguage create() => CurrentLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentLanguageHash() => r'55520ef7ef55c6d6467b518746bca4e37c024ece';

abstract class _$CurrentLanguage extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
