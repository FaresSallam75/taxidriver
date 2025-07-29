// ignore_for_file: avoid_print

import 'package:chat/business_logic/payment/payment_cubit.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/functions/location.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/presentation/screens/user/payment/creditcard.dart';
import 'package:chat/presentation/screens/user/payment/email_pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class PaymobScreen extends StatefulWidget {
  const PaymobScreen({super.key});

  @override
  State<PaymobScreen> createState() => _PaymobScreenState();
}

class _PaymobScreenState extends State<PaymobScreen> {
  double? price;
  String? driverId;
  String? docId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    price = args!["price"];
    driverId = args["driverId"];
    docId = args["docId"];
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentCubit>();
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Add Payment Method",
          style: smallStyle.copyWith(color: MyColors.black),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: MyColors.black),
      ),
      body: Center(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                try {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => CreditCardPaymentScreen(
                            driverId: driverId!,
                            currentLocationName: currentLocationName!,
                            responseCode: "success",
                            amount: price!,
                            docId: docId!,
                          ),
                    ),
                  );
                } catch (e) {
                  print("error card : $e");
                }
              },
              child: ListTile(
                leading: Image.asset(
                  AppImageAsset.creditLogo,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.fitWidth,
                ),
                title: Text(
                  "   Credit or Debit Card",
                  style: smallStyle.copyWith(color: MyColors.black),
                ),

                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.0),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 75.0),
              child: Divider(),
            ),

            InkWell(
              onTap: () {
                cubit.addPaymentData(
                  driverId!,
                  currentLocationName!,
                  "Cash",
                  // widget.transactionId,
                  price!,
                  "EGP",
                  "success",
                  context,
                );
                cubit.paymentOrder(docId!);
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainHome,
                    (route) => false,
                  );
                  Fluttertoast.showToast(
                    msg: "Thank you for your payment, ✅ Payment is valid",
                  );
                });
              },
              child: ListTile(
                leading: Image.asset(
                  AppImageAsset.cachLogo,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.fitWidth,
                ),
                title: Text(
                  "   Cash",
                  style: smallStyle.copyWith(color: MyColors.black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75.0),
              child: Divider(),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailPay()),
                );
              },
              child: ListTile(
                leading: Image.asset(
                  AppImageAsset.cachLogo,
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.fitWidth,
                ),
                title: Text(
                  Platform.operatingSystem == "ios"
                      ? "   Apple Pay"
                      : "   Google Pay",
                  style: smallStyle.copyWith(color: MyColors.black),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
