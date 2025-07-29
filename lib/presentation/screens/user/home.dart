import 'package:chat/business_logic/driver/driver_cubit.dart';
import 'package:chat/business_logic/driver/driver_state.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/functions/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    context.read<DriverCubit>().getCarsbyDrivers();
    updateToken();
    initAll();
    super.initState();
  }

  Future<void> initAll() async {
    await requestPermissionLocation(context);
  }

  Future<void> updateToken() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("userDocId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((value) {
          for (var element in value.docs) {
            if (element['userDocId'].toString() ==
                FirebaseAuth.instance.currentUser!.uid) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(element.id)
                  .update({'fcmToken': myBox!.get('fcmToken')});
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          customText("Uber", MyColors.black, 25.0, 15.0, 15.0),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 50.0),
            child: ListView(
              physics: const BouncingScrollPhysics().applyTo(
                AlwaysScrollableScrollPhysics(),
              ),
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          backgroundColor: MyColors.grey01,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.locationScreen);
                        },
                        child: Text(
                          "Enter PickUp Location",
                          style: smallStyle.copyWith(color: MyColors.black),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.0),
                CustomBodyCard(
                  textOne: "Want better pickups?",
                  textTwo: "Share location",
                  image: AppImageAsset.telescopeImage,
                  color: Colors.green.shade900,
                  colorText: MyColors.white,
                ),
                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " Suggestion",
                      style: meduimStyle.copyWith(color: MyColors.black),
                    ),
                    Text(
                      "See All",
                      style: smallStyle.copyWith(
                        color: MyColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),

                CustomListCardCars(picture: picture),
                SizedBox(height: 20.0),

                SizedBox(
                  height: 145.0,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics().applyTo(
                      AlwaysScrollableScrollPhysics(),
                    ),
                    children: [
                      CustomBodyCard(
                        textOne: "Enjoy 10% off Scooter",
                        textTwo: "Book Now",
                        image: AppImageAsset.rideImage,
                        color: Colors.amber.shade100,
                      ),

                      SizedBox(width: 10),
                      CustomBodyCard(
                        textOne: "Ready? Then let's roll.",
                        textTwo: "Ride With Uber",
                        image: AppImageAsset.scoterImage,
                        color: Colors.teal.shade100,
                      ),

                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customText(
    String text,
    Color? color,
    double fontSize,
    double horizontal,
    double vertical,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Text(
        text,
        style: smallStyle.copyWith(color: color, fontSize: fontSize),
      ),
    );
  }
}

class CustomListCardCars extends StatelessWidget {
  final List<Map> picture;
  const CustomListCardCars({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    DriverCubit cubit = context.read<DriverCubit>();
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        if (state is DriverStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DriverStateError) {
          return Center(child: Text(state.errorMessage));
        }
        return SizedBox(
          height: 120.0,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: cubit.listCars.length,
            itemBuilder:
                (context, index) => SizedBox(
                  width: 128.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.locationScreen);
                    },
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.asset(
                              picture[index]['image'],
                              height: 80.0,
                              width: 80.0,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${cubit.listCars[index].carname}",
                              style: GoogleFonts.aBeeZee(
                                textStyle: smallStyle.copyWith(fontSize: 12.0),
                                color: MyColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class CustomBodyCard extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final String image;
  final Color color;
  Color? colorText;
  CustomBodyCard({
    super.key,
    required this.textOne,
    required this.textTwo,
    required this.image,
    required this.color,

    this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: Card(
        color: color,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      textOne,
                      style: smallStyle
                          .copyWith(color: MyColors.black)
                          .copyWith(color: colorText),
                    ),
                    // SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.grey01,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        //"Select your ride",
                        textTwo,
                        style: GoogleFonts.aBeeZee(
                          color: MyColors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                image,
                height: 150.0,
                width: 80.0,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
