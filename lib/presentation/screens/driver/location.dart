// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:async';

import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/showtoast.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLocationScreen extends StatefulWidget {
  const DriverLocationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverLocationScreenState createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen> {
  late DraggableScrollableController _draggableController;
  // double initialChildSize = 0.3;
  bool isExpandedView = false;
  double? distanceInMeters;
  double? distanceInKm;
  String? targetLocationName;
  String? getLatLng;
  LatLng? startLatLng;
  LatLng? endLatLng;
  List<Placemark> targetLocation = [];
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  // List<LatLng> curvedPolylineCoordinates = [];
  Timer? movementTimer;

  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController();
    toController = TextEditingController();
    searchController = TextEditingController();
    fromController.text = currentLocationName ?? fromController.text.trim();
    toController.text = targetLocationName ?? toController.text.trim();
    _draggableController = DraggableScrollableController();
    _draggableController.addListener(() {
      final extent = _draggableController.size;
      if (extent >= 0.6 && !isExpandedView) {
        setState(() {
          isExpandedView = true;
        });
      } else if (extent <= 0.3 && isExpandedView) {
        setState(() {
          isExpandedView = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _draggableController.dispose();
    fromController.dispose();
    toController.dispose();
    searchController.dispose();
    markers.removeWhere((m) => m.markerId.value == 'moving');
    markers.removeWhere((marker) => marker.markerId.value == "1");
    polylineCoordinates.clear();
    ploylineSet.removeWhere((polyline) => polyline.polylineId.value == "1");
    positionStream!.cancel();
    movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                onTap: (LatLng latlng) async {
                  setState(() {
                    markers.removeWhere(
                      (marker) => marker.markerId.value == "1",
                    );
                    polylineCoordinates.clear();
                    ploylineSet.removeWhere(
                      (polyline) => polyline.polylineId.value == "1",
                    );
                  });

                  determinTargetLocation(latlng);
                },
                polylines: ploylineSet,
                markers: markers.toSet(),
                mapType: MapType.normal,
                initialCameraPosition: cameraPosition!,
                onMapCreated: (GoogleMapController controllerMap) {
                  googleMapController = controllerMap;
                },
              ),

          Positioned(
            top: 50,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: MyColors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),

          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _buildCompactContent(scrollController, searchController),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<LatLng?> searchPlace(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        print("loction from search place ===================== $loc");
        return LatLng(loc.latitude, loc.longitude);
      }
    } catch (e) {
      print('Search Error ==================== : $e');
    }
    return null;
  }

  void moveToSearchedPlace(
    String placeName,
    GoogleMapController mapController,
  ) async {
    final LatLng? target = await searchPlace(placeName);
    if (target != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
    } else {
      print("Location not found =================================== ");
    }
  }

  void determinTargetLocation(LatLng latlng) async {
    // here to add new marker (target location)
    markers.add(
      Marker(
        markerId: MarkerId("1"), //latlng.latitude.toString()
        position: LatLng(latlng.latitude, latlng.longitude),
      ),
    );

    getLatLng = latlng.latitude.toString();
    print("getLatLng ===================== $getLatLng");

    // here  current location and target location latitude and longitude
    startLatLng = LatLng(
      currentLocation!.latitude,
      currentLocation!.longitude,
    ); // MY CURRENT LOCATION
    endLatLng = LatLng(latlng.latitude, latlng.longitude); // TARGET LOCATION

    // here to add new polyline & draw it between current location and target location
    polylineCoordinates.add(startLatLng!);
    polylineCoordinates.add(endLatLng!);

    ploylineSet.add(
      Polyline(
        polylineId: PolylineId("1"),
        color: MyColors.secondColor,
        width: 3,
        geodesic: true,
        visible: true,
        patterns: [PatternItem.dash(10), PatternItem.gap(10), PatternItem.dot],
        points: polylineCoordinates,
      ),
    );

    // here to get information about target location name
    targetLocation = await placemarkFromCoordinates(
      latlng.latitude,
      latlng.longitude,
    );
    targetLocationName = targetLocation[0].locality!;
    print("targetLocationName ===================== $targetLocationName");
    print(
      "thoroughfare ===================== ${targetLocation[0].thoroughfare}",
    );

    // Calculate distance in meters
    distanceInMeters = Geolocator.distanceBetween(
      currentLocation!.latitude,
      currentLocation!.longitude,
      latlng.latitude,
      latlng.longitude,
    );
    // Convert to kilometers
    distanceInKm = (distanceInMeters! / 1000);
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCompactContent(
    ScrollController controller,
    TextEditingController searchController,
  ) {
    return ListView(
      controller: controller,
      children: [
        Center(
          child: Text(
            "Set your pickup spot",
            style: meduimStyle.copyWith(color: MyColors.black, fontSize: 15),
          ),
        ),
        Center(
          child: Text(
            "Drag map to move pin",
            style: GoogleFonts.crimsonPro(color: MyColors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: MyColors.grey01,
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 50.0,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: GoogleFonts.crimsonPro(
                color: MyColors.black.withOpacity(0.9),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              prefixIcon: Icon(Icons.radio_button_checked, size: 20.0),
              suffixIcon: IconButton(
                onPressed: () {
                  searchPlace(searchController.text.trim());
                  moveToSearchedPlace(
                    searchController.text.trim(),
                    googleMapController!,
                  );
                },
                icon: Icon(Icons.search, size: 20.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.grey01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              if (startLatLng == null || endLatLng == null) {
                ToastHelper.show("target location cannot be determined.");

                return;
              }
              generateIntermediatePoints(startLatLng!, endLatLng!, 20);

              startTracingMovement();
            },

            child: Text(
              "Trace",
              style: GoogleFonts.crimsonPro(
                fontSize: 17,
                color: MyColors.black.withOpacity(0.9),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void startTracingMovement() {
    if (polylineCoordinates.length < 2) {
      print("Polyline is too short. =================== ");
      return;
    }
    int index = 0;
    movementTimer?.cancel(); // cancel previous movement if any
    movementTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (index >= polylineCoordinates.length) {
        ToastHelper.show("The specified location has been reached.");
        timer.cancel();
        return;
      }

      final LatLng nextPosition = polylineCoordinates[index];

      // Remove old marker and add new one
      markers.removeWhere((m) => m.markerId.value == 'moving');
      markers.add(
        Marker(
          markerId: MarkerId('moving'),
          position: nextPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Moving...'),
        ),
      );

      // Move the camera to the next point
      googleMapController?.animateCamera(CameraUpdate.newLatLng(nextPosition));

      setState(() {});
      index++;
    });
    // ToastHelper.show("The specified location has been reached.");
  }

  void generateIntermediatePoints(LatLng start, LatLng end, int steps) {
    polylineCoordinates.clear();

    for (int i = 0; i <= steps; i++) {
      double lat =
          start.latitude + (end.latitude - start.latitude) * (i / steps);
      double lng =
          start.longitude + (end.longitude - start.longitude) * (i / steps);
      polylineCoordinates.add(LatLng(lat, lng));
    }
  }
}
