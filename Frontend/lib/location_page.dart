import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  final LatLng defaultLocation = const LatLng(18.5204, 73.8567);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC),
      appBar: AppBar(
        title: const Text('Your Location'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Current Location & Nearby Safe Zones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: defaultLocation,
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('current'),
                  position: defaultLocation,
                  infoWindow: const InfoWindow(title: 'You are here'),
                ),
                Marker(
                  markerId: const MarkerId('shelter1'),
                  position: LatLng(18.525, 73.85),
                  infoWindow: const InfoWindow(title: 'Shelter: City Hall'),
                ),
                Marker(
                  markerId: const MarkerId('shelter2'),
                  position: LatLng(18.515, 73.86),
                  infoWindow: const InfoWindow(title: 'Shelter: School Gym'),
                ),
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location refreshed')),
              );
            },
            icon: const Icon(Icons.location_searching),
            label: const Text('Refresh Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}