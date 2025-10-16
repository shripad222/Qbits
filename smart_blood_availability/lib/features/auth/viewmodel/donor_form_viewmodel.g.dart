// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DonorFormViewModel)
const donorFormViewModelProvider = DonorFormViewModelProvider._();

final class DonorFormViewModelProvider
    extends $NotifierProvider<DonorFormViewModel, AsyncValue<void>> {
  const DonorFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'donorFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$donorFormViewModelHash();

  @$internal
  @override
  DonorFormViewModel create() => DonorFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$donorFormViewModelHash() =>
    r'1232a2c9ec39cab211cc63939dad3e8d812c6df6';

abstract class _$DonorFormViewModel extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
