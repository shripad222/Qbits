import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BloodBankLocation {
  final double latitude;
  final double longitude;
  final String name;
  final String? phone;

  BloodBankLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.phone,
  });
}

class BloodBankMap extends StatefulWidget {
  final String area;
  final String amenityType;

  const BloodBankMap({
    Key? key,
    this.area = "Goa",
    this.amenityType = "blood_bank",
  }) : super(key: key);

  @override
  State<BloodBankMap> createState() => _BloodBankMapState();
}

class _BloodBankMapState extends State<BloodBankMap> {
  List<BloodBankLocation> locations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBloodBanks();
  }

  Future<void> _fetchBloodBanks() async {
    final url = Uri.parse(
        'https://overpass-api.de/api/interpreter?data=[out:json][timeout:300];area["name"="${widget.area}"]->.a;(node["amenity"="${widget.amenityType}"](area.a););out center;');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elements = data['elements'] as List<dynamic>;
        _parseLocations(elements);
      }
    } catch (e) {
      print('Error fetching locations: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _parseLocations(List elements) {
    final parsed = <BloodBankLocation>[];
    for (var e in elements) {
      if (e['lat'] != null && e['lon'] != null) {
        parsed.add(BloodBankLocation(
          latitude: (e['lat'] as num).toDouble(),
          longitude: (e['lon'] as num).toDouble(),
          name: e['tags']?['name'] ?? 'Unknown',
          phone: e['tags']?['contact:phone'] ?? e['tags']?['contact:mobile'],
        ));
      }
    }
    setState(() => locations = parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Banks in Goa"),
        backgroundColor: Colors.red.shade400,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : locations.isEmpty
          ? const Center(child: Text("No locations found"))
          : SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialFocalLatLng: MapLatLng(15.2993, 73.8243),
            initialZoomLevel: 10,
            zoomPanBehavior: MapZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
            ),
            initialMarkersCount: locations.length, // required
            markerBuilder: (context, index) {
              final loc = locations[index];
              return MapMarker(
                latitude: loc.latitude,
                longitude: loc.longitude,
                child: GestureDetector(
                  onTap: () => _showLocationDialog(loc),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BloodBankLocation loc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${loc.phone ?? "N/A"}'),
            const SizedBox(height: 8),
            Text('Lat: ${loc.latitude}\nLon: ${loc.longitude}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
