// ignore_for_file: deprecated_member_use

import 'package:chat/constant/class/colors.dart' show MyColors;
import 'package:chat/presentation/widgets/booking/customelevatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBodyTable extends StatelessWidget {
  const CustomBodyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      textBaseline: TextBaseline.alphabetic,
      border: TableBorder.all(
        color: MyColors.black,
        width: 0.5,
        borderRadius: BorderRadius.circular(10.0),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: MyColors.grey01),
          children: [CustomText(text: "Distance"), CustomText(text: "Price")],
        ),
        TableRow(
          children: [CustomText(text: "20 km"), CustomText(text: "100 EGP")],
        ),

        TableRow(
          children: [CustomText(text: "50 km"), CustomText(text: "250 EGP")],
        ),
        TableRow(
          children: [
            CustomText(text: "50 - 90 Km"),
            CustomText(text: "550 EGP"),
          ],
        ),

        TableRow(
          children: [CustomText(text: "100+ km"), CustomText(text: "1000 EGP")],
        ),
        TableRow(
          children: [CustomText(text: "150+ km"), CustomText(text: "2000 EGP")],
        ),
      ],
    );
  }
}

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210.0,
      decoration: BoxDecoration(
        color: MyColors.grey01,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Icon(Icons.discount, color: Colors.green, size: 15.0),
          Text(
            text,
            style: GoogleFonts.crimsonPro(
              fontSize: 14,
              color: MyColors.black.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
