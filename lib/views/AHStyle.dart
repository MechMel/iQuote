import 'dart:developer';
import 'package:flutter/material.dart';
import 'IOSKeyboardDoneButton.dart';

class AHStyle {
  static const Color COLOR_PRIMARY = Color(0xFF006eb6);
  static const Color COLOR_ACCENT = Colors.white;
  static const Color COLOR_BACKGROUND = Colors.white;
  static const Color COLOR_BLACK = Colors.black;
  static const Color COLOR_HINT = Color(0xFFbfbfbf);
  static const Color COLOR_ERROR = Colors.red;
  static const InputBorder DEFAULT_VALUE_BORDER = OutlineInputBorder(
    borderSide: const BorderSide(color: COLOR_HINT, width: 1.0),
  );
  static const InputBorder CUSTOM_VALUE_BORDER = OutlineInputBorder(
    borderSide: const BorderSide(color: COLOR_BLACK, width: 1.0),
  );
  static const InputBorder TEXT_ERROR_BORDER = OutlineInputBorder(
    borderSide: const BorderSide(color: COLOR_ERROR, width: 1.0),
  );

  static double get iosKeyboardDoneButtonWidth {
    return 1.3 * lineHeight;
  }

  static double get iosKeyboardDoneButtonHeight {
    return 0.9 * lineHeight;
  }

  static Widget get iosKeyboardDoneButton {
    return M2IOSKeyboardDoneButton();
  }

  static FloatingActionButtonLocation get iosKeyboardDoneButtonLocation {
    return M2IOSKeyboardDoneButtonLocation(iosKeyboardDoneButtonHeight);
  }

  static FloatingActionButtonAnimator get iosKeyboardDoneButtonAnimator {
    return FloatingActionButtonAnimator.scaling;
  }

  static const double _SCREEN_WIDTH_IN_M2_UNITS = 24;
  static const double _MARGINS_IN_M2_UNITS = 1;
  static double get _internalPageWidthInM2Uits {
    return _SCREEN_WIDTH_IN_M2_UNITS - (_MARGINS_IN_M2_UNITS * 2.0);
  }

  static double _ratioOfM2UnitsToFlutterUnits;
  static double screenWidth;
  static double _screenHeight;
  static double get screenHeight {
    return _screenHeight;
  }

  static double get pageMargins {
    return _MARGINS_IN_M2_UNITS * _ratioOfM2UnitsToFlutterUnits;
  }

  static double get internalPageWidth {
    return _internalPageWidthInM2Uits * _ratioOfM2UnitsToFlutterUnits;
  }

  static double get lineHeight {
    return 2.5 * _ratioOfM2UnitsToFlutterUnits;
  }

  static double get buttonHeight {
    return 1 * lineHeight;
  }

  // TODO: Figure out how to make THEME_DATA a constant.
  static TextStyle textStyleHeadline;
  static TextStyle textStyleBody;
  static ThemeData themeData;

  static void setupAppStyle(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _ratioOfM2UnitsToFlutterUnits = screenWidth / _SCREEN_WIDTH_IN_M2_UNITS;
    log("_SCREEN_WIDTH_IN_M2_UNITS: $_SCREEN_WIDTH_IN_M2_UNITS");
    log("_ratioOfM2UnitsToFlutterUnits: $_ratioOfM2UnitsToFlutterUnits");
    textStyleHeadline = TextStyle(
        fontSize: 1.25 * _ratioOfM2UnitsToFlutterUnits,
        fontFamily: 'Myriad Pro',
        fontWeight: FontWeight.bold);
    textStyleBody = TextStyle(fontSize: 1 * _ratioOfM2UnitsToFlutterUnits);
    themeData = ThemeData(
      primaryColor: COLOR_PRIMARY,
      accentColor: COLOR_ACCENT,
      backgroundColor: COLOR_BACKGROUND,
      hintColor: COLOR_HINT,
      canvasColor: COLOR_BACKGROUND,
      unselectedWidgetColor: COLOR_HINT,
      errorColor: COLOR_ERROR,
      //primarySwatch: AHStyle.COLOR_PRIMARY,
      textTheme: TextTheme(
        headline: AHStyle.textStyleHeadline,
        title: AHStyle.textStyleHeadline,
        body1: AHStyle.textStyleBody,
      ),
      buttonTheme: ButtonThemeData(
        height: buttonHeight,
      ),
    );
  }
}
