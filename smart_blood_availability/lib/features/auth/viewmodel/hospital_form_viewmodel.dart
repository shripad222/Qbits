import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:smart_blood_availability/features/auth/data/hospital_model.dart';
import 'package:smart_blood_availability/core/services/supabase_service.dart';

part 'hospital_form_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class HospitalFormViewModel extends _$HospitalFormViewModel {
  // State: Used to manage loading and error status for the form
  @override
  AsyncValue<bool> build() => const AsyncData(false); // false = not blood bank user

  final formKey = GlobalKey<FormState>();

  // Form Fields State (Initialize with required fields)
  String _name = '';
  String _licenseNumber = '';
  String? _type; // Government or Private
  String _location = '';
  String _city = '';
  String _stateProvince = '';
  String _pincode = '';
  String _contactNumber = '';
  String _emailAddress = '';
  bool _internalBloodBankAvailable = false; // CRITICAL toggle state 

  // Getters for UI to watch the CRITICAL internal state
  bool get internalBloodBankAvailable => _internalBloodBankAvailable;

  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name': _name = value as String; break;
      case 'licenseNumber': _licenseNumber = value as String; break;
      case 'type': _type = value as String?; break;
      case 'location': _location = value as String; break;
      case 'city': _city = value as String; break;
      case 'stateProvince': _stateProvince = value as String; break;
      case 'pincode': _pincode = value as String; break;
      case 'contactNumber': _contactNumber = value as String; break;
      case 'emailAddress': _emailAddress = value as String; break;
    }
  }

  /// Toggles the state for internal blood bank and updates the AsyncValue state.
  void toggleInternalBloodBank(bool? value) {
    _internalBloodBankAvailable = value ?? false;
    // Notify listeners to update the UI (show/hide Blood Bank form fields)
    state = AsyncData(_internalBloodBankAvailable);
  }

  /// The main logic for submitting the Hospital form data.
  Future<void> registerHospital() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    // Set loading state
    state = const AsyncLoading();

    try {
      final newHospital = HospitalModel(
        name: _name,
        licenseNumber: _licenseNumber,
        type: _type!,
        location: _location,
        city: _city,
        stateProvince: _stateProvince,
        pincode: _pincode,
        contactNumber: _contactNumber,
        emailAddress: _emailAddress,
        internalBloodBankAvailable: _internalBloodBankAvailable,
        // registrationCertificatePath will be handled by a file upload service
        registrationCertificatePath: null, // Placeholder
      );

      final service = ref.read(supabaseServiceProvider);
      await service.insertData('hospitals', newHospital.toJson());

      // Set success state (true/false indicates internal blood bank status)
      state = AsyncData(_internalBloodBankAvailable);
      // NOTE: If _internalBloodBankAvailable is true, the next step would be
      // to submit the Blood Bank form data using its own viewmodel.
    } catch (e) {
      // Set error state
      state = AsyncError(e, StackTrace.current);
    }
  }
}