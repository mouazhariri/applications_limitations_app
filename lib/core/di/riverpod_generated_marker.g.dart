// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_generated_marker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(architectureMarker)
final architectureMarkerProvider = ArchitectureMarkerProvider._();

final class ArchitectureMarkerProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ArchitectureMarkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'architectureMarkerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$architectureMarkerHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return architectureMarker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$architectureMarkerHash() =>
    r'9d52e5e6d7b33706c6a12391b675665268f36724';
