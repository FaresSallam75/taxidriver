// ignore_for_file: deprecated_member_use

import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/styles.dart';
import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      color: MyColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Stack(
          children: [
            customText("Activity", MyColors.black, 20.0, 0.0),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ListView(
                children: [
                  SizedBox(height: 10.0),
                  customText("Upcoming", MyColors.black, 16.0, 0.0),

                  Container(
                    height: 80.0,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "You have no upcoming trips",
                                MyColors.black,
                                13.0,
                                10.0,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  customText(
                                    "Reserve your ride",
                                    MyColors.grey,
                                    10.0,
                                    10.0,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MyColors.grey,
                                    size: 15.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Spacer(),
                          SizedBox(width: 40.0),
                          Image.asset(
                            AppImageAsset.carfour,
                            height: 80.0,
                            width: 80.0,
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      customText("Past", MyColors.black, 15.0, 7.0),
                      Spacer(),
                      CircleAvatar(
                        radius: 18.0,
                        backgroundColor: MyColors.grey02,
                        backgroundImage: AssetImage(AppImageAsset.icon),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 350.0,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200.0,
                            margin: EdgeInsets.all(12.0),
                            child: Card(
                              color: MyColors.grey01.withOpacity(0.4),
                              child: Center(
                                child: Icon(Icons.location_searching_rounded),
                              ),
                            ),
                          ),

                          Expanded(
                            child: customText(
                              "Unnamed Road",
                              MyColors.black,
                              14.0,
                              15.0,
                            ),
                          ),
                          Expanded(
                            child: customText(
                              "Jun 27 . 10:44 AM",
                              MyColors.black,
                              9.0,
                              15.0,
                            ),
                          ),
                          Expanded(
                            child: customText(
                              "EGP 0.00 Canceled",
                              MyColors.black,
                              9.0,
                              15.0,
                            ),
                          ),

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5.0,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.grey01.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.replay, size: 20.0),
                                    customText(
                                      "Rebook",
                                      MyColors.black,
                                      11.0,
                                      15.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customText(
    String text,
    Color? color,
    double fontSize,
    double horizontal,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: Text(
        text,
        style: smallStyle.copyWith(color: color, fontSize: fontSize),
      ),
    );
  }
}
