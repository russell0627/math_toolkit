// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersistenceService)
const persistenceServiceProvider = PersistenceServiceProvider._();

final class PersistenceServiceProvider
    extends $NotifierProvider<PersistenceService, void> {
  const PersistenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'persistenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$persistenceServiceHash();

  @$internal
  @override
  PersistenceService create() => PersistenceService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$persistenceServiceHash() =>
    r'cb704c8747b837415a182a9abe6426825a3c70eb';

abstract class _$PersistenceService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
