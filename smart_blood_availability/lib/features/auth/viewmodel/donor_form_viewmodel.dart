import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:smart_blood_availability/features/auth/data/donor_model.dart';
import 'package:smart_blood_availability/core/services/supabase_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_blood_availability/core/models/lat_lng.dart';
import 'package:geolocator/geolocator.dart';

part 'donor_form_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class DonorFormViewModel extends _$DonorFormViewModel {
  // State: Used to manage loading and error status for the form
  @override
  AsyncValue<void> build() => const AsyncData(null);

  final formKey = GlobalKey<FormState>();

  // controllers and picked assets
  final TextEditingController dobController = TextEditingController();
  final TextEditingController lastDonationController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  String? profileImagePath;

  // Coordinates (reuse small LatLng defined in hospital viewmodel)
  LatLng? coordinates;

  // Form Fields State
  String _firstName = '';
  String _lastName = '';
  String _mobileNumber = '';
  String _emailAddress = '';
  String _password = '';
  DateTime? _dateOfBirth;
  String? _bloodGroup;
  String _location = '';
  double _weight = 0.0;
  DateTime? _dateOfLastDonation;
  // Permanent / long-term screening questions (keys used by UI)
  Map<String, bool> _healthScreening = {
    'chronic_conditions': false,
    'on_regular_medication': false,
    'history_of_transfusion': false,
    'chronic_infectious_disease': false,
    'major_surgery_history': false,
  };

  Map<String, bool> get healthScreening => _healthScreening;

  List<String> get selectedHealthIssues => _healthScreening.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();

  /// Pick profile image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      profileImagePath = result.files.first.path;
      state = const AsyncData(null);
    }
  }

  /// Uses Nominatim to geocode address and fill coordinates/pincode if present
  Future<void> fetchCoordinatesFromAddress() async {
    final addressParts = <String>[];
    if (_location.isNotEmpty) addressParts.add(_location);
    // Note: city/state may not be available on donor form; include if set via updateField
    addressParts.addAll([_location]);
    final address = addressParts.where((s) => s.isNotEmpty).join(', ');
    if (address.isEmpty) return;

    state = const AsyncLoading();
    try {
      final uri = Uri.parse('https://nominatim.openstreetmap.org/search')
          .replace(
            queryParameters: {
              'q': address,
              'format': 'json',
              'addressdetails': '1',
              'limit': '1',
            },
          );
      final resp = await http.get(
        uri,
        headers: {
          'User-Agent': 'smart_blood_availability_app/1.0 (+email@example.com)',
        },
      );
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body) as List;
        if (data.isNotEmpty) {
          final item = data.first as Map<String, dynamic>;
          final lat = double.tryParse(item['lat'] ?? '0') ?? 0;
          final lon = double.tryParse(item['lon'] ?? '0') ?? 0;
          coordinates = LatLng(latitude: lat, longitude: lon);
          final addr = item['address'] as Map<String, dynamic>?;
          if (addr != null && addr['postcode'] != null) {
            _location = _location; // keep
            pincodeController.text = addr['postcode'].toString();
          }
        }
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Use device GPS to fill address fields (reverse geocode)
  Future<void> useDeviceLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      coordinates = LatLng(latitude: pos.latitude, longitude: pos.longitude);

      final uri = Uri.parse('https://nominatim.openstreetmap.org/reverse')
          .replace(
            queryParameters: {
              'lat': pos.latitude.toString(),
              'lon': pos.longitude.toString(),
              'format': 'json',
              'addressdetails': '1',
            },
          );
      final resp = await http.get(
        uri,
        headers: {
          'User-Agent': 'smart_blood_availability_app/1.0 (+email@example.com)',
        },
      );
      if (resp.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(resp.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>?;
        if (addr != null) {
          _location = addr['road'] ?? addr['pedestrian'] ?? _location;
          pincodeController.text =
              addr['postcode']?.toString() ?? pincodeController.text;
        }
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void updateField(String field, dynamic value) {
    // This switch is for illustration. In a real app,
    // consider a map or more structured approach to form state.
    switch (field) {
      case 'firstName':
        _firstName = value as String;
        break;
      case 'lastName':
        _lastName = value as String;
        break;
      case 'mobileNumber':
        _mobileNumber = value as String;
        break;
      case 'emailAddress':
        _emailAddress = value as String;
        break;
      case 'password':
        _password = value as String;
        break;
      case 'dateOfBirth':
        _dateOfBirth = value as DateTime?;
        break;
      case 'bloodGroup':
        _bloodGroup = value as String?;
        break;
      case 'location':
        _location = value as String;
        break;
      case 'weight':
        _weight = double.tryParse(value) ?? 0.0;
        break;
      case 'dateOfLastDonation':
        _dateOfLastDonation = value as DateTime?;
        break;
      // Health screening updates would be handled in the UI/separate function
    }
  }

  void updateHealthScreening(String questionKey, bool value) {
    _healthScreening[questionKey] = value;
    state = const AsyncData(null); // This line triggers the rebuild
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
        fullName: '${_firstName.trim()} ${_lastName.trim()}'.trim(),
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