// ignore_for_file: avoid_print

import 'package:chat/business_logic/payment/payment_state.dart';
import 'package:chat/data/model/payment.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PaymentCubit extends Cubit<PaymentState> {
  List<PaymentModel> listPayments = [];

  PaymentCubit() : super(PaymentStateLoading());

  void addPaymentData(
    String driverId,
    // String phone,
    String city,
    String method,
    // String transactionId,
    double amount,
    String currency,
    String status,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance.collection('payment').add({
      "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
      "driverId": driverId,
      "fullname": myBox!.get("userName"),
      "email": FirebaseAuth.instance.currentUser!.email.toString(),
      // "phone": phone,
      "city": city,
      "method": method,
      // "transactionId": transactionId,
      "amount": amount,
      "currency": currency,
      "status": status,
      // "paid": "0",
      "time": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
    });
  }

  Future<List<PaymentModel>> viewPaymentData() async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('payment')
            .where(
              "driverId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .get();

    listPayments =
        querySnapshot.docs
            .map((doc) {
              return {'docId': doc.id, ...doc.data()};
            })
            .map((e) => PaymentModel.fromJson(e))
            .toList();
    print("listPayments ========================= $listPayments");

    return listPayments;
  }

  void paymentOrder(String docId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where(
          "userId",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString(),
        )
        .get()
        .then((value) {
          // ignore: unused_local_variable
          for (var value in value.docs) {
            FirebaseFirestore.instance.collection('orders').doc(docId).update({
              "status": 4,
            });
          }
        });
  }
}
