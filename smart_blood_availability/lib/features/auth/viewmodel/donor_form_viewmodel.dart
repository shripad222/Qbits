import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:smart_blood_availability/core/models/lat_lng.dart';
import 'package:geolocator/geolocator.dart';

part 'donor_form_viewmodel.g.dart';

@riverpod
class DonorFormViewModel extends _$DonorFormViewModel {
  // Replace with your actual backend URL
  static const String BACKEND_URL = 'http://10.79.215.218:3000';

  @override
  AsyncValue<void> build() => const AsyncData(null);

  final formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController dobController = TextEditingController();
  final TextEditingController lastDonationController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  String? profileImagePath;
  LatLng? coordinates;

  // Form Fields
  final Map<String, dynamic> formFields = {
    'firstName': '',
    'lastName': '',
    'mobileNumber': '',
    'emailAddress': '',
    'password': '',
    'dateOfBirth': null,
    'bloodGroup': null,
    'location': '',
    'city': '',
    'stateProvince': '',
    'pincode': '',
    'weight': '',
    'dateOfLastDonation': null,
  };

  Map<String, bool> _healthScreening = {
    'chronic_conditions': false,
    'on_regular_medication': false,
    'history_of_transfusion': false,
    'chronic_infectious_disease': false,
    'major_surgery_history': false,
  };

  Map<String, bool> get healthScreening => _healthScreening;

  /// Pick profile image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      profileImagePath = result.files.first.path;
      state = const AsyncData(null);
    }
  }

  /// Geocode address using Nominatim
  Future<void> fetchCoordinatesFromAddress() async {
    final address = formFields['location'] as String;
    if (address.isEmpty) {
      state = AsyncError(Exception('Please enter an address'), StackTrace.current);
      return;
    }

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
          if (addr != null) {
            if (addr['postcode'] != null) {
              pincodeController.text = addr['postcode'].toString();
              formFields['pincode'] = addr['postcode'].toString();
            }
            if (addr['city'] != null) {
              cityController.text = addr['city'].toString();
              formFields['city'] = addr['city'].toString();
            }
            if (addr['state'] != null) {
              stateController.text = addr['state'].toString();
              formFields['stateProvince'] = addr['state'].toString();
            }
          }
        }
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Use device GPS location
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
        final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>?;
        if (addr != null) {
          final street = addr['road'] ?? addr['pedestrian'] ?? '';
          formFields['location'] = street;

          if (addr['postcode'] != null) {
            pincodeController.text = addr['postcode'].toString();
            formFields['pincode'] = addr['postcode'].toString();
          }
          if (addr['city'] != null) {
            cityController.text = addr['city'].toString();
            formFields['city'] = addr['city'].toString();
          }
          if (addr['state'] != null) {
            stateController.text = addr['state'].toString();
            formFields['stateProvince'] = addr['state'].toString();
          }
        }
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void updateField(String field, dynamic value) {
    formFields[field] = value;
    state = const AsyncData(null);
  }

  void updateHealthScreening(String questionKey, bool value) {
    _healthScreening[questionKey] = value;
    state = const AsyncData(null);
  }

  /// Submit donor registration to backend
  Future<void> submitDonorRegistration() async {
    try {

      // if (!formKey.currentState!.validate()) {
      //   throw Exception('Please fill all required fields');
      // }

      state = const AsyncLoading();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$BACKEND_URL/api/auth/add-donor'),
      );

      // Add profile picture if available
      if (profileImagePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_pic',
            profileImagePath!,
          ),
        );
      }

      // Add form fields
      request.fields['first_name'] = formFields['firstName'] ?? '';
      request.fields['last_name'] = formFields['lastName'] ?? '';
      request.fields['email'] = formFields['emailAddress'] ?? '';
      request.fields['mobile_no'] = formFields['mobileNumber'] ?? '';
      request.fields['password'] = formFields['password'] ?? '';
      request.fields['blood_group'] = formFields['bloodGroup'] ?? '';
      request.fields['date_of_last_donation'] =
          formFields['dateOfLastDonation']?.toString() ?? '';

      // Add location as JSON
      final location = {
        'address': formFields['location'] ?? '',
        'city': formFields['city'] ?? '',
        'state': formFields['stateProvince'] ?? '',
        'pincode': formFields['pincode'] ?? '',
      };
      request.fields['location'] = jsonEncode(location);

      // Add live location (coordinates)
      if (coordinates != null) {
        final liveLocation = {
          'latitude': coordinates!.latitude,
          'longitude': coordinates!.longitude,
        };
        request.fields['live_location'] = jsonEncode(liveLocation);
      }

      // Add health screening answers
      request.fields['screening_ques'] = jsonEncode(_healthScreening);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] ?? false) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_mobile', formFields['mobileNumber'] ?? '');
          state = const AsyncData(null);
        } else {
          throw Exception(responseData['error'] ?? 'Registration failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}