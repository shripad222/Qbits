// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegistrationViewModel)
const registrationViewModelProvider = RegistrationViewModelProvider._();

final class RegistrationViewModelProvider
    extends $NotifierProvider<RegistrationViewModel, UserRole> {
  const RegistrationViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrationViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrationViewModelHash();

  @$internal
  @override
  RegistrationViewModel create() => RegistrationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRole>(value),
    );
  }
}

String _$registrationViewModelHash() =>
    r'3419e7bd7441090ac2a792bdad7a4ace2d759c1f';

abstract class _$RegistrationViewModel extends $Notifier<UserRole> {
  UserRole build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserRole, UserRole>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserRole, UserRole>,
              UserRole,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
