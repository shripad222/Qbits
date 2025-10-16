import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'blood_bank_form_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class BloodBankFormViewModel extends _$BloodBankFormViewModel {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  final formKey = GlobalKey<FormState>();

  // fields
  String name = '';
  String parentOrganization = '';
  String licenseNumber = '';
  List<String> accreditations = [];
  String? registrationPdfPath;
  String location = '';
  String city = '';
  String stateProvince = '';
  String pincode = '';
  double? latitude;
  double? longitude;
  String contactNumber = '';
  String contact24x7 = '';
  String email = '';
  String operatingHours = '';
  List<String> services = []; // e.g., whole blood, plasma
  bool organizesDonationCamp = false;
  String serviceArea = '';
  String? profileImagePath;

  Future<void> pickProfileImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null && res.files.isNotEmpty) {
      profileImagePath = res.files.first.path;
      state = const AsyncData(null);
    }
  }

  Future<void> pickPdf() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (res != null && res.files.isNotEmpty) {
      registrationPdfPath = res.files.first.path;
      state = const AsyncData(null);
    }
  }

  void toggleService(String service, bool enabled) {
    if (enabled) {
      if (!services.contains(service)) services.add(service);
    } else {
      services.remove(service);
    }
    state = const AsyncData(null);
  }

  void toggleAccreditation(String acc, bool enabled) {
    if (enabled) {
      if (!accreditations.contains(acc)) accreditations.add(acc);
    } else {
      accreditations.remove(acc);
    }
    state = const AsyncData(null);
  }

  void setOrganizesDonationCamp(bool v) {
    organizesDonationCamp = v;
    state = const AsyncData(null);
  }

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'name':
        name = value as String;
        break;
      case 'parentOrganization':
        parentOrganization = value as String;
        break;
      case 'licenseNumber':
        licenseNumber = value as String;
        break;
      case 'location':
        location = value as String;
        break;
      case 'city':
        city = value as String;
        break;
      case 'stateProvince':
        stateProvince = value as String;
        break;
      case 'pincode':
        pincode = value as String;
        break;
      case 'contactNumber':
        contactNumber = value as String;
        break;
      case 'contact24x7':
        contact24x7 = value as String;
        break;
      case 'email':
        email = value as String;
        break;
      case 'operatingHours':
        operatingHours = value as String;
        break;
      case 'serviceArea':
        serviceArea = value as String;
        break;
    }
  }

  Future<void> useDeviceLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw Exception('Location permission denied');
      }
      if (permission == LocationPermission.deniedForever)
        throw Exception('Location permission permanently denied');
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      latitude = pos.latitude;
      longitude = pos.longitude;

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
          location = addr['road'] ?? location;
          city = addr['city'] ?? city;
          stateProvince = addr['state'] ?? stateProvince;
          if (addr['postcode'] != null) pincode = addr['postcode'].toString();
        }
      }
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
