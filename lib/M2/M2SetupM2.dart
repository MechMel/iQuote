import 'dart:async';
import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class M2SetupM2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AHStyle.themeData,
      home: _InitStyleWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Init_Properties {
  static bool isInInit = false;
  static bool initHasTimedOut = false;
}

class _InitStyleWidget extends StatefulWidget {
  _InitStyleWidget({Key key}) : super(key: key);

  _InitStyleWidgetState createState() => _InitStyleWidgetState();
}

class _InitStyleWidgetState extends State<_InitStyleWidget> {
  bool _buildIsInProgress = false;

  @override
  void initState() {
    super.initState();
    _Init_Properties.isInInit = true;
    checkForTimeOut();
  }

  @override
  void dispose() {
    _Init_Properties.isInInit = false;
    super.dispose();
  }

  void checkForTimeOut() async {
    await Future.delayed(Duration(seconds: 3));

    if (_Init_Properties.isInInit == true &&
        !_Init_Properties.initHasTimedOut) {
      _Init_Properties.initHasTimedOut = true;
      updateState();
    }
  }

  void updateState() async {
    await M2FlutterUtilities.when(() {
      return _buildIsInProgress == false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _buildIsInProgress = true;

    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    AHStyle.setupAppStyle(context);

    Widget scaffold = Scaffold(
      body: AQI_LoadingPage.image(
        "assets/splash_screen_logo.jpg",
        "IQuote",
        color: AHStyle.COLOR_PRIMARY,
      ),
      floatingActionButton: getErrorButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

    _buildIsInProgress = false;

    return scaffold;
  }

  Widget getErrorButton() {
    if (_Init_Properties.initHasTimedOut) {
      return FlatButton(
        onPressed: AHAppController.exportAllSavedFiles,
        color: AHStyle.COLOR_ERROR,
        child: Container(
          width: AHStyle.lineHeight * 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                color: AHStyle.COLOR_BACKGROUND,
              ),
              AHBodyText(
                " Possible error! Press this.",
                color: AHStyle.COLOR_BACKGROUND,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}
