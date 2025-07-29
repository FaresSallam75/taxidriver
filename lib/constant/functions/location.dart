// ignore_for_file: strict_top_level_inference

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng? currentLocation;
GoogleMapController? googleMapController;
CameraPosition? cameraPosition;
List<Marker> markers = [];
Set<Polyline> ploylineSet = {};
List<LatLng> polylineCoordinates = [];
StreamSubscription<Position>? positionStream;
List<Placemark> placemarks = [];
String? currentLocationName;
double distanceInMeters = 0;

Future<void> requestPermissionLocation(context) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Location service is disabled. Please enable it."),
        backgroundColor: Colors.red,
      ),
    );
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please give location permission to the app."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "location cannot be accessed without using the app location.",
        ),
        backgroundColor: Colors.red,
      ),
    );
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
    //  exit(0);
  }
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    await getCurrentUserLocation();
  }
}

Future<void> getCurrentUserLocation() async {
  // setting
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );

  currentLocation = LatLng(position.latitude, position.longitude);

  cameraPosition = CameraPosition(
    target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    zoom: 8.0,
  );

  positionStream = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position? position) {
    if (position == null) {
      return;
    }
    markers.add(
      Marker(
        markerId: MarkerId(position.latitude.toString()), //"1"
        position: LatLng(position.latitude, position.longitude),
      ),
    );
    googleMapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  });

  placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  currentLocationName = placemarks[0].locality!;
}
