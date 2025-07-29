import 'package:chat/business_logic/auth/auth_cubit.dart';
import 'package:chat/business_logic/driver/driver_cubit.dart';
import 'package:chat/business_logic/notifications/notification_cubit.dart';
import 'package:chat/business_logic/orders/orders_cubit.dart';
import 'package:chat/business_logic/payment/payment_cubit.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/main.dart';
import 'package:chat/presentation/screens/driver/location.dart';
import 'package:chat/presentation/screens/driver/history.dart';
import 'package:chat/presentation/screens/driver/notifications.dart';
import 'package:chat/presentation/screens/driver/payments.dart';
import 'package:chat/presentation/screens/driver/setting.dart';
import 'package:chat/presentation/screens/user/account.dart';
import 'package:chat/presentation/screens/user/activity.dart';
import 'package:chat/presentation/screens/user/booking.dart';
import 'package:chat/presentation/screens/driver/orders.dart';
import 'package:chat/presentation/screens/driver/login.dart';
import 'package:chat/presentation/screens/driver/register.dart';
import 'package:chat/presentation/screens/user/drivers.dart';
import 'package:chat/presentation/screens/user/home.dart';
import 'package:chat/presentation/screens/user/location.dart';
import 'package:chat/presentation/screens/user/payment/payment.dart';
import 'package:chat/presentation/screens/user/services.dart';
import 'package:chat/presentation/screens/user/login.dart';
import 'package:chat/presentation/screens/mainhome.dart';
import 'package:chat/presentation/screens/user/register.dart';
import 'package:chat/presentation/screens/welcomescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  // thanks
  AppRoutes.welcomeScreen:
      (context) =>
          myBox!.get("userEmail") != null
              ? BlocProvider(
                create: (context) => DriverCubit(),
                child: MainHome(),
              )
              : myBox!.get("driverEmail") != null
              ? BlocProvider(
                create: (context) => OrdersCubit(),
                child: DriversOrders(),
              )
              : WelcomeScreen(),

  AppRoutes.userLogin:
      (context) =>
          BlocProvider(create: (_) => AuthCubit(), child: UserLoginScreen()),

  AppRoutes.userRegister:
      (context) =>
          BlocProvider(create: (_) => AuthCubit(), child: UserRegisterScreen()),
  AppRoutes.driverLogin:
      (context) =>
          BlocProvider(create: (_) => AuthCubit(), child: DriverLoginScreen()),
  AppRoutes.driverRegister:
      (context) => BlocProvider(
        create: (_) => AuthCubit(),
        child: DriverRegisterScreen(),
      ),
  AppRoutes.booking:
      (context) => BlocProvider<OrdersCubit>(
        create: (context) => OrdersCubit(),
        child: Booking(),
      ),
  AppRoutes.driversOrder:
      (context) => BlocProvider(
        create: (context) => OrdersCubit(),
        child: DriversOrders(),
      ),
  AppRoutes.driversScreen:
      (context) => BlocProvider(
        create: (context) => DriverCubit(),
        child: DriversScreen(),
      ),
  AppRoutes.mainHome:
      (context) =>
          BlocProvider(create: (context) => DriverCubit(), child: MainHome()),
  AppRoutes.homeScreen: (context) => HomeScreen(),

  AppRoutes.paymobScreen:
      (context) => BlocProvider(
        create: (context) => PaymentCubit(),
        child: PaymobScreen(),
      ),

  AppRoutes.servicesScreen: (context) => const Services(),

  AppRoutes.activityScreen: (context) => const Activity(),

  // driver
  AppRoutes.accountScreen: (context) => const Account(),
  AppRoutes.locationScreen: (context) => const LocationScreen(),
  AppRoutes.driverLocationScreen: (context) => const DriverLocationScreen(),
  AppRoutes.historyOrders: (context) => HistoryOrders(),
  AppRoutes.settingScreen: (context) => SettingScreen(),
  AppRoutes.paymentsScreen:
      (context) => BlocProvider(
        create: (context) => PaymentCubit(),
        child: PaymentsScreen(),
      ),
  AppRoutes.notificationsScreen:
      (context) => BlocProvider(
        create: (context) => NotificationCubit(),
        child: NotificationsScreen(),
      ),
};
