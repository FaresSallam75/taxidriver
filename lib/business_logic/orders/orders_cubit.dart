// ignore_for_file: unused_local_variable, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:chat/constant/class/showtoast.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/data/model/orders.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersStateLoading());

  List listUsers = [];
  List driver = [];
  List<OrdersModel> listjsonOrders = [];

  Future<List<OrdersModel>> listBookingOrders() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      listjsonOrders =
          querySnapshot.docs
              .map((doc) {
                return {'docId': doc.id, ...doc.data()};
              })
              .map((e) => OrdersModel.fromJson(e))
              .toList();
      print("listjsonOrders ======D======================= $listjsonOrders");

      emit(OrdersStateLoaded(listOrders: listjsonOrders));

      if (listjsonOrders.isEmpty) {
        emit(OrdersStateError(errorMessage: 'No orders found.'));
        ToastHelper.show('No  orders found.');
      }
    } catch (e) {
      emit(OrdersStateError(errorMessage: e.toString()));
      ToastHelper.show('Error fetching orders: ${e.toString()}');
    }
    return listjsonOrders;
  }

  Future<List> listOrderUsers() async {
    try {
      CollectionReference<Map<String, dynamic>> users = FirebaseFirestore
          .instance
          .collection('users');
      listUsers = await users.get().then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList();
      });

      if (listUsers.isEmpty) {
        emit(OrdersStateError(errorMessage: 'No Users found.'));
        ToastHelper.show('No Users found.');
      }
    } catch (e) {
      emit(OrdersStateError(errorMessage: e.toString()));
      ToastHelper.show('Error fetching users: ${e.toString()}');
    }

    return listUsers;
  }

  void driverDetails() async {
    await FirebaseFirestore.instance
        .collection('driverdetails')
        .where("driverId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          if (value.docs.isEmpty) {
            FirebaseFirestore.instance.collection('driverdetails').add({
              "driverId": FirebaseAuth.instance.currentUser!.uid.toString(),
              // 'driverName': FirebaseAuth.instance.currentUser!.displayName.toString(),
              'driverEmail': myBox!.get("driverEmail"),
              "driverLat": currentLocation!.latitude,
              "driverLong": currentLocation!.longitude,
              "fcmToken": myBox!.get("fcmToken"),
              "image": "none",
              "time": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
            });
          } else {
            driver =
                value.docs.map((doc) {
                  return {'docId': doc.id, ...doc.data()};
                }).toList();
            print("Driver details already exist. ");
          }
        });
  }

  void approveOrder(String userId, String docId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance.collection('orders').doc(docId).update({
              "status": 1,
            });
            print("element.id =========================== ${element.id}");
          }
        });
    listBookingOrders();
  }

  void completeOrder(String userId, String docId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance.collection('orders').doc(docId).update({
              "status": 2,
            });
          }
        });
    listBookingOrders();
  }

  void cancelOrder(String userId, String docId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance.collection('orders').doc(docId).update({
              "status": 3,
            });
          }
        });
    listBookingOrders();
  }

  void insertSmsNotification(String driverId, String title, String body) async {
    FirebaseFirestore.instance.collection('notifications').add({
      "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
      "driverId": driverId,
      'title': title,
      "body": body,
      "time": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
    });
  }

  void updateImage(String oldImage, String newImage) async {
    await FirebaseStorage.instance
        .refFromURL(myBox!.get("DriverImage"))
        .delete();
    FirebaseFirestore.instance
        .collection("driverdetails")
        .where("driverId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
          (value) => value.docs.forEach((element) async {
            await element.reference.update({"image": newImage});
          }),
        );
  }
}
