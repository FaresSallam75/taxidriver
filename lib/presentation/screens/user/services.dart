import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/class/imageasset.dart';
import 'package:chat/constant/class/routes.dart';
import 'package:chat/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> pictures = [
      {"image": AppImageAsset.carOne, "name": "Ride"},
      {"image": AppImageAsset.carthree, "name": "Scoter"},
      {"image": AppImageAsset.carfour, "name": "Mini Bus"},
    ];
    return Container(
      color: MyColors.white,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          customText("Services", MyColors.black, 20.0, 15.0, 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 70.0,
              horizontal: 15.0,
            ),
            child: ListView(
              // shrinkWrap: true,
              // physics: const ClampingScrollPhysics(),
              children: [
                Text(
                  "Go anywhere, get anything",
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.displayLarge,

                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ServiceCard(
                        text: "${pictures[0]['name']}",
                        image: "${pictures[0]['image']}",
                        promo: true,
                      ),
                    ),
                    Expanded(
                      child: ServiceCard(
                        text: "${pictures[1]['name']}",
                        image: "${pictures[1]['image']}",
                      ),
                    ),
                    Expanded(
                      child: ServiceCard(
                        text: "${pictures[2]['name']}",
                        image: "${pictures[2]['image']}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customText(
    String text,
    Color? color,
    double fontSize,
    double horizontal,
    double vertical,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Text(
        text,
        style: smallStyle.copyWith(color: color, fontSize: fontSize),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String text;
  final String image;
  final bool promo;

  const ServiceCard({
    super.key,
    required this.text,
    required this.image,
    this.promo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: 120,
          // padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MyColors.grey01,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.locationScreen);
            },
            child: Card(
              color: MyColors.grey01,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      image,
                      height: 80.0,
                      width: 80.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.aBeeZee(
                        textStyle: smallStyle.copyWith(fontSize: 12.0),
                        color: MyColors.black,
                      ),
                      // style: GoogleFonts.lato(
                      //   textStyle: smallStyle,
                      //   fontSize: 13.0,
                      //   color: MyColors.black,
                      //   fontWeight: FontWeight.w400,
                      //   fontStyle: FontStyle.normal,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (promo)
          Positioned(
            // top: 0.0,
            left: 6.0,
            // right: 6.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 35.0),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Promo',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
