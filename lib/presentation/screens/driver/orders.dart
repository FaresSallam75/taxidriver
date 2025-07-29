import 'dart:async';
import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/showtoast.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/constant/functions/notifications.dart';
import 'package:chat/data/model/orders.dart';
import 'package:chat/main.dart';
import 'package:chat/presentation/widgets/booking/custombodycard.dart';
import 'package:chat/presentation/widgets/booking/customelevatedbutton.dart';
import 'package:chat/presentation/widgets/driver/custombodyslider.dart';
import 'package:chat/presentation/widgets/driver/customsliderappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:jiffy/jiffy.dart';

class DriversOrders extends StatefulWidget {
  const DriversOrders({super.key});

  @override
  State<DriversOrders> createState() => _DriversOrdersState();
}

class _DriversOrdersState extends State<DriversOrders> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  String? userId;
  String? fcmToken;

  @override
  void initState() {
    updateToken();
    context.read<OrdersCubit>().listBookingOrders();
    context.read<OrdersCubit>().listOrderUsers();
    context.read<OrdersCubit>().driverDetails();
    startOnInital(context, "ordering");
    _initialize();
    super.initState();
  }

  @override
  dispose() {
    _sliderDrawerKey.currentState?.closeSlider();
    super.dispose();
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
    await FirebaseFirestore.instance
        .collection('driverdetails')
        .where("driverId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((value) {
          for (var element in value.docs) {
            if (element['driverId'].toString() ==
                FirebaseAuth.instance.currentUser!.uid) {
              FirebaseFirestore.instance
                  .collection('driverdetails')
                  .doc(element.id)
                  .update({'fcmToken': myBox!.get('fcmToken')});
            }
          }
        });
  }

  Future<void> _initialize() async {
    await requestPermissionLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        slideDirection: SlideDirection.leftToRight,
        animationDuration: 1000,
        isDraggable: true,
        key: _sliderDrawerKey,
        appBar: CustomSliderAppBar(text: "Orders"),
        sliderOpenSize: 200.0,
        slider: CustomBodySlider(sliderDrawerKey: _sliderDrawerKey),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersStateError) {
              return Center(child: Text(state.errorMessage));
            } else {
              final cubit = context.read<OrdersCubit>();
              final now = Jiffy.parse(DateTime.now().toString()).date;
              String currentDriverId = FirebaseAuth.instance.currentUser!.uid;

              for (var docs in cubit.listUsers) {
                userId = docs['userDocId'];
                fcmToken = docs['fcmToken'];
              }

              final todayAppointments =
                  cubit.listjsonOrders
                      .where(
                        (a) =>
                            a.driverId == currentDriverId &&
                            a.status != '2' &&
                            a.status != '3' &&
                            a.status != '4' &&
                            Jiffy.parse(
                                  a.timestamp!,
                                  pattern: "yyyy-MM-dd hh:mm a",
                                ).date ==
                                now,
                      )
                      .toList();

              final missedAppointments =
                  cubit.listjsonOrders
                      .where(
                        (a) =>
                            a.driverId == currentDriverId &&
                            a.status != '2' &&
                            a.status != '3' &&
                            a.status != '4' &&
                            Jiffy.parse(
                                  a.timestamp!,
                                  pattern: "yyyy-MM-dd hh:mm a",
                                ).date <
                                now,
                      )
                      .toList();

              final upcomingAppointments =
                  cubit.listjsonOrders
                      .where(
                        (a) =>
                            a.driverId == currentDriverId &&
                            Jiffy.parse(
                                  a.timestamp!,
                                  pattern: "yyyy-MM-dd hh:mm a",
                                ).date >
                                now,
                      )
                      .toList();

              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (todayAppointments.isNotEmpty) ...[
                        _buildSectionHeader("Today", context),
                        ...todayAppointments.map(
                          (a) => customLoadedData(a, isCancelled: false),
                        ),
                      ],

                      if (missedAppointments.isNotEmpty) ...[
                        _buildSectionHeader("Missed", context),
                        ...missedAppointments.map(
                          (a) => customLoadedData(a, isCancelled: false),
                        ),
                      ],
                      if (upcomingAppointments.isNotEmpty) ...[
                        _buildSectionHeader("Upcoming", context),
                        ...upcomingAppointments.map(
                          (a) => customLoadedData(a, isCancelled: false),
                        ),
                      ],
                      if (todayAppointments.isEmpty &&
                          missedAppointments.isEmpty &&
                          upcomingAppointments.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: Text('No orders available'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      height: 40.0,
      width: MediaQuery.of(context).size.width - 150,
      decoration: BoxDecoration(
        color: MyColors.thirdColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget customLoadedData(OrdersModel orders, {required bool isCancelled}) {
    final cubit = context.read<OrdersCubit>();

    return CarInfoCard(
      carName: orders.carName!,
      fromLocation: orders.fromLocation!,
      targetLocation: orders.toLocation!,
      dateTime: orders.timestamp!,
      price: double.parse(orders.price.toString()),
      distance: orders.distance.toString(),
      status: orders.status == "0" ? "Pending approval" : "Accepted",
      widget:
          isCancelled
              ? Container()
              : Row(
                children: [
                  // if (cubit.listjsonOrders[index]['status'] == 0)
                  Expanded(
                    child: CustomElevatedButton(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      text: orders.status == "0" ? "approve" : "complete",
                      onPressed:
                          orders.status == "0"
                              ? () {
                                ToastHelper.show("driver approve the order");
                                cubit.approveOrder(
                                  orders.userId!,
                                  orders.docId!,
                                );
                                sendFCMMessage(
                                  "Message from Driver ${myBox!.get("driverName")} ",
                                  "your order is approved, now you can pay if you want",
                                  fcmToken!,
                                  "booking",
                                  userId!,
                                );
                                cubit.insertSmsNotification(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  "Message from Driver ${myBox!.get("driverName")} ",
                                  "your order is approved, now you can pay if you want",
                                );
                              }
                              : () {
                                ToastHelper.show("driver complete the order");
                                cubit.completeOrder(
                                  orders.userId!.toString(),
                                  orders.docId!,
                                );
                                sendFCMMessage(
                                  "Message from Driver ${myBox!.get("driverEmail")} ",
                                  "complete your order, we wish you have a nice day",
                                  fcmToken!,
                                  "booking",
                                  userId!,
                                );
                                cubit.insertSmsNotification(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  "Message from Driver ${myBox!.get("driverEmail")} ",
                                  "complete your order, we wish you have a nice day",
                                );
                              },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  if (orders.status == "0")
                    Expanded(
                      child: CustomElevatedButton(
                        margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        text: "cancel",
                        onPressed: () {
                          ToastHelper.show("driver cancel your order");
                          cubit.cancelOrder(orders.userId!, orders.docId!);
                          sendFCMMessage(
                            "Message from Driver ${myBox!.get("driverName")}",
                            "your order is cancelled, please try again later or contact us",
                            fcmToken!,
                            "ordering",
                            userId!,
                          );
                          cubit.insertSmsNotification(
                            FirebaseAuth.instance.currentUser!.uid,
                            "Message from Driver ${myBox!.get("driverName")}",
                            "your order is cancelled, please try again later or contact us",
                          );
                        },
                      ),
                    ),
                ],
              ),
    );
  }
}
