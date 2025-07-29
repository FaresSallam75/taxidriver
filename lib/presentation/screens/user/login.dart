// ignore_for_file: unused_field

import 'package:chat/business_logic/auth/auth_cubit.dart';
import 'package:chat/constant/class/clippath.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/presentation/widgets/auth/custominputfield.dart';
import 'package:chat/presentation/widgets/auth/customprimarybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class UserLoginScreen extends StatefulWidget {
  int? index;
  UserLoginScreen({super.key, this.index});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  int? getIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getToken();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            CustomPaint(painter: WavesPainter(), child: Container()),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Login',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      InputField(
                        label: 'Email Address',
                        // initialValue: 'Enter Your Email Address',
                        validator:
                            (value) =>
                                value!.contains('@')
                                    ? null
                                    : 'Enter a valid email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        label: 'Password',
                        // initialValue: '**********',
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'password can not be empty'
                                    : value.length < 6
                                    ? 'Password too short'
                                    : null,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Login",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        onPressed: () async {
                          if (mounted) {
                            _isLoading = true;
                            setState(() {});
                          }

                          context.read<AuthCubit>().loginData(
                            context,
                            widget.index ?? 1,
                            _formKey,
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          await Future.delayed(Duration(seconds: 5));
                          if (mounted) {
                            _isLoading = false;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().resetPassword2(
                            emailController.text.trim(),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.userRegister,
                              );
                            },
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Color(0xFF6F35A5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
