import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_AppHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';

class AHAppUI extends StatefulWidget {
  static void Function() _reloadUI;

  AHAppUI({Key key}) : super(key: key);

  @override
  _AHAppUIState createState() => _AHAppUIState();

  static void reloadUI() {
    if (_reloadUI != null) {
      _reloadUI();
    }
  }

  static void setReloadUIFunction(void Function() newReloadUIFunc) {
    _reloadUI = newReloadUIFunc;
  }
}

class _AHAppUIState extends State<AHAppUI> {
  bool _buildIsInProgress = false;

  @override
  void initState() {
    AHAppUI.setReloadUIFunction(_updateState);
    super.initState();
  }

  @override
  void dispose() {
    AHAppUI.setReloadUIFunction(null);
    super.dispose();
  }

  void _updateState() async {
    await M2FlutterUtilities.when(() {return !_buildIsInProgress;});
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () {
        AHAppController.closeTheKeyboard(context);
      },
      child: MaterialApp(
        title: "Axiom Q Inspect",
        theme: AHStyle.themeData,
        home: AQI_AppHomePage(),
        debugShowCheckedModeBanner: false,
        //home: AQI_EditDefaultsPage(),
      ),
    );
  }
}