// ignore_for_file: deprecated_member_use, avoid_print

import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
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

    markers.removeWhere((marker) => marker.markerId.value == "1");
    polylineCoordinates.clear();
    ploylineSet.removeWhere((polyline) => polyline.polylineId.value == "1");

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
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MainHome()),
                  // );
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
                child:
                    isExpandedView
                        ? _buildExpandedContent(scrollController)
                        : _buildCompactContent(
                          scrollController,
                          searchController,
                        ),
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
            onPressed: () {},
            child: Text(
              "Confirm pickup",
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

  Widget _buildExpandedContent(ScrollController controller) {
    return Form(
      key: formState,
      child: ListView(
        controller: controller,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: MyColors.black),
                onPressed: () {
                  // _draggableController.animateTo(
                  //   0.5,
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                },
              ),
              SizedBox(width: 90.0),
              Text(
                "Plan your ride",
                style: GoogleFonts.crimsonPro(
                  fontSize: 18,
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Chip(
                avatar: Icon(Icons.watch_later_rounded, color: MyColors.black),
                label: Text("Pickup now"),
              ),
              SizedBox(width: 10),
              Chip(
                avatar: Icon(Icons.person, color: MyColors.black),
                label: Text("For me"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTextFormFieldLocation(
                  labelText:
                      currentLocationName ??
                      // fromController.text.trim() ??
                      "Pickup Location",
                  onPressedPrefix: () {
                    setState(() {
                      currentLocationName = placemarks[0].locality!;
                    });
                  },
                  onPressedSuffix: () {
                    setState(() {
                      searchController.clear();
                      currentLocationName = "Pickup Location";
                      fromController.text = "";
                      print(
                        "currentLocationName after press = $currentLocationName",
                      );
                    });
                  },
                  controller: fromController,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
                Divider(),
                customTextFormFieldLocation(
                  labelText: targetLocationName ?? "Where to?",
                  onPressedPrefix: () {
                    setState(() {
                      targetLocationName = targetLocationName ?? "Where to?";
                    });
                  },
                  onPressedSuffix: () {
                    searchController.clear();
                    targetLocationName = "";
                    toController.text = "";
                    markers.removeWhere(
                      (marker) => marker.markerId.value == "1",
                    );
                    polylineCoordinates.clear();
                    ploylineSet.removeWhere(
                      (polyline) => polyline.polylineId.value == "1",
                    );
                  },
                  controller: toController,
                  onEditingComplete: () {
                    searchPlace(toController.text.trim());
                    moveToSearchedPlace(
                      toController.text.trim(),
                      googleMapController!,
                    );

                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          customBodyText(Icons.language, "Search in a different city"),
          customBodyText(Icons.location_on_outlined, "Set location on map"),
          customBodyText(Icons.star, "Saved places"),

          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.grey01,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (targetLocationName == null) {
                  Fluttertoast.showToast(msg: "Destination Location is Empty");
                  // return;
                } else {
                  Navigator.of(context).pushNamed(
                    AppRoutes.driversScreen,
                    arguments: {
                      "fromLocation": currentLocationName.toString(),
                      "toLocation": targetLocationName.toString(),
                      "distance": distanceInKm?.toStringAsFixed(2),
                    },
                  );
                }
              },
              child: Text(
                "Confirm & Pay",
                style: GoogleFonts.crimsonPro(
                  fontSize: 17,
                  color: MyColors.black.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customBodyText(IconData? icon, String text) {
    return ListTile(
      leading: Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          color: MyColors.grey01,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: MyColors.grey01),
        ),
        child: Icon(icon, size: 20.0, color: MyColors.black),
      ),
      title: Text(
        text,
        style: smallStyle.copyWith(color: MyColors.black, fontSize: 13.0),
      ),
    );
  }

  Widget customTextFormFieldLocation({
    required final String labelText,
    void Function()? onPressedPrefix,
    void Function()? onPressedSuffix,
    TextEditingController? controller,
    void Function()? onEditingComplete,
  }) {
    return SizedBox(
      height: 30.0,
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: onPressedPrefix,
            icon: Icon(
              Icons.radio_button_checked,
              color: MyColors.black,
              size: 20.0,
            ),
          ),
          hintText: labelText,

          suffixIcon:
              controller!.text.isEmpty
                  ? null
                  : IconButton(
                    onPressed: onPressedSuffix,
                    icon: Icon(Icons.clear),
                  ),
          hintStyle: GoogleFonts.sanchez(
            color: MyColors.black.withOpacity(0.5),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          border: InputBorder.none,
        ),
        style: GoogleFonts.sanchez(
          color: MyColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
