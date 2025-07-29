// ignore_for_file: deprecated_member_use

import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/main.dart';
import 'package:chat/presentation/screens/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: MyColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    customCategoriesCard(Icons.help, "Help"),
                    customCategoriesCard(Icons.wallet_sharp, "Wallet"),
                    customCategoriesCard(Icons.receipt, "Activity"),
                  ],
                ),
                customBodyCard(
                  "100% off Uber Shuttle",
                  "Go rediscover your city for less --\nterms apply",
                  AppImageAsset.dicountImage,
                ),
                customBodyCard(
                  "Try Uber One free",
                  "Unlock 15% Uber One credits on rides and\nmore",
                  AppImageAsset.carImage,
                ),
                customBodyCard(
                  "Safty checkup",
                  "Learn Ways to make rides safer",
                  AppImageAsset.countImage,
                ),
                customBodyCard(
                  "Privacy checkup",
                  "Take an interactive tour of your\nprivacy settings",
                  AppImageAsset.noteImage,
                ),
                customListTile(
                  "   Family",
                  Icons.groups_2,
                  "    Manage a family profile",
                ),
                customListTile("   Settings", Icons.settings, null),
                customListTile("   Messgaes", Icons.mail_outline, null),
                customListTile(
                  "   Shuttle Package",
                  Icons.receipt_long_rounded,
                  null,
                ),
                customListTile("   Saved groups", Icons.group, null),
                customListTile(
                  "   Setup your business profile",
                  Icons.wallet_travel_rounded,
                  "    Automate work travel & meal expenses",
                ),
                customListTile("   Shuttle Routes", Icons.person, null),
                customListTile(
                  "   Manage Uber account",
                  Icons.route_rounded,
                  null,
                ),
                customListTile("   Legal", Icons.info, null),
                customText("v3.675.10001", MyColors.grey, 11.0, 10.0, 20.0),
                TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: MyColors.grey01,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await myBox!.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Logout",
                    style: smallStyle.copyWith(color: MyColors.black),
                  ),
                ),
              ],
            ),
          ),

          /// 🧍 Fixed Header
          Row(
            children: [
              customText(
                "${myBox!.get("userName")} sallam",
                MyColors.black,
                20.0,
                0.0,
                0.0,
              ),
              Spacer(),
              CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage(AppImageAsset.profileImage),
              ),
            ],
          ),

          /// ⭐ Rating Badge
          Positioned(
            top: 50.0,
            child: Container(
              height: 30.0,
              width: 70.0,
              decoration: BoxDecoration(
                color: MyColors.grey02.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 20.0),
                  customText(" 5.00", MyColors.black, 10.0, 0.0, 0.0),
                ],
              ),
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

  Widget customCategoriesCard(IconData? icon, String text) {
    return Expanded(
      child: SizedBox(
        height: 100.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: MyColors.black),
              customText(text, MyColors.black, 13.0, 0.0, 0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget customBodyCard(String textOne, String textTwo, String image) {
    return SizedBox(
      height: 120.0,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  customText(textOne, MyColors.black, 13.0, 15.0, 0.0),
                  SizedBox(height: 5.0),
                  customText(textTwo, MyColors.grey, 10.0, 15.0, 0.0),
                ],
              ),
            ),
            // Spacer(),
            Expanded(
              flex: 1,
              child:
              //  FadeInImage.assetNetwork(
              //   placeholder: AppImageAsset.loadingAssetImage,
              //   image: image,
              //   fit: BoxFit.fitHeight,
              // ),
              Image.asset(
                image,
                height: 100.0,
                width: 100.0,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customListTile(String title, IconData? icon, [String? subTitle]) {
    return SizedBox(
      height: 55.0,
      child: ListTile(
        title: customText(title, MyColors.black, 13.0, 0.0, 0.0),
        subtitle:
            subTitle == null
                ? null
                : customText(subTitle, MyColors.grey, 10.0, 0.0, 0.0),
        leading: Padding(
          padding:
              subTitle == null
                  ? EdgeInsets.only(top: 0.0)
                  : EdgeInsets.only(top: 13.0),
          child: Icon(icon),
        ),
        trailing:
            title == "   Saved groups"
                ? Container(
                  height: 30.0,
                  width: 52.0,
                  decoration: BoxDecoration(
                    color: MyColors.blueDark.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  child: customText("New", MyColors.white, 10.0, 15.0, 8.0),
                )
                : null,
        isThreeLine: subTitle != null ? true : false,
      ),
    );
  }
}
