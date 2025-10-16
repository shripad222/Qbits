import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registration_viewmodel.g.dart';

enum UserRole {
  donor,
  hospital,
  bloodBank,
}

@Riverpod(keepAlive: false)
class RegistrationViewModel extends _$RegistrationViewModel {
  /// The state holds the currently selected user role for the unified registration page.
  @override
  UserRole build() {
    // Default View: The registration page must default to displaying the Donor Registration Form [cite: 10]
    return UserRole.donor;
  }

  void selectRole(UserRole role) {
    // Switching the selector must instantly display the relevant form fields [cite: 11]
    state = role;
  }
}