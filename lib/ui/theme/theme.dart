import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Material colors builder can help (look on internet)

final lightColors = ColorScheme.light(
    primary: Colors.indigo,
    onPrimary: Colors.white,
    primaryContainer: Colors.indigo.shade100,
    onPrimaryContainer: const Color(0xff00105c),
    background: Colors.white,
    surface: Colors.grey.shade300,
    outline: Colors.grey.shade500);

final darkColors = ColorScheme.dark(
    primary: Colors.indigo.shade200,
    onPrimary: const Color(0xff08218a),
    primaryContainer: Colors.indigo.shade600,
    onPrimaryContainer: const Color(0xffdee0ff),
    background: const Color(0xff1C1B1F),
    surface: const Color(0xff33343f),
    surfaceVariant: const Color(0xff18191e),
    outline: Colors.grey.shade300);

const textTheme = TextTheme(
    bodyLarge: TextStyle(fontSize: 18), bodyMedium: TextStyle(fontSize: 16));

final lightTheme = ThemeData(
  colorScheme: lightColors,
  scaffoldBackgroundColor: lightColors.background,
  iconTheme: IconThemeData(color: lightColors.primary),
  dividerTheme: DividerThemeData(color: lightColors.outline),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: lightColors.background,
  ),
  appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
  textTheme: textTheme,
  useMaterial3: true,
);

final darkTheme = ThemeData(
    colorScheme: darkColors,
    scaffoldBackgroundColor: darkColors.background,
    iconTheme: IconThemeData(color: darkColors.primary),
    dividerTheme: DividerThemeData(color: darkColors.outline),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkColors.surfaceVariant,
    ),
    appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
    textTheme: textTheme,
    useMaterial3: true);

void setStatusAndNavbarTheme(BuildContext context) async {
  var colorNavbar = Theme.of(context).colorScheme.background;
  //Fallback must be a dark color since the icons will be white
  var colorFallback = lightTheme.colorScheme.onPrimaryContainer;
  var isDark = Theme.of(context).brightness == Brightness.dark;

  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 26) {
      //The status bar is already transparent and its icons have the right brightness by default
      //so we don't need to change that
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: colorNavbar,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark));
    } else {
      //For older android versions we cannot change the icons brightness so it is better to use a dark fallback
      //It does not seem to work on api 21 though
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          // statusBarColor: Colors.yellow,
          systemNavigationBarColor: colorFallback));
    }
  }
}
