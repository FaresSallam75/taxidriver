import 'package:chat/constant/class/colors.dart';
import 'package:flutter/material.dart';

ThemeData themeEnglish = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0.3,
    iconTheme: IconThemeData(color: MyColors.bg),
    titleTextStyle: TextStyle(
      color: MyColors.header01,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: "TwitterIcon",
    ), // Cairo

    backgroundColor: MyColors.bg, // Colors.grey.shade50,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.primary,
  ),
  fontFamily: "TwitterIcon", //TwitterIcon  //HelveticaNeue
  textTheme: const TextTheme(
    /*   titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.secondColor), */
    headlineLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MyColors.header01,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: MyColors.header01,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontSize: 10,
      color: MyColors.header01,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontSize: 17,
      color: MyColors.bg,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      height: 1.5,
      color: MyColors.grey01,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    bodyMedium: TextStyle(color: MyColors.grey01, fontSize: 17),
    bodySmall: TextStyle(color: MyColors.grey01, fontSize: 15),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
);

ThemeData themeArabic = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0.0,
    iconTheme: IconThemeData(color: MyColors.bg),
    titleTextStyle: TextStyle(
      color: MyColors.header01,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: "Cairo",
    ), // Cairo

    backgroundColor: MyColors.bg, // Colors.grey.shade50,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.primary,
  ),
  fontFamily: "Cairo", //TwitterIcon  //HelveticaNeue
  textTheme: const TextTheme(
    /*   titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.secondColor), */
    headlineLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MyColors.header01,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: MyColors.header01,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontSize: 17,
      color: MyColors.header01,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      height: 1.5,
      color: MyColors.grey01,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    bodyMedium: TextStyle(color: MyColors.grey01, fontSize: 17),
    bodySmall: TextStyle(color: MyColors.grey01, fontSize: 15),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
);

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat UI',
//       theme: ThemeData(
//         // Use Material 3 design principles
//         useMaterial3: true,
//         // Define a color scheme (you can customize this extensively)
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple, // Base color
//           brightness: Brightness.light, // Or Brightness.dark for dark mode
//           surface: Colors.grey.shade100, // Background color
//         ),
//         // Customize text themes if needed
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(fontSize: 16.0),
//           bodyMedium: TextStyle(fontSize: 14.0),
//           bodySmall: TextStyle(fontSize: 12.0),
//         ),
//         // AppBar theme (optional, can rely on colorScheme)
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.grey.shade100,
//           foregroundColor: Colors.black87,
//           elevation: 1.0,
//         ),
//       ),
//       // Dark theme example (uncomment to test)
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//           surface: Colors.grey.shade900,
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(fontSize: 16.0),
//           bodyMedium: TextStyle(fontSize: 14.0),
//           bodySmall: TextStyle(fontSize: 12.0),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.grey.shade900,
//           foregroundColor: Colors.white,
//           elevation: 1.0,
//         ),
//       ),
//       themeMode: ThemeMode.system, // Automatically switch between light/dark
//       debugShowCheckedModeBanner: false,
//       home: ChatPage(), // Start with the Chat Page
//       // Add Arabic localization support if needed
//       localizationsDelegates: [
//         // GlobalMaterialLocalizations.delegate,
//         // GlobalWidgetsLocalizations.delegate,
//         // GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('ar', ''), // Arabic
//         // const Locale('en', ''), // English
//       ],
//       locale: const Locale('ar', ''), // Set default locale to Arabic
//     );
//   }
// }
