import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:smart_blood_availability/core/services/supabase_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_blood_availability/core/models/lat_lng.dart';
import 'package:geolocator/geolocator.dart';

part 'hospital_form_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class HospitalFormViewModel extends _$HospitalFormViewModel {
  // State: Used to manage loading and error status for the form
  @override
  AsyncValue<bool> build() => const AsyncData(false); // false = not blood bank user

  final formKey = GlobalKey<FormState>();

  // Controllers and picked asset paths
  final TextEditingController pincodeController = TextEditingController();
  String? hospitalImagePath;
  String? registrationPdfPath;

  // Simple coordinates holder
  LatLng? coordinates;

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

  /// Picks an image file for the hospital picture and stores the path.
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      hospitalImagePath = result.files.first.path;
      // notify UI
      state = AsyncData(_internalBloodBankAvailable);
    }
  }

  /// Picks a PDF registration certificate and stores the path.
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      registrationPdfPath = result.files.first.path;
      state = AsyncData(_internalBloodBankAvailable);
    }
  }

  /// Uses Nominatim (OpenStreetMap) to geocode the assembled address and
  /// populate [coordinates] and attempt to fill the pincode if available.
  Future<void> fetchCoordinatesFromAddress() async {
    final addressParts = <String>[];
    if (_location.isNotEmpty) addressParts.add(_location);
    if (_city.isNotEmpty) addressParts.add(_city);
    if (_stateProvince.isNotEmpty) addressParts.add(_stateProvince);

    final address = addressParts.join(', ');
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

          // Try to extract pincode from address details
          final addr = item['address'] as Map<String, dynamic>?;
          if (addr != null && addr['postcode'] != null) {
            _pincode = addr['postcode'].toString();
            pincodeController.text = _pincode;
          }
          state = AsyncData(_internalBloodBankAvailable);
          return;
        }
      }
      state = AsyncData(_internalBloodBankAvailable);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Use device GPS to fetch current location, reverse-geocode to address
  /// and populate the location/city/state/pincode fields.
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

      // Reverse geocode using Nominatim
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
          _city = addr['city'] ?? addr['town'] ?? addr['village'] ?? _city;
          _stateProvince = addr['state'] ?? _stateProvince;
          if (addr['postcode'] != null) {
            _pincode = addr['postcode'].toString();
            pincodeController.text = _pincode;
          }
        }
      }
      state = AsyncData(_internalBloodBankAvailable);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // Getters for UI to watch the CRITICAL internal state
  bool get internalBloodBankAvailable => _internalBloodBankAvailable;

  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name':
        _name = value as String;
        break;
      case 'licenseNumber':
        _licenseNumber = value as String;
        break;
      case 'type':
        _type = value as String?;
        break;
      case 'location':
        _location = value as String;
        break;
      case 'city':
        _city = value as String;
        break;
      case 'stateProvince':
        _stateProvince = value as String;
        break;
      case 'pincode':
        _pincode = value as String;
        break;
      case 'contactNumber':
        _contactNumber = value as String;
        break;
      case 'emailAddress':
        _emailAddress = value as String;
        break;
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
      // Map current fields to the user's 'hospital' table schema
      final hospitalRow = <String, dynamic>{
        'name': _name,
        'lic_no': _licenseNumber,
        'type': _type ?? '',
        // store location as JSONB (street, city, state, pincode)
        'location': {
          'street': _location,
          'city': _city,
          'state': _stateProvince,
          'pincode': _pincode,
        },
        'contact_no': _contactNumber,
        'email': _emailAddress,
        'internal_bb': _internalBloodBankAvailable ? 'yes' : 'no',
        // profile_pic/scanned_copy_url will be updated later if files present
      };

      final service = ref.read(supabaseServiceProvider);
      final inserted = await service.insertData('hospital', hospitalRow);

      // Supabase returns a list of inserted rows; extract the id
      int? hospitalId;
      if (inserted is List && inserted.isNotEmpty) {
        final first = inserted.first as Map<String, dynamic>;
        hospitalId = first['id'] as int?;
      } else if (inserted is Map<String, dynamic>) {
        hospitalId = inserted['id'] as int?;
      }

      // If PDF registration scanned copy is present, insert into hospital_reg_scan
      if (registrationPdfPath != null && hospitalId != null) {
        final scanRow = {
          'hospital_id': hospitalId,
          'scan_url': registrationPdfPath,
          'uploaded_at': DateTime.now().toIso8601String(),
        };
        await service.insertData('hospital_reg_scan', scanRow);

        // update hospital scanned_copy_url field
        await service.updateData(
          'hospital',
          {'scanned_copy_url': registrationPdfPath},
          'id',
          hospitalId,
        );
      }

      // If profile image provided, update hospital.profile_pic
      if (hospitalImagePath != null && hospitalId != null) {
        await service.updateData(
          'hospital',
          {'profile_pic': hospitalImagePath},
          'id',
          hospitalId,
        );
      }

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
