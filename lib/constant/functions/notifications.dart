// ignore_for_file: avoid_print, strict_top_level_inference

import 'dart:convert';
import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/constant/class/localnotify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "chatlive-fc70b",
    "private_key_id": "0062c85514d7fa53869cdbe92c6f87640aa1b42f",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD3hX0G33/bPEUr\n2lIvjoBH6WrGCGRLSZU1uYJCe2yRkHmU6dOt/nx6hcz+tVyIxMkSD8/nIwc66TVi\n5tL0ePFM2XRZkMYNaWLGqc8Rr4pCP21Xj0dLeCZCLSUmQtLVSAkVTPHVodoSMxkU\nT5xGEZkOD2WZG4C2b4Uk16AkJ1vzoQZW5VcfXsyalDYIWO5rEx1/JP0cNgEFCVdE\nK9YoXW0kT1tmhhUnvpS1ACRhWQzgs+aNYAs/eJ82KTVe3xUu6jRcttlOX+MNtBgr\nCsCPs98Ld07y7Db01yrQygy0PGMODsl89bhNq0HQPbSEivXPTOKljEyzrU0KP4Mi\nR6E8r7qXAgMBAAECggEAauHSFMMy9yzl46NRJOcAXs0cxam/AUGjdEEITgP05ECC\nN7rmpLYE83VOiVgwPoDXIH0CdhkKmLY2TuBEjLui2t/1nW1mEEmHFSkjWMw3xBaW\ndR5SF3Uo9B+BcK2fU+jYv0FsFidfPseg10PvQ9R6hndAlGYrZNvwHvIbXTE/xAnV\ngrLbmQSKhG2uLRfCV/FYFS24v0BsB2ZoW7GusC3ROPtZFkW9xFkIlYNgU6Y52+VY\nVeTKUZp8m5lHFilkw7pzcp4+mTJmQkR74nFAYQsJSg2DIWGvK+bePMl1XbbHey6S\nEHqb8JeMfdAgiQ7BphbP+Un2AmqVtDr0m8ZO+g8xSQKBgQD/a+DxY8Mtxj0BQz7N\nrxkLU4902gXVcOwMwcemZghNcEpzXngE/rRPLX4g7tKLEkptsaCuesQuZz6gzmzJ\nyl5ktAyzmR8wH5rvGVqPSa3a4CE6+iYJbYDLj5VgC/ii8QuKX+aOlFo2IoD2yE4S\nOA6xOTAylpY8I9jCc8Ai/6jsHwKBgQD4FQdHyXAoe/MPdPMgTqqo2vsLL/2LtWHL\neDWothDisGi9DD/VmqgIF6PBwR83+bkNlB1nVvbBdBS7xBvguFe7L9kG1+BuSEIu\n33HrtyZ1BL4sn5OnqMMp6JIBk3GZTACNl6xH5TQtw/5+e7tllafcJRKWEaHi5dNU\nc8HtumriiQKBgDh+BLd/CCk0okOIOvjFFHXz2lPO8OFfY2YC6gR8prNx9ZWEvGjm\naLzmY/ImwDxwJDQUyGQu1PsqbKimX1tWPgBp7jE+2a4MH3lokyYD9sblMZRYxVbq\neEUNkc03eJuZUqMdSOIaH8W/ZeSvMs1GxsEd0/IsajgM+aEwdruG7jajAoGAQ3xU\n8q5VmG2/fSDvUoaT3kNTr4NqkarR46vbzP1aMpCSrXq7krvzod/saDTE7VE9ifgU\n15vMnGubiEic3NDI7N7jRv1KzDVT67RVJS45g/O6WCFA5Yb/MFNYBJ27dVw7ekkc\nUKKFQz3h6T53h/biJvzexXwecb7bcknbI3RmxyECgYEAqZIdY/fqHNOi35HeWf96\nXV1pD1lD32OCdtKw0uIRTCkMpe8N1+MPEzlKmo0MZ0HKiu41HQBqKI47qe0nFAGA\n2HJ/C1YzYgdD0WFpOEkFomMJi0r20pfCrXQqA2hfmGIumBlz+pyoqMK8/D0Esmg8\ntl6EhON7q23KeUYV/WS8ois=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-fbsvc@chatlive-fc70b.iam.gserviceaccount.com",
    "client_id": "102507000392437973066",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40chatlive-fc70b.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com",
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging",
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  auth.AccessCredentials credentials = await auth
      .obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

  client.close();
  return credentials.accessToken.data;
}

Future<void> sendFCMMessage(
  String title,
  String messageBody,
  // String topics,
  String targetToken,
  String type,
  String driverId,
) async {
  final String serverKey = await getAccessToken(); // Your FCM server key
  const String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/chatlive-fc70b/messages:send';

  final Map<String, dynamic> message = {
    'message': {
      // "topic": topics,
      'token': targetToken,
      'notification': {'body': messageBody, 'title': title},
      'data': {
        'current_user_fcm_token': targetToken,
        "type": type,
        "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
      },
    },
  };
  print("type(current page) :========== ${message['message']['data']['type']}");

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully ============================= ');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
  }
}

void startOnInital(context, String type) {
  NotificationService notificationService = NotificationService();
  FlutterRingtonePlayer flutterRingtonePlayer = FlutterRingtonePlayer();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      if (message.data['type'] == "ordering") {
        if (message.data['userId'] ==
            FirebaseAuth.instance.currentUser!.uid.toString()) {
          print("Equals ====================== ");
          return;
        }
        flutterRingtonePlayer.playNotification();
        BlocProvider.of<OrdersCubit>(context).listBookingOrders();
        notificationService.showNotification(
          id: 0,
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: message.data["type"],
        );
      }
      if (message.data['type'] == "booking") {
        flutterRingtonePlayer.playNotification();
        BlocProvider.of<OrdersCubit>(context).listBookingOrders();
        notificationService.showNotification(
          id: 0,
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: message.data["type"],
        );
      }
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Navigator.of(
    //   context,
    // ).push(MaterialPageRoute(builder: (context) => ChatPage()));
  });
}

Future<void> myRequestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}
