class HospitalModel {
  final String name;
  final String licenseNumber;
  final String type; // Government or Private
  final String location; // Street Address
  final String city;
  final String stateProvince;
  final String pincode;
  final String contactNumber;
  final String emailAddress;
  final bool internalBloodBankAvailable;
  final String? registrationCertificatePath; // Path or URL after upload

  HospitalModel({
    required this.name,
    required this.licenseNumber,
    required this.type,
    required this.location,
    required this.city,
    required this.stateProvince,
    required this.pincode,
    required this.contactNumber,
    required this.emailAddress,
    required this.internalBloodBankAvailable,
    this.registrationCertificatePath,
  });

  /// Converts the Hospital object into a JSON format suitable for Supabase insertion.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'license_number': licenseNumber,
      'type': type,
      'location': location,
      'city': city,
      'state_province': stateProvince,
      'pincode': pincode,
      'contact_number': contactNumber,
      'email_address': emailAddress,
      'internal_blood_bank_available': internalBloodBankAvailable,
      'registration_certificate_path': registrationCertificatePath,
      'role': 'hospital', // Explicit role assignment
    };
  }
}