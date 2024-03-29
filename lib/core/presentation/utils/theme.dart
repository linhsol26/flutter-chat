// import 'package:chat/core/presentation/theme/colors.dart';
// import 'package:flutter/material.dart';

// enum ThemeType { dark, light }

// class AppTheme {
//   AppTheme._();

//   static final lightTheme = ThemeData(
//     // backgroundColor: whiteColor,
//     scaffoldBackgroundColor: blackColor,
//     appBarTheme: const AppBarTheme(backgroundColor: blackColor),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: whiteColor,
//       selectedItemColor: primaryColor,
//       unselectedItemColor: textColorGrey,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
//       selectedIconTheme: IconThemeData(color: primaryColor),
//       unselectedIconTheme: IconThemeData(color: textColorGrey),
//       selectedLabelStyle: TextStyle(
//         fontFamily: "Caros",
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//       unselectedLabelStyle: TextStyle(
//         fontFamily: "Caros",
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//     primaryColor: primaryColor,
//     primarySwatch: primaryColorMaterial,
//     iconTheme: const IconThemeData(color: blackColor),
//     brightness: Brightness.light,
//     buttonTheme: const ButtonThemeData(
//       disabledColor: Color(0xFFF3F3F6),
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       border: UnderlineInputBorder(borderSide: BorderSide(color: greyColor)),
//     ),
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 40.0,
//         fontWeight: FontWeight.w700,
//       ),
//       displayMedium: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 20.0,
//         fontWeight: FontWeight.w700,
//       ),
//       displaySmall: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 18.0,
//         fontWeight: FontWeight.w700,
//       ),
//       headlineMedium: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w700,
//       ),
//       bodyLarge: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//       bodyMedium: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w500,
//       ),
//       bodySmall: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w500,
//       ),
//       titleSmall: TextStyle(
//         fontFamily: "Caros",
//         color: blackColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelSmall: TextStyle(
//         fontFamily: "Circular Std",
//         color: blackColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelMedium: TextStyle(
//         fontFamily: "Circular Std",
//         color: blackColor,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelLarge: TextStyle(
//         fontFamily: "Circular Std",
//         color: blackColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w200,
//       ),
//     ),
//   );

//   static final darkTheme = ThemeData(
//     // backgroundColor: primaryColor,
//     scaffoldBackgroundColor: primaryColor,
//     appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: blackColor,
//       selectedItemColor: whiteColor,
//       unselectedItemColor: textColorGrey,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
//       selectedIconTheme: IconThemeData(color: whiteColor),
//       unselectedIconTheme: IconThemeData(color: textColorGrey),
//       selectedLabelStyle: TextStyle(
//         fontFamily: "Caros",
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//       unselectedLabelStyle: TextStyle(
//         fontFamily: "Caros",
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//     iconTheme: const IconThemeData(color: whiteColor),
//     primaryColor: primaryColor,
//     primarySwatch: primaryColorMaterial,
//     brightness: Brightness.dark,
//     inputDecorationTheme: const InputDecorationTheme(
//       hintStyle: TextStyle(color: textColorGrey),
//       border: UnderlineInputBorder(borderSide: BorderSide(color: greyColor)),
//       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: greyColor)),
//       disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: greyColor)),
//     ),
//     buttonTheme: const ButtonThemeData(
//       disabledColor: Color(0xFFF3F3F6),
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 40.0,
//         fontWeight: FontWeight.w700,
//       ),
//       displayMedium: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 20.0,
//         fontWeight: FontWeight.w700,
//       ),
//       displaySmall: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 18.0,
//         fontWeight: FontWeight.w700,
//       ),
//       headlineMedium: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w700,
//       ),
//       bodyLarge: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//       ),
//       bodyMedium: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w500,
//       ),
//       bodySmall: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w500,
//       ),
//       titleSmall: TextStyle(
//         fontFamily: "Caros",
//         color: whiteColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelSmall: TextStyle(
//         fontFamily: "Circular Std",
//         color: whiteColor,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelMedium: TextStyle(
//         fontFamily: "Circular Std",
//         color: whiteColor,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w200,
//       ),
//       labelLarge: TextStyle(
//         fontFamily: "Circular Std",
//         color: whiteColor,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w200,
//       ),
//     ),
//   );
// }
