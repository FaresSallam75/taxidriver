import 'package:chat/constant/class/colors.dart' show MyColors;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: 200.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.grey01,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.crimsonPro(
            fontSize: 18,
            color: MyColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  const CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      text,
      style: GoogleFonts.crimsonPro(
        fontSize: 16,
        color: MyColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
