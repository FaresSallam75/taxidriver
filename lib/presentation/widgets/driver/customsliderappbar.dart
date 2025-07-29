import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class CustomSliderAppBar extends StatelessWidget {
  final String text;
  const CustomSliderAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SliderAppBar(
      config: SliderAppBarConfig(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 50.0),
        title: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
