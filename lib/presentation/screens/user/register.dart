// ignore_for_file: must_be_immutable, unused_field

import 'package:chat/business_logic/auth/auth_cubit.dart';
import 'package:chat/constant/class/clippath.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/presentation/widgets/auth/custominputfield.dart';
import 'package:chat/presentation/widgets/auth/customprimarybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRegisterScreen extends StatefulWidget {
  int? index;
  UserRegisterScreen({super.key, this.index});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward(); // Start animation on page load
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    InputField(
                      label: 'Name',
                      // initialValue: 'Enter Your Name',
                      validator:
                          (value) =>
                              value!.length < 4 ? 'Name too short' : null,
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
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
                      child: Text(
                        'Create Account',
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
                        context.read<AuthCubit>().registerData(
                          context,
                          widget.index ?? 1,
                          _formKey,
                          nameController.text.trim(),
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
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.userLogin,
                            );
                          },
                          child: const Text(
                            'Login',
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
    );
  }
}
