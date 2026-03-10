// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgetary_audit_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetaryAuditCtrl)
const budgetaryAuditCtrlProvider = BudgetaryAuditCtrlProvider._();

final class BudgetaryAuditCtrlProvider
    extends $NotifierProvider<BudgetaryAuditCtrl, AuditState> {
  const BudgetaryAuditCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetaryAuditCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetaryAuditCtrlHash();

  @$internal
  @override
  BudgetaryAuditCtrl create() => BudgetaryAuditCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditState>(value),
    );
  }
}

String _$budgetaryAuditCtrlHash() =>
    r'9821784399e6da837707aedafefc5d3f6f1bfe6c';

abstract class _$BudgetaryAuditCtrl extends $Notifier<AuditState> {
  AuditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuditState, AuditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuditState, AuditState>,
              AuditState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
