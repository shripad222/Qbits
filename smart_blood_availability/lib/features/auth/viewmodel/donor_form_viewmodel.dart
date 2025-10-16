import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:smart_blood_availability/features/auth/data/donor_model.dart';
import 'package:smart_blood_availability/core/services/supabase_service.dart';

part 'donor_form_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class DonorFormViewModel extends _$DonorFormViewModel {
  // State: Used to manage loading and error status for the form
  @override
  AsyncValue<void> build() => const AsyncData(null);

  final formKey = GlobalKey<FormState>();

  // Form Fields State
  String _fullName = '';
  String _mobileNumber = '';
  String _emailAddress = '';
  String _password = '';
  DateTime? _dateOfBirth;
  String? _bloodGroup;
  String _location = '';
  double _weight = 0.0;
  DateTime? _dateOfLastDonation;
  Map<String, bool> _healthScreening = {
    'health_issues': false,
    'pregnant': false,
    'high_risk_travel': false,
  };

  void updateField(String field, dynamic value) {
    // This switch is for illustration. In a real app,
    // consider a map or more structured approach to form state.
    switch (field) {
      case 'fullName': _fullName = value as String; break;
      case 'mobileNumber': _mobileNumber = value as String; break;
      case 'emailAddress': _emailAddress = value as String; break;
      case 'password': _password = value as String; break;
      case 'dateOfBirth': _dateOfBirth = value as DateTime?; break;
      case 'bloodGroup': _bloodGroup = value as String?; break;
      case 'location': _location = value as String; break;
      case 'weight': _weight = double.tryParse(value) ?? 0.0; break;
      case 'dateOfLastDonation': _dateOfLastDonation = value as DateTime?; break;
      // Health screening updates would be handled in the UI/separate function
    }
  }

  void updateHealthScreening(String questionKey, bool value) {
    _healthScreening[questionKey] = value;
  }

  /// The main logic for submitting the Donor form data.
  Future<void> registerDonor() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    // Set loading state
    state = const AsyncLoading();

    try {
      final newDonor = DonorModel(
        fullName: _fullName,
        mobileNumber: _mobileNumber,
        emailAddress: _emailAddress,
        password: _password,
        dateOfBirth: _dateOfBirth!,
        bloodGroup: _bloodGroup!,
        location: _location,
        weight: _weight,
        dateOfLastDonation: _dateOfLastDonation,
        healthScreening: _healthScreening,
      );

      final service = ref.read(supabaseServiceProvider);
      await service.insertData('donors', newDonor.toJson());

      // Set success state
      state = const AsyncData(null);
      // Optional: Clear form or navigate
    } catch (e) {
      // Set error state
      state = AsyncError(e, StackTrace.current);
    }
  }
}