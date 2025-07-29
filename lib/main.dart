// ignore_for_file: avoid_print

import 'package:chat/app_router.dart';
import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/orders/orders_state.dart';
import 'package:chat/constant/class/const.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/constant/class/localnotify.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Box? myBox;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<Box> initBoxHive(String boxName) async {
  if (!Hive.isBoxOpen(boxName)) {
    print("Box is not open");
    Hive.init((await getApplicationDocumentsDirectory()).path);
  } else {
    print("Box is already open");
  }
  return Hive.openBox(boxName);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {}
}

void main() async {
  // main
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(
      '6Le6z5ArAAAAAPto0OW-dL7aGaNUCQwwuDeJC4O2', // site key
      // 6Le6z5ArAAAAAOn7oDUATXnP5RsmIfO1Z5BYEQcO  // secret key
    ),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  myBox = await initBoxHive("fares");
  await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterPaymob.instance.initialize(
    apiKey:
        MyConst
            .apiKeyPaymob, //  from dashboard Select Settings -> Account Info -> API Key
    integrationID:
        MyConst
            .integrationCardId, // from dashboard Select Developers -> Payment Integrations -> Online Card ID
    walletIntegrationId:
        MyConst
            .integrationMobileWalletId, // from dashboard Select Developers -> Payment Integrations -> Online wallet
    iFrameID: MyConst.iframeId,
  );
  runApp(
    BlocProvider<OrdersCubit>(
      create: (context) => OrdersCubit(),
      child: BlocListener<OrdersCubit, OrdersState>(
        bloc: OrdersCubit(),
        listener: (context, state) {
          Navigator.of(context).pushNamed(AppRoutes.booking);
        },
        child: ChatApp(),
      ),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      routes: routes,
    );
  }
}
