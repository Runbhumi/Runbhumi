import 'package:flutter/material.dart';

/*
class ThemeConfig {
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Color(0xff121212);
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
*/
//class ThemeConfig {
//  static ThemeData lightTheme = ThemeData(
//    visualDensity: VisualDensity.adaptivePlatformDensity,
//    inputDecorationTheme: InputDecorationTheme(
//      hintStyle: TextStyle(
//        color: Color(0xff393E46),
//      ),
//      filled: true,
//      fillColor: Color(0xffeeeeee),
//      hoverColor: Colors.white,
//      alignLabelWithHint: true,
//      border: OutlineInputBorder(
//        borderRadius: new BorderRadius.circular(50),
//        borderSide: BorderSide(
//          color: Color(0xff00adb5),
//          width: 2.0,
//        ),
//      ),
//      // focusedBorder: focusedBorder(context),
//    ),
//    bottomAppBarTheme: BottomAppBarTheme(
//      color: Colors.white,
//      elevation: 0,
//    ),
//    appBarTheme: AppBarTheme(
//      color: Colors.white,
//      elevation: 0,
//      brightness: Brightness.light,
//      centerTitle: true,
//      iconTheme: IconThemeData(
//        color: Colors.black,
//      ),
//    ),
//    primaryColor: Color(0xff00adb5),
//    primaryColorLight: Color(0xff00adb5),
//    accentColor: Color(0xff393e46),
//    buttonColor: Color(0xffeeeeee),
//    scaffoldBackgroundColor: Colors.white,
//    bottomAppBarColor: Colors.white,
//    fontFamily: 'Montserrat',
//    brightness: Brightness.light,
//    primaryColorBrightness: Brightness.light,
//  );
//
//  static ThemeData darkTheme = ThemeData(
//    visualDensity: VisualDensity.adaptivePlatformDensity,
//    appBarTheme: AppBarTheme(
//        color: Colors.black26,
//        elevation: 0,
//        brightness: Brightness.dark,
//        centerTitle: true,
//        iconTheme: IconThemeData(
//          color: Colors.white,
//        ),
//        actionsIconTheme: IconThemeData(
//          color: Colors.white,
//        )),
//    inputDecorationTheme: InputDecorationTheme(
//      hintStyle: TextStyle(
//        color: Color(0xff333333),
//      ),
//      filled: true,
//      fillColor: Colors.black,
//      alignLabelWithHint: true,
//      border: OutlineInputBorder(
//        borderRadius: new BorderRadius.circular(50),
//        borderSide: BorderSide(
//          color: Color(0xffB3ABAB),
//          width: 2.0,
//        ),
//      ),
//      // focusedBorder: focusedBorder(context),
//    ),
//    primaryColor: Color(0xff00adb5),
//    primaryColorLight: Color(0xff00adb5),
//    accentColor: Color(0xff393e46),
//    buttonColor: Color(0xffeeeeee),
//    bottomNavigationBarTheme: BottomNavigationBarThemeData(
//      backgroundColor: Colors.black45,
//      elevation: 10,
//      selectedItemColor: Color(0xff00adb5),
//    ),
//    fontFamily: 'Montserrat',
//    brightness: Brightness.dark,
//  );
//
//  OutlineInputBorder focusedBorder(BuildContext context) {
//    return OutlineInputBorder(
//      borderRadius: new BorderRadius.circular(50),
//      borderSide: BorderSide(
//        color: Color(0xff00adb5),
//        width: 2.0,
//      ),
//    );
//  }
//
//  OutlineInputBorder border() {
//    return OutlineInputBorder(
//      borderRadius: new BorderRadius.circular(50),
//      borderSide: BorderSide(
//        color: Color(0xffB3ABAB),
//        width: 1.0,
//      ),
//    );
//  }
//}

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
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Color(0xff00adb5),
            width: 2.0,
          ),
        ),
        // focusedBorder: focusedBorder(context),
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
    ),
    ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          color: Colors.black26,
          elevation: 0,
          brightness: Brightness.dark,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          )),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff333333),
        ),
        filled: true,
        fillColor: Colors.black,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Color(0xffB3ABAB),
            width: 2.0,
          ),
        ),
        // focusedBorder: focusedBorder(context),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xff00adb5),
      accentColor: Color(0xff393e46),
      buttonColor: Color(0xffeeeeee),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        elevation: 10,
        selectedItemColor: Color(0xff00adb5),
      ),
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
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

  get currentTheme => _currentTheme;

  void switchTheme() => _current == MyTheme.Light
      ? currentTheme = MyTheme.Dark
      : currentTheme = MyTheme.Light;

  OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xff00adb5),
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
}

/*
ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff393E46),
        ),
        filled: true,
        fillColor: Color(0xffeeeeee),
        hoverColor: Colors.white,
        alignLabelWithHint: true,
        border: border(),
        focusedBorder: focusedBorder(context),
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
    );
  }

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          color: Colors.black26,
          elevation: 0,
          brightness: Brightness.dark,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          )),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff333333),
        ),
        filled: true,
        fillColor: Colors.black,
        alignLabelWithHint: true,
        border: border(),
        focusedBorder: focusedBorder(context),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xff00adb5),
      accentColor: Color(0xff393e46),
      buttonColor: Color(0xffeeeeee),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        elevation: 10,
        selectedItemColor: Color(0xff00adb5),
      ),
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
    );
  }

  OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xff00adb5),
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
  */
