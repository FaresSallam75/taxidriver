// ignore_for_file: avoid_print

import 'package:chat/business_logic/auth/auth_state.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthStateLoading());

  List listUsers = [];
  String? currentUser;

  Future<String> getToken() async {
    late String fcmToken;
    await FirebaseMessaging.instance
        .getToken()
        .then((token) {
          fcmToken = token!;
          print("Firebase Messaging Token: ===========  $token");
          myBox!.put("fcmToken", token);
        })
        .catchError((error) {
          print("Error getting FCM token: ==============  $error");
        });
    return fcmToken;
  }

  void loginData(
    BuildContext context,
    int index,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) async {
    if (!formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    } else {
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        final querySnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        listUsers =
            querySnapshot.docs.map((doc) {
              final data = doc.data();
              data['docId'] = doc.id; // ✅ Store document ID
              currentUser = data['userDocId'];

              return data;
            }).toList();

        if (index == 0) {
          myBox!.put("driverName", email.split('@')[0]);
          myBox!.put("driverEmail", email.toString());
          myBox!.put("driverPassword", password.toString());
          print("driverEmail ================= ${myBox!.get("driverEmail")}");
          print("userType is Driver =====");

          if (currentUser != null) {
            print("driver already exist =========================== ");
          } else {
            await storUserData(
              credential.user!.uid,
              email,
              "driver",
              myBox!.get("fcmToken"),
              DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
            );
          }

          Navigator.of(context).pushReplacementNamed(AppRoutes.driversOrder);
        } else {
          myBox!.put("userName", email.split('@')[0]);
          myBox!.put("userEmail", email.toString());
          myBox!.put("userPassword", password.toString());
          print("username =================== ${myBox!.get("userName")}");
          print("userEmail =================== ${myBox!.get("userEmail")}");
          print("userType is User =====");

          if (FirebaseAuth.instance.currentUser!.uid.toString() ==
              currentUser.toString()) {
            print("user already exist =========================== ");
          } else {
            await storUserData(
              credential.user!.uid,
              email,
              "user",
              myBox!.get("fcmToken"),
              DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
            );
          }
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainHome);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email. =====================');
        } else if (e.code == 'wrong-password') {
          print(
            'Wrong password provided for that user. ======================',
          );
        }
      } catch (e) {
        print("Exection ============================  $e");
      }
    }
  }

  Future<void> storUserData(
    String userDocId,
    // String name,
    String email,
    String userType,
    String fcmToken,
    String createdAt,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'userDocId': userDocId,
      // 'name': name,
      'email': email,
      'userType': userType, // أو 'rider'
      'fcmToken': fcmToken,
      'timeCreated': createdAt,
    });
  }

  void registerData(
    BuildContext context,
    int index,
    GlobalKey<FormState> formKey,
    String nameController,
    String emailController,
    String passwordController,
  ) async {
    // formKey.currentState!.save();
    if (!formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );

      if (index == 0) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.driverLogin);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.userLogin);
      }
      Fluttertoast.showToast(msg: "Email Created Successfully ..");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void resetPassword(String email) {
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12',
    );
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email, actionCodeSettings: acs)
        .catchError(
          (onError) => print('Error sending email verification $onError'),
        )
        .then((value) => print('Successfully sent email verification'));
  }

  void resetPassword2(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong.";
      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address.";
      }
      Fluttertoast.showToast(msg: message);
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred.");
    }
  }
}
