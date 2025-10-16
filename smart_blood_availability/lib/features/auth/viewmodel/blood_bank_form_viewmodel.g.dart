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
    extends $NotifierProvider<BloodBankFormViewModel, BloodBankFormState> {
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
  Override overrideWithValue(BloodBankFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BloodBankFormState>(value),
    );
  }
}

String _$bloodBankFormViewModelHash() =>
    r'5780df7e025368fdbb19920d5d135b18eadb1bca';

abstract class _$BloodBankFormViewModel extends $Notifier<BloodBankFormState> {
  BloodBankFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BloodBankFormState, BloodBankFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BloodBankFormState, BloodBankFormState>,
              BloodBankFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
