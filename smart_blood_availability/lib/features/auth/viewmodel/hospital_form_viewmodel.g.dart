// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HospitalFormViewModel)
const hospitalFormViewModelProvider = HospitalFormViewModelProvider._();

final class HospitalFormViewModelProvider
    extends $NotifierProvider<HospitalFormViewModel, AsyncValue<bool>> {
  const HospitalFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hospitalFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hospitalFormViewModelHash();

  @$internal
  @override
  HospitalFormViewModel create() => HospitalFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$hospitalFormViewModelHash() =>
    r'c0e334a301b34bc0038709147209ec77a6e2ca2c';

abstract class _$HospitalFormViewModel extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
