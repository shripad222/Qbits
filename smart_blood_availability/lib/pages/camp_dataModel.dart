class Camp {
  final int id;
  final String organiser;
  final double latitude;
  final double longitude;
  final String address;
  final String description;
  final String contact;
  final String email;
  final String time;

  Camp({
    required this.id,
    required this.organiser,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.contact,
    required this.email,
    required this.time,
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final coordinates = location['coordinates'] ?? {};
    return Camp(
      id: json['id'] ?? 0,
      organiser: json['organiser'] ?? 'Unknown',
      latitude: ((coordinates['latitude'] ?? 0) as num).toDouble(),
      longitude: ((coordinates['longitude'] ?? 0) as num).toDouble(),
      address: location['address'] ?? 'N/A',
      description: json['description'] ?? 'No description',
      contact: json['contact_information'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      time: json['time'] ?? 'N/A',
    );
  }
}
