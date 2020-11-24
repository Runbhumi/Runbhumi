import 'package:flutter/material.dart';

// dark mode switch
enum MyTheme { Light, Dark }

class ThemeNotifier extends ChangeNotifier {
  static List<ThemeData> themes = [
    ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardTheme(
        shadowColor: Color(0x20333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xffCBC6CB),
        ),
        filled: true,
        fillColor: Color(0xffF3F0F4),
        hoverColor: Colors.white,
        alignLabelWithHint: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white,
        elevation: 1,
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xffF7F7FF),
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xffc2fcff),
      primaryColorDark: Color(0xff004E52),
      accentColor: Color(0xffEA526F),
      buttonColor: Color(0xffEA526F),
      scaffoldBackgroundColor: Color(0xffF7F7FF),
      bottomAppBarColor: Colors.white,
      fontFamily: 'Montserrat',
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      backgroundColor: Color(0xff393E46),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: Color(0xffEA526F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundColor: Colors.white,
      ),
    ),
    ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardTheme(
        shadowColor: Color(0x20333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 20,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: Color(0xffEA526F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        color: Color((0xff121212)),
        elevation: 0,
        brightness: Brightness.dark,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff333333),
        ),
        filled: true,
        fillColor: Colors.black,
        alignLabelWithHint: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xffc2fcff),
      primaryColorDark: Color(0xff004E52),
      accentColor: Color(0xffEA526F),
      buttonColor: Color(0xffEA526F),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        elevation: 10,
        selectedItemColor: Color(0xff00adb5),
      ),
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
      backgroundColor: Color(0xffffffff),
    ),
  ];

  MyTheme _current = MyTheme.Light;
  ThemeData _currentTheme = themes[0];

  set currentTheme(theme) {
    if (theme != null) {
      _current = theme;
      _currentTheme = _current == MyTheme.Light ? themes[0] : themes[1];
      notifyListeners();
    }
  }

  get myTheme => _current;

  ThemeData get currentTheme => _currentTheme;

  void switchTheme() => _current == MyTheme.Light
      ? currentTheme = MyTheme.Dark
      : currentTheme = MyTheme.Light;
}
