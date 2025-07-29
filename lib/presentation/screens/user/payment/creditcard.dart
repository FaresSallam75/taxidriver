// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:chat/business_logic/payment/payment_cubit.dart';
import 'package:chat/constant/class/const.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class CreditCardPaymentScreen extends StatefulWidget {
  final String driverId;
  final String currentLocationName;
  // final String transactionId;
  final String responseCode;
  final double amount;
  final String docId;

  const CreditCardPaymentScreen({
    super.key,
    required this.driverId,
    required this.currentLocationName,
    // required this.transactionId,
    required this.responseCode,
    required this.amount,
    required this.docId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CreditCardPaymentScreenState createState() =>
      _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  final String apiKey = MyConst.apiKeyPaymob;
  final int integrationId = MyConst.integrationCardId;
  final int iframeId = MyConst.iframeId;
  final String phone = '01062878889';

  String? paymentToken;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initiatePayment();
  }

  Future<void> initiatePayment() async {
    print("amount = =================== ${widget.amount}");
    try {
      // Step 1: Auth Token
      final authRes = await http.post(
        Uri.parse('https://accept.paymob.com/api/auth/tokens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'api_key': apiKey}),
      );
      final authToken = jsonDecode(authRes.body)['token'];

      // Step 2: Order Registration
      final orderRes = await http.post(
        Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'auth_token': authToken,
          'delivery_needed': false,
          'amount_cents': widget.amount,
          'currency': 'EGP',
          'items': [],
        }),
      );
      final orderId = jsonDecode(orderRes.body)['id'];

      // Step 3: Payment Key Request
      final paymentRes = await http.post(
        Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'auth_token': authToken,
          'amount_cents': widget.amount * 100,
          'expiration': 3600,
          'order_id': orderId,
          'billing_data': {
            'apartment': 'N/A',
            'email': 'user@test.com',
            'floor': 'N/A',
            'first_name': 'Test',
            'street': 'N/A',
            'building': 'N/A',
            'phone_number': phone,
            'shipping_method': 'N/A',
            'postal_code': 'N/A',
            'city': 'Cairo',
            'country': 'EG',
            'last_name': 'User',
            'state': 'Cairo',
          },
          'currency': 'EGP',
          'integration_id': integrationId,
        }),
      );

      setState(() {
        paymentToken = jsonDecode(paymentRes.body)['token'];
        isLoading = false;
      });
    } catch (e) {
      print('Payment error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء بدء عملية الدفع')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<PaymentCubit>();
    final url =
        paymentToken != null
            ? 'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=$paymentToken'
            : '';

    return Scaffold(
      appBar: AppBar(title: Text('Credit Card'), centerTitle: true),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : WebViewWidget(
                controller:
                    WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onNavigationRequest: (NavigationRequest request) {
                            if (request.url.contains('success')) {
                              print(
                                "success payment ======================== ",
                              );

                              context.read<PaymentCubit>().addPaymentData(
                                widget.driverId,
                                widget.currentLocationName,
                                "Credit Card",
                                // widget.transactionId,
                                widget.amount,
                                "EGP",
                                widget.responseCode,
                                context,
                              );
                              context.read<PaymentCubit>().paymentOrder(
                                widget.docId,
                              );

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.mainHome,
                                (route) => false,
                              );
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text('✅ الدفع تم بنجاح'),
                                      content: Text('شكراً لعملية الدفع'),
                                    ),
                              );
                              return NavigationDecision.prevent;
                            } else if (request.url.contains('fail')) {
                              print("fail payment ======================== ");
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text('❌ فشل الدفع'),
                                      content: Text('حاول مرة أخرى'),
                                    ),
                              );
                              return NavigationDecision.prevent;
                            }
                            return NavigationDecision.navigate;
                          },
                        ),
                      )
                      ..loadRequest(Uri.parse(url)),
              ),
    );
  }
}
