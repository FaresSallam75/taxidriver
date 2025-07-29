// ignore_for_file: avoid_print

import 'package:chat/business_logic/driver/driver_cubit.dart';
import 'package:chat/business_logic/driver/driver_state.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/class/showtoast.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/constant/functions/notifications.dart';
import 'package:chat/main.dart';
import 'package:chat/presentation/widgets/driver/cardride.dart';
import 'package:chat/presentation/widgets/booking/customelevatedbutton.dart';
import 'package:chat/presentation/widgets/home/custombodydata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  bool isPress = false;
  int selectedIndex = -1;
  double calculateDistanceInMeters = 0.0;
  double convertDistanceToKm = 0.0;
  String? carName;
  String? fcmToken;
  String? driverId;
  String? userId;
  String? carDocId;
  String? carId;
  String? orderStatus;
  late String fromLocation;
  late String toLocation;
  late String distance;
  List calculateDistance = [];
  List calculateDriversId = [];
  double fixedDistance = 50.00;

  List<Map> picture = [
    {"image": AppImageAsset.carfour},
    {"image": AppImageAsset.carfive},
    {"image": AppImageAsset.carOne},
    {"image": AppImageAsset.carsix},
    {"image": AppImageAsset.cartwo},
    {"image": AppImageAsset.carthree},
  ];

  @override
  void initState() {
    super.initState();
    context.read<DriverCubit>().fetchNearbyDrivers();
    context.read<DriverCubit>().getCarsbyDrivers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    fromLocation = args!["fromLocation"];
    toLocation = args["toLocation"];
    distance = args["distance"];
    // print("fromLocation: ================== $fromLocation");
    // print("toLocation: ================== $toLocation");
    print("distance: ================== $distance");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: CustomElevatedButton(
        margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
        text: "Book",
        onPressed: () {
          if (selectedIndex == -1) {
            ToastHelper.show("Please select a car");
          } else {
            if (userId == FirebaseAuth.instance.currentUser!.uid &&
                carDocId == carId &&
                orderStatus == "0") {
              ToastHelper.show("You already have an order");
            } else {
              context.read<DriverCubit>().addOrder(
                carName!,
                fromLocation,
                toLocation,
                double.parse(distance),
                double.parse(distance) < 20.00
                    ? 120.00
                    : double.parse(distance) < 50.00
                    ? 270.00
                    : double.parse(distance) < 90.00
                    ? 580.00
                    : 1100.00,
                carDocId!,
                driverId!,
              );
              sendFCMMessage(
                "order from ${myBox!.get("userName")}",
                "this is an order from ${myBox!.get("userName")} want to book a car",
                fcmToken ?? "",
                "ordering",
                driverId!,
              );
              context.read<DriverCubit>().insertSmsNotification(
                driverId!,
                "order from ${myBox!.get("userName")}",
                "this is an order from ${myBox!.get("userName")} want to book a car",
              );
            }
          }

          Navigator.of(context).pushReplacementNamed(
            AppRoutes.booking,
            arguments: {
              "carName": carName,
              "fromLocation": fromLocation,
              "toLocation": toLocation,
              "distance": distance,
              "driverId": driverId,
            },
          );
        },
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 0.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: MyColors.black,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 5),
                      Text(
                        "Choose a ride",
                        style: GoogleFonts.crimsonPro(
                          fontSize: 20,
                          color: MyColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: MyColors.black, thickness: 0.15),

                SizedBox(height: 7.0),
                CustomLabel(text: "10% promotion applied"),

                SizedBox(height: 20.0),
                CustomBodyTable(),
                SizedBox(height: 20.0),

                BlocBuilder<DriverCubit, DriverState>(
                  builder: (context, state) {
                    if (state is DriverStateLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is DriverStateError) {
                      return Center(child: Text(state.errorMessage));
                    }

                    final cubit = context.read<DriverCubit>();

                    for (var element in cubit.nearbyDrivers) {
                      calculateDistanceInMeters = Geolocator.distanceBetween(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                        (element.driverLat!),
                        (element.driverLong!),
                      );
                      convertDistanceToKm = (calculateDistanceInMeters / 1000);
                      print("convertDistanceToKm ====== $convertDistanceToKm");
                      // if (convertDistanceToKm > fixedDistance) {
                      calculateDistance.remove(
                        double.parse(convertDistanceToKm.toStringAsFixed(2)),
                      );
                      calculateDistance.add(
                        double.parse(convertDistanceToKm.toStringAsFixed(2)),
                      );
                      //   }
                    }
                    print(
                      "calculateDistance ===================== $calculateDistance",
                    );
                    if (calculateDistance.isNotEmpty &&
                        (calculateDistance.reduce(
                              (a, b) =>
                                  a < b
                                      ? a
                                      : b < a
                                      ? b
                                      : null,
                            ) <
                            fixedDistance)) {
                      for (var docs in cubit.nearbyDrivers) {
                        driverId = docs.driverId!; //docs['driverId'];
                        fcmToken = docs.fcmToken!; //docs['fcmToken'];
                        calculateDriversId.remove(driverId);
                        calculateDriversId.add(driverId!);
                      }
                      print(
                        "calculateDrivers =============== $calculateDriversId",
                      );
                      for (var docs in cubit.listOrders) {
                        userId = docs['userId'].toString();
                        orderStatus = docs['status'].toString();
                      }
                      for (var docs in cubit.listCars) {
                        carDocId =
                            docs.carDocId!; //docs['carDocId'].toString();
                      }

                      if (cubit.listOrders.isNotEmpty) {
                        for (var e in cubit.listOrders) {
                          carId = e['carDocId'];
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          // const BouncingScrollPhysics().applyTo(
                          //   AlwaysScrollableScrollPhysics(),
                          // ),
                          scrollDirection: Axis.vertical,
                          itemCount: cubit.nearbyDrivers.length,
                          itemBuilder: (context, index) {
                            return cubit.nearbyDrivers[index].driverId ==
                                        calculateDriversId[index] &&
                                    calculateDistance[index] > fixedDistance
                                ? Container()
                                : CustomCardRide(
                                  index: index,
                                  isPressed: selectedIndex == index,
                                  onTap: () {
                                    if (!isPress) {
                                      carName = cubit.listCars[index].carname;

                                      // carId =
                                      //     cubit.listOrders[index]['carDocId'];
                                      isPress = true;
                                      selectedIndex = index;
                                    } else {
                                      isPress = false;
                                      selectedIndex = -1;
                                    }

                                    setState(() {});
                                  },
                                  image:
                                      picture[index]['image'], //cubit.listCars[index]['image']!,
                                  rideName: "${cubit.listCars[index].carname}",
                                  count: "${cubit.listCars[index].counts}",
                                  time: "2:44 AM dropoff",
                                  waiting: "Longer Wait",
                                  discountPrice:
                                      double.parse(distance) < 20.00
                                          ? 100.00
                                          : double.parse(distance) < 50.00
                                          ? 250.00
                                          : double.parse(distance) < 90.00
                                          ? 550.00
                                          : 1000.00,
                                  price:
                                      double.parse(distance) < 20.00
                                          ? 120.00
                                          : double.parse(distance) < 50.00
                                          ? 270.00
                                          : double.parse(distance) < 90.00
                                          ? 580.00
                                          : 1100.00,
                                );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'No nearby drivers found.\n the distance is too far.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
