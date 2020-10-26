import 'package:flutter/material.dart';

// dark mode switch
enum MyTheme { Light, Dark }

class ThemeNotifier extends ChangeNotifier {
  static List<ThemeData> themes = [
    ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Color(0xff393E46),
          ),
          filled: true,
          fillColor: Color(0xffeeeeee),
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
          elevation: 0,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        primaryColor: Color(0xff00adb5),
        primaryColorLight: Color(0xff00adb5),
        accentColor: Color(0xff393e46),
        buttonColor: Color(0xffeeeeee),
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarColor: Colors.white,
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        backgroundColor: Color(0xff393E46)),
    ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
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
      primaryColorDark: Color(0xff00adb5),
      accentColor: Color(0xff393e46),
      buttonColor: Color(0xffeeeeee),
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
