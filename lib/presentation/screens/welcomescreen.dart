// ignore_for_file: library_private_types_in_public_api

import 'package:chat/business_logic/auth/auth_cubit.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/styles.dart';
import 'package:chat/presentation/screens/driver/login.dart';
import 'package:chat/presentation/screens/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    timeDilation = 2.0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.decelerate),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1416).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Navigate to next screen after animations complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..scale(_scaleAnimation.value)
                        ..rotateZ(_rotateAnimation.value),
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: MyColors.darkBlue, //Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(
                  "assets/images/taxi.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Text(
                    'Welcome to',
                    style: kTitleStyle.copyWith(
                      color: MyColors.darkBlue,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Taxi-Driver',
                    style: kTitleStyle.copyWith(
                      color: MyColors.darkBlue,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            customAnimatedButton(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => AuthCubit(),
                        child: DriverLoginScreen(index: 0),
                      ),
                ),
              );
            }, "Driver"),
            SizedBox(height: 20.0),
            customAnimatedButton(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => AuthCubit(),
                        child: UserLoginScreen(index: 1),
                      ),
                ),
              );
            }, "User"),
          ],
        ),
      ),
    );
  }

  Widget customAnimatedButton(void Function()? onPressed, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
          ),
        ),
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 8,
            ),
            child: Text(
              text,
              style: kFilterStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
