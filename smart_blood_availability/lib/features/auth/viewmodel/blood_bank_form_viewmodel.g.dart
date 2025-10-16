// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_bank_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BloodBankFormViewModel)
const bloodBankFormViewModelProvider = BloodBankFormViewModelProvider._();

final class BloodBankFormViewModelProvider
    extends $NotifierProvider<BloodBankFormViewModel, AsyncValue<void>> {
  const BloodBankFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodBankFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodBankFormViewModelHash();

  @$internal
  @override
  BloodBankFormViewModel create() => BloodBankFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$bloodBankFormViewModelHash() =>
    r'816a242ca6aba70252a3e8b5bbfa90e7ba11e8d7';

abstract class _$BloodBankFormViewModel extends $Notifier<AsyncValue<void>> {
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
