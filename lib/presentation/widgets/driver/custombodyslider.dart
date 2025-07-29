// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/functions/fileupload.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/main.dart';
import 'package:chat/presentation/screens/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class CustomBodySlider extends StatefulWidget {
  final GlobalKey<SliderDrawerState> sliderDrawerKey;

  const CustomBodySlider({super.key, required this.sliderDrawerKey});

  @override
  State<CustomBodySlider> createState() => _CustomBodySliderState();
}

class _CustomBodySliderState extends State<CustomBodySlider> {
  File? file;
  String? img;
  bool isLoading = false;
  String? url;

  void chooseImageGallery() async {
    file = (await takePhotoWithGallery())!;
    isLoading = true;
    setState(() {});
    if (file == null) {
      return;
    } else {
      file = File(file!.path);
      String imageName = path.basename(file!.path);
      Reference reference = FirebaseStorage.instance.ref("images/$imageName");
      await reference.putFile(file!);
      url = await reference.getDownloadURL();
      context.read<OrdersCubit>().updateImage(myBox!.get("DriverImage"), url!);
      myBox!.delete("DriverImage");
      myBox!.put("DriverImage", url);
    }
    Timer.periodic(const Duration(seconds: 4), (timer) {
      isLoading = false;
      setState(() {});
    });
  }

  void chooseImageCamera() async {
    file = (await takePhotoWithCamera())!;
    if (file == null) {
      return;
    } else {
      isLoading = true;
      setState(() {});
      file = File(file!.path);
      String imageName = path.basename(file!.path);
      Reference reference = FirebaseStorage.instance.ref("images/$imageName");
      await reference.putFile(file!);
      url = await reference.getDownloadURL();
      context.read<OrdersCubit>().updateImage(myBox!.get("DriverImage"), url!);
      myBox!.delete("DriverImage");
      myBox!.put("DriverImage", url);
    }
    await Future.delayed(Duration(seconds: 4));
    isLoading = false;
    setState(() {});
  }

  void remove() {
    file = null;
    myBox!.delete("DriverImage");
  }

  void chooseImageOption() {
    showAttachmentOptions(
      context,
      chooseImageGallery,
      chooseImageCamera,
      remove,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<OrdersCubit>().driver.forEach((element) {
      img = element["image"];
    });
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      color: MyColors.grey01,

      child: Column(
        children: [
          isLoading
              ? const CircularProgressIndicator()
              : BlocListener<OrdersCubit, OrdersState>(
                listener: (context, state) {
                  final driverData = context.read<OrdersCubit>().driver;
                  if (driverData.isNotEmpty) {
                    setState(() {
                      img = driverData.first["image"];
                    });
                  }
                },
                child: InkWell(
                  onTap: () {
                    chooseImageOption();
                  },
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        (img != "" && img != null && img != "none")
                            ? NetworkImage(myBox!.get("DriverImage") ?? img!)
                            : AssetImage("assets/images/profile.png"),
                  ),
                ),
              ),

          SizedBox(height: 15.0),
          Text(
            myBox!.get("driverName"),
            style: meduimStyle.copyWith(color: MyColors.black),
          ),
          SizedBox(height: 50.0),
          customBuildDrawerItem(
            icon: Icons.home,
            title: "Home",
            onTap: () {
              widget.sliderDrawerKey.currentState!.closeSlider();
            },
          ),
          customBuildDrawerItem(
            icon: Icons.location_on_sharp,
            title: "Tracing",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.driverLocationScreen);
            },
          ),
          customBuildDrawerItem(
            icon: Icons.payment_outlined,
            title: "Payment",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.paymentsScreen);
            },
          ),
          customBuildDrawerItem(
            icon: Icons.history_outlined,
            title: "History",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.historyOrders);
            },
          ),

          customBuildDrawerItem(
            icon: Icons.notifications_active_rounded,
            title: "Notifications",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.notificationsScreen);
            },
          ),
          customBuildDrawerItem(
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.settingScreen);
            },
          ),
          customBuildDrawerItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await myBox!.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget customBuildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: MyColors.black),
      title: Text(title, style: smallStyle.copyWith(color: MyColors.black)),
      onTap: onTap,
    );
  }
}
