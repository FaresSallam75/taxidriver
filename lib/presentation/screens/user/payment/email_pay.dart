import 'package:chat/constant/google_apple_pay.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pay/pay.dart';

class EmailPay extends StatelessWidget {
  final double? price;
  const EmailPay({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String os = Platform.operatingSystem;

    var applePayButton = ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultApplePay,
      ),
      paymentItems: const [
        PaymentItem(
          label: 'Item A',
          amount: '0.01',
          status: PaymentItemStatus.final_price,
        ),
        PaymentItem(
          label: 'Item B',
          amount: '0.01',
          status: PaymentItemStatus.final_price,
        ),
        PaymentItem(
          label: 'Total',
          amount: '0.02',
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: double.infinity,
      height: 50,
      type: ApplePayButtonType.buy,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );

    var googlePayButton = GooglePayButton(
      onError: (error) {
        //Get.back();
      },
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        defaultGooglePay,
      ),
      paymentItems: [
        PaymentItem(
          label: 'pay your trip',
          amount: price.toString(),
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(child: Platform.isIOS ? applePayButton : googlePayButton),
      ),
    );
  }
}
