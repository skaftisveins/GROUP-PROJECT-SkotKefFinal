import 'package:flutter/material.dart';
import 'package:skot_keflavik/constants.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  _saveTheme(bool theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', theme);
  }

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }

    _saveTheme(isLightTheme);
    notifyListeners();
  }
}

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Color(0xFF000000),
  brightness: Brightness.dark,
  backgroundColor: Color(0xFF232323),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.white),
  buttonColor: kAmber,
  dividerColor: Colors.black54,
  textTheme: TextTheme(
      headline: kDarkScreenTitleTextStyle,
      subtitle: kDarkSubTitleTextStyle,
      title: kDarkTitleTextStyle,
      body1: kDarkBody1TextStyle,
      body2: kDarkBody2TextStyle,
      display1: kDarkContentTextStyle,
      display2: kLinkStyle),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: kPrimaryColor,
  brightness: Brightness.light,
  backgroundColor: Color(0xFFE5E5E5),
  accentColor: kAccentColor,
  accentIconTheme: IconThemeData(color: kWhite),
  buttonColor: kPrimaryColor,
  dividerColor: Colors.white54,
  textTheme: TextTheme(
      headline: kScreenTitleTextStyle,
      subtitle: kSubTitleTextStyle,
      title: kTitleTextStyle,
      body1: kBody1TextStyle,
      body2: kBody2TextStyle,
      display1: kContentTextStyle,
      display2: kLinkStyle),
);
