// ignore_for_file: avoid_print

import 'package:chat/business_logic/notifications/notification_state.dart';
import 'package:chat/data/model/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationsState> {
  NotificationCubit() : super(NotificationsStateLoading());

  void changeState(NotificationsState state) => emit(state);

  List<NotificationModel> listNotifications = [];

  Future<List<NotificationModel>> getAllNotifications() async {
    print(" ${FirebaseAuth.instance.currentUser!.uid}");
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('notifications')
            .where(
              "driverId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .get();
    listNotifications =
        querySnapshot.docs
            .map((doc) {
              return {'docId': doc.id, ...doc.data()};
            })
            .map((e) => NotificationModel.fromJson(e))
            .toList();

    return listNotifications;
  }

  void deleteNotification(String docId) {
    FirebaseFirestore.instance.collection('notifications').doc().delete();
  }
}
