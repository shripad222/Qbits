import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'blood_bank_form_viewmodel.g.dart';

class BloodBankFormState {
  final String name;
  final String parentOrganization;
  final String licenseNumber;
  final List<String> accreditations;
  final String? registrationPdfPath;
  final String location;
  final String city;
  final String stateProvince;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String contactNumber;
  final String contact24x7;
  final String email;
  final String operatingHours;
  final String servicesText;
  final bool organizesDonationCamp;
  final String serviceArea;
  final String? profileImagePath;

  BloodBankFormState({
    this.name = '',
    this.parentOrganization = '',
    this.licenseNumber = '',
    this.accreditations = const [],
    this.registrationPdfPath,
    this.location = '',
    this.city = '',
    this.stateProvince = '',
    this.pincode = '',
    this.latitude,
    this.longitude,
    this.contactNumber = '',
    this.contact24x7 = '',
    this.email = '',
    this.operatingHours = '',
    this.servicesText = '',
    this.organizesDonationCamp = false,
    this.serviceArea = '',
    this.profileImagePath,
  });

  BloodBankFormState copyWith({
    String? name,
    String? parentOrganization,
    String? licenseNumber,
    List<String>? accreditations,
    String? registrationPdfPath,
    String? location,
    String? city,
    String? stateProvince,
    String? pincode,
    double? latitude,
    double? longitude,
    String? contactNumber,
    String? contact24x7,
    String? email,
    String? operatingHours,
    String? servicesText,
    bool? organizesDonationCamp,
    String? serviceArea,
    String? profileImagePath,
  }) {
    return BloodBankFormState(
      name: name ?? this.name,
      parentOrganization: parentOrganization ?? this.parentOrganization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      accreditations: accreditations ?? this.accreditations,
      registrationPdfPath: registrationPdfPath ?? this.registrationPdfPath,
      location: location ?? this.location,
      city: city ?? this.city,
      stateProvince: stateProvince ?? this.stateProvince,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactNumber: contactNumber ?? this.contactNumber,
      contact24x7: contact24x7 ?? this.contact24x7,
      email: email ?? this.email,
      operatingHours: operatingHours ?? this.operatingHours,
      servicesText: servicesText ?? this.servicesText,
      organizesDonationCamp: organizesDonationCamp ?? this.organizesDonationCamp,
      serviceArea: serviceArea ?? this.serviceArea,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}

@riverpod
class BloodBankFormViewModel extends _$BloodBankFormViewModel {
  @override
  BloodBankFormState build() => BloodBankFormState();

  final formKey = GlobalKey<FormState>();

  List<String> get services {
    if (state.servicesText.isEmpty) return [];
    return state.servicesText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<String> get accreditations => state.accreditations;
  bool get organizesDonationCamp => state.organizesDonationCamp;
  String? get profileImagePath => state.profileImagePath;
  String? get registrationPdfPath => state.registrationPdfPath;
  double? get latitude => state.latitude;
  double? get longitude => state.longitude;

  Future<void> pickProfileImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null && res.files.isNotEmpty) {
      state = state.copyWith(profileImagePath: res.files.first.path);
    }
  }

  Future<void> pickPdf() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (res != null && res.files.isNotEmpty) {
      state = state.copyWith(registrationPdfPath: res.files.first.path);
    }
  }

  void toggleAccreditation(String acc, bool enabled) {
    final currentAccreditations = List<String>.from(state.accreditations);
    if (enabled) {
      if (!currentAccreditations.contains(acc)) {
        currentAccreditations.add(acc);
      }
    } else {
      currentAccreditations.remove(acc);
    }
    state = state.copyWith(accreditations: currentAccreditations);
  }

  void setOrganizesDonationCamp(bool v) {
    state = state.copyWith(organizesDonationCamp: v);
  }

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'name':
        state = state.copyWith(name: value as String);
        break;
      case 'parentOrganization':
        state = state.copyWith(parentOrganization: value as String);
        break;
      case 'licenseNumber':
        state = state.copyWith(licenseNumber: value as String);
        break;
      case 'location':
        state = state.copyWith(location: value as String);
        break;
      case 'city':
        state = state.copyWith(city: value as String);
        break;
      case 'stateProvince':
        state = state.copyWith(stateProvince: value as String);
        break;
      case 'pincode':
        state = state.copyWith(pincode: value as String);
        break;
      case 'contactNumber':
        state = state.copyWith(contactNumber: value as String);
        break;
      case 'contact24x7':
        state = state.copyWith(contact24x7: value as String);
        break;
      case 'email':
        state = state.copyWith(email: value as String);
        break;
      case 'operatingHours':
        state = state.copyWith(operatingHours: value as String);
        break;
      case 'serviceArea':
        state = state.copyWith(serviceArea: value as String);
        break;
      case 'servicesText':
        state = state.copyWith(servicesText: value as String);
        break;
    }
  }

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

      print('📍 Latitude: ${pos.latitude}');
      print('📍 Longitude: ${pos.longitude}');

      state = state.copyWith(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

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
          state = state.copyWith(
            location: addr['road'] ?? state.location,
            city: addr['city'] ?? state.city,
            stateProvince: addr['state'] ?? state.stateProvince,
            pincode: addr['postcode'] != null
                ? addr['postcode'].toString()
                : state.pincode,
          );
        }
      }
    } catch (e) {
      print('❌ Error getting location: $e');
    }
  }
}