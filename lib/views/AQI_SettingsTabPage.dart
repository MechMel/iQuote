import 'package:axiom_hoist_quote_calculator/UI/custom_widgets/M2UIBuilders.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_EditDefaultsPage.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_EmergencyExportAllDialog.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_LoadingPage.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_SettingsPageUI.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'AQI_InputFields.dart';

class AQI_SettingsTabPage extends StatefulWidget {
  AQI_SettingsTabPage({Key key}) : super(key: key);

  @override
  _AQI_SettingsTabPageState createState() => _AQI_SettingsTabPageState();
}

class _AQI_SettingsTabPageState extends State<AQI_SettingsTabPage> {
  AQI_SettingsPageUI _settingsTabUI;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _settingsTabUI = AQI_SettingsPageUI();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AHSettings.settingsHaveBeenSetup) {
      return ListView(
        children: [
          Container(
            padding: EdgeInsets.all(AHStyle.pageMargins),
            child: _settingsTabUI,
          ),
        ],
      );
    } else {
      return AQI_LoadingPage.icon(Icons.settings, "Loading Settings...");
    }
  }
}