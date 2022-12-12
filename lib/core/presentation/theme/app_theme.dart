import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode ? ThemeMode.dark : ThemeMode.light;
});

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData(
    // scaffoldBackgroundColor: whiteColor,
    primaryColor: primaryColor,
    primarySwatch: primaryColorMaterial,
    iconTheme: const IconThemeData(color: blackColor),
    brightness: Brightness.light,
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 16, color: blackColor),
      labelStyle: TextStyle(fontSize: 14, color: blackColor),
      floatingLabelStyle: TextStyle(fontSize: 14, color: primaryColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: whiteColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: whiteColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: whiteColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
    ),
    cardColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLightColor,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor),
    buttonTheme: const ButtonThemeData(
      disabledColor: Color(0xFFF3F3F6),
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w200,
      ),
      titleMedium: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: "Circular Std",
        color: blackColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w200,
      ),
      labelMedium: TextStyle(
        fontFamily: "Circular Std",
        color: blackColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w200,
      ),
      labelLarge: TextStyle(
        fontFamily: "Circular Std",
        color: blackColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w200,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDarkColor,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(color: primaryColor),
    primaryColor: primaryColor,
    primarySwatch: primaryColorMaterial,
    brightness: Brightness.dark,
    cardColor: blackSubColor,
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 16, color: textColor),
      labelStyle: TextStyle(fontSize: 14, color: whiteColor),
      floatingLabelStyle: TextStyle(fontSize: 14, color: primaryColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: greyColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: greyColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: greyColor),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      disabledColor: Color(0xFFF3F3F6),
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: "Caros",
        color: whiteColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w200,
      ),
      titleMedium: TextStyle(
        fontFamily: "Caros",
        color: blackColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: "Circular Std",
        color: whiteColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w200,
      ),
      labelMedium: TextStyle(
        fontFamily: "Circular Std",
        color: whiteColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w200,
      ),
      labelLarge: TextStyle(
        fontFamily: "Circular Std",
        color: whiteColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w200,
      ),
    ),
  );
}
