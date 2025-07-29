// ignore_for_file: avoid_print

import 'package:chat/business_logic/driver/driver_state.dart';
import 'package:chat/constant/class/showtoast.dart';
import 'package:chat/data/model/car.dart';
import 'package:chat/data/model/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(const DriverStateLoading());

  List<DriverDetailsModel> nearbyDrivers = [];
  List<CarModel> listCars = [];
  List listOrders = [];

  Future<List> fetchNearbyDrivers() async {
    try {
      emit(const DriverStateLoading());

      final driver =
          await FirebaseFirestore.instance.collection('driverdetails').get();
      nearbyDrivers =
          driver.docs
              .map((doc) {
                return {
                  'docId': doc.id, // أضف docId هنا
                  ...doc.data(),
                };
              })
              .map((e) => DriverDetailsModel.fromJson(e))
              .toList();

      final querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      listOrders =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            data['docId'] = doc.id; // ✅ Store document ID
            return data;
          }).toList();

      emit(DriverStateLoaded(nearbyDrivers: nearbyDrivers, cars: []));

      // ignore: unnecessary_null_comparison
      if (driver == null || nearbyDrivers.isEmpty) {
        emit(DriverStateError(errorMessage: 'No nearby drivers found.'));
        ToastHelper.show('No nearby drivers found.');
      }
    } catch (e) {
      emit(DriverStateError(errorMessage: e.toString()));
      ToastHelper.show('Error fetching nearby drivers: ${e.toString()}');
    }
    return nearbyDrivers;
  }

  Future<List> getCarsbyDrivers() async {
    try {
      emit(const DriverStateLoading());

      final querySnapshot =
          await FirebaseFirestore.instance.collection('cars').get();

      listCars =
          querySnapshot.docs
              .map((doc) {
                return {
                  'carDocId': doc.id, // أضف docId هنا
                  ...doc.data(),
                };
              })
              .map((e) => CarModel.fromJson(e))
              .toList();

      print("cars ======D======================= $listCars");
      emit(DriverStateLoaded(nearbyDrivers: [], cars: listCars));
    } catch (e) {
      emit(DriverStateError(errorMessage: e.toString()));
      ToastHelper.show('Error fetching cars: ${e.toString()}');
    }
    return nearbyDrivers;
  }

  void addOrder(
    String carName,
    String fromLocation,
    String toLocation,
    double distance,
    double price,
    String carDocId,
    String driverId,
  ) {
    FirebaseFirestore.instance
        .collection('orders')
        .add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'carName': carName, // Replace with actual car name
          'fromLocation': fromLocation, // Replace with actual location
          'toLocation': toLocation, // Replace with actual location
          'distance': distance, // Replace with actual distance
          'price': price, // Replace with actual distance
          'status': 0, // Initial status of the order
          "carDocId": carDocId,
          "driverId": driverId,
          'timestamp': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
        })
        .then((value) {
          ToastHelper.show("Order added successfully");
        })
        .catchError((error) {
          ToastHelper.show("Failed to add order: $error");
        });
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
}
