import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Set<Marker> markers = {};

  Future moveToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are Disabled");
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location Permission denied");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permission denied forever");
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude),
        zoom: 20),
      ),
    );
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId("Current Location"),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  GoogleMapController? mapController;
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(10.5241, 76.2121),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: moveToCurrentLocation,
        child: Icon(Icons.location_searching_rounded, color: Colors.red),
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: markers,
      ),
    );
  }
}
