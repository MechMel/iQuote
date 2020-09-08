import 'dart:io';

import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:flutter/material.dart';

class M2IOSKeyboardDoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS && MediaQuery.of(context).viewInsets.bottom > 0.0) {
      return Container(
        alignment: Alignment.centerRight,
        width: AHStyle.screenWidth,
        height: AHStyle.iosKeyboardDoneButtonHeight,
        color: AHStyle.COLOR_HINT,
        child: Container(
          width: AHStyle.iosKeyboardDoneButtonWidth,
          height: AHStyle.iosKeyboardDoneButtonHeight,
          child: FlatButton(
            onPressed: () {
              AHAppController.closeTheKeyboard(context);
            },
            child: Icon(Icons.done, color: AHStyle.COLOR_BACKGROUND,),
            color: AHStyle.COLOR_PRIMARY,
          ),
        ),
      );
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }
}

class M2IOSKeyboardDoneButtonLocation extends FloatingActionButtonLocation {
  final double _buttonHeight;

  M2IOSKeyboardDoneButtonLocation(this._buttonHeight);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    double offsetY = scaffoldGeometry.contentBottom - _buttonHeight;
    return Offset(0.0, offsetY);
  }
}