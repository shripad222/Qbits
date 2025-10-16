class DonorModel {
  final String fullName;
  final String mobileNumber;
  final String emailAddress;
  final String password;
  final DateTime dateOfBirth;
  final String bloodGroup;
  final String location;
  final double weight;
  final DateTime? dateOfLastDonation;
  final Map<String, bool> healthScreening;

  DonorModel({
    required this.fullName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.password,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.location,
    required this.weight,
    this.dateOfLastDonation,
    required this.healthScreening,
  });

  /// Converts the Donor object into a JSON format suitable for Supabase insertion.
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'email_address': emailAddress,
      // NOTE: Password should be hashed/handled by Supabase Auth service in a real app
      // For now, we assume simple Auth flow.
      'password': password,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'blood_group': bloodGroup,
      'location': location,
      'weight_kg': weight,
      'last_donation_date': dateOfLastDonation?.toIso8601String(),
      'health_screening_json': healthScreening, // Stored as JSONB in Supabase
      'role': 'donor', // Explicit role assignment
    };
  }
}