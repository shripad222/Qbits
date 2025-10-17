import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'camp_dataModel.dart'; // path where you saved Camp class

class CampMap extends StatefulWidget {
  const CampMap({super.key});

  @override
  State<CampMap> createState() => _CampMapState();
}

class _CampMapState extends State<CampMap> {
  List<Camp> camps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCamps();
  }

  Future<void> _fetchCamps() async {
    try {
      print('Fetching camps...');
      // final res = await http.get(Uri.parse('http://10.246.223.66:3000/api/camps/get-camps'));
      // BACKEND_URL
      final res = await http.get(Uri.parse('http://10.79.215.218:3000/get-all-camps'));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        final List<dynamic> campList = jsonResponse['camps'];
        print('Number of camps: ${campList.length}');

        final parsedCamps = campList.map((e) {
          print('Parsing camp: $e');
          return Camp.fromJson(e);
        }).toList();

        print('Parsed camps: ${parsedCamps.length}');
        for (var camp in parsedCamps) {
          print('Camp: ${camp.organiser} at ${camp.latitude}, ${camp.longitude}');
        }

        setState(() {
          camps = parsedCamps;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load camps');
      }
    } catch (e) {
      print('Error fetching camps: $e');
      setState(() => isLoading = false);
    }
  }

  // Future<void> _fetchCamps() async {
  //   try {
  //     final res = await http.get(Uri.parse('http://10.246.223.66:3000/api/camps/get-camps'));
  //     if (res.statusCode == 200) {
  //       final jsonResponse = jsonDecode(res.body);
  //       final List<dynamic> campList = jsonResponse['camps'];
  //       setState(() {
  //         camps = campList.map((e) => Camp.fromJson(e)).toList();
  //         isLoading = false;
  //       });
  //     } else {
  //       throw Exception('Failed to load camps');
  //     }
  //   } catch (e) {
  //     print('Error fetching camps: $e');
  //     setState(() => isLoading = false);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    print('Building: isLoading=$isLoading, camps.length=${camps.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Camps (${camps.length})'),
        backgroundColor: Colors.red.shade400,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : camps.isEmpty
          ? const Center(child: Text('No camps found'))
          : SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialZoomLevel: 10,
            initialFocalLatLng: MapLatLng(
              camps.first.latitude,
              camps.first.longitude,
            ),
            zoomPanBehavior: MapZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              enableDoubleTapZooming: true,
              focalLatLng: MapLatLng(
                camps.first.latitude,
                camps.first.longitude,
              ),
              zoomLevel: 10,
              minZoomLevel: 3,
              maxZoomLevel: 18,
            ),
            initialMarkersCount: camps.length,
            markerBuilder: (context, index) {
              final camp = camps[index];
              print('Building marker $index at ${camp.latitude}, ${camp.longitude}');
              return MapMarker(
                latitude: camp.latitude,
                longitude: camp.longitude,
                child: GestureDetector(
                  onTap: () => _showCampDetails(camp),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Blood Donation Camps'),
  //       backgroundColor: Colors.red.shade400,
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : camps.isEmpty
  //         ? const Center(child: Text('No camps found'))
  //         : SfMaps(
  //       layers: [
  //         MapTileLayer(
  //           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //           initialZoomLevel: 10,
  //           initialFocalLatLng: MapLatLng(
  //             camps.isNotEmpty ? camps.first.latitude : 20.5937,
  //             camps.isNotEmpty ? camps.first.longitude : 78.9629,
  //           ),
  //           initialMarkersCount: camps.length,
  //           markerBuilder: (context, index) {
  //             final camp = camps[index];
  //             return MapMarker(
  //               latitude: camp.latitude,
  //               longitude: camp.longitude,
  //               child: GestureDetector(
  //                 onTap: () => _showCampDetails(camp),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color: Colors.red,
  //                     shape: BoxShape.circle,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.red.withOpacity(0.5),
  //                         blurRadius: 8,
  //                         spreadRadius: 2,
  //                       ),
  //                     ],
  //                   ),
  //                   child: const Icon(
  //                     Icons.location_on,
  //                     color: Colors.white,
  //                     size: 36,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  void _showCampDetails(Camp camp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(camp.organiser),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Address: ${camp.address}'),
            Text('🕓 Time: ${camp.time}'),
            Text('📞 Contact: ${camp.contact}'),
            Text('📧 Email: ${camp.email}'),
            const SizedBox(height: 8),
            Text('🩸 ${camp.description}'),
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
