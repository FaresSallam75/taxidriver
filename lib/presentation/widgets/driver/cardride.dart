import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCardRide extends StatelessWidget {
  final String image;
  final String rideName;
  final String count;
  final String time;
  final String waiting;
  final double discountPrice;
  final double price;
  final void Function()? onTap;
  final bool isPressed;
  final int index;
  const CustomCardRide({
    super.key,
    required this.image,
    required this.rideName,
    required this.count,
    required this.time,
    required this.waiting,
    required this.discountPrice,
    required this.price,
    required this.onTap,
    required this.isPressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        // padding: EdgeInsets.symmetric(vertical: 5.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isPressed ? MyColors.secondColor : MyColors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image, height: 80.0, width: 80.0, fit: BoxFit.fitWidth),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      rideName,
                      style: smallStyle.copyWith(color: MyColors.black),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.person, color: Colors.black, size: 20.0),
                    Text(
                      count,
                      style: smallStyle.copyWith(
                        color: MyColors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: smallStyle.copyWith(
                    color: MyColors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  waiting,
                  style: smallStyle.copyWith(
                    color: MyColors.grey,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.discount, color: Colors.green, size: 13.0),
                      Text(
                        "${discountPrice.toStringAsFixed(2)} EGP",
                        style: GoogleFonts.crimsonPro(
                          fontSize: 16,
                          color: MyColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${price.toStringAsFixed(2)} EGP",
                    style: GoogleFonts.crimsonPro(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: MyColors.secondColor,
                      color: MyColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
