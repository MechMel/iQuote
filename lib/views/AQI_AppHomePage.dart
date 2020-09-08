import 'dart:developer';
import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_ActiveQuoteTabPage.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_FilesTabPage.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_SettingsTabPage.dart';
import 'package:flutter/material.dart';

class AQI_AppHomePage extends StatefulWidget {
  AQI_AppHomePage({Key key}) : super(key: key);

  @override
  _AQI_AppHomePageState createState() => _AQI_AppHomePageState();
}

class _AQI_AppHomePageState extends State<AQI_AppHomePage>
    with SingleTickerProviderStateMixin {
  bool _buildIsInProgress = false;
  TabController _tabController;

  void onActiveEstimationChanged() async {
    await M2FlutterUtilities.when(() {
      return !_buildIsInProgress;
    });
    if (_tabController.index != 1) {
      _tabController.animateTo(1);
    }
  }

  @override
  void initState() {
    super.initState();
    AHAppController.onActiveEstimationChanged
        .addListener(onActiveEstimationChanged);
    _tabController = new TabController(length: 3, initialIndex: 1, vsync: this);
    _tabController.addListener(closeTheKeyboard);
  }

  @override
  void dispose() {
    AHAppController.onActiveEstimationChanged
        .removeListener(onActiveEstimationChanged);
    _tabController.removeListener(closeTheKeyboard);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildIsInProgress = true;
    Scaffold page = Scaffold(
      appBar: AppBar(
        //title: AHHeadlineText(title),
        title: Container(
          alignment: Alignment.center,
          height: 1.35 * AHStyle.lineHeight,
          child: Image.asset('assets/app_bar_logo.png'),
        ),
        backgroundColor: AHStyle.COLOR_PRIMARY,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Row(
              children: [
                Icon(
                  Icons.folder,
                  color: AHStyle.COLOR_BACKGROUND,
                  size: 0.5 * AHStyle.lineHeight,
                ),
                AHTab(
                  text: " Files",
                  textColor: AHStyle.COLOR_BACKGROUND,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: AHStyle.COLOR_BACKGROUND,
                  size: 0.5 * AHStyle.lineHeight,
                ),
                AHTab(
                  text: " Quote",
                  textColor: AHStyle.COLOR_BACKGROUND,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: AHStyle.COLOR_BACKGROUND,
                  size: 0.5 * AHStyle.lineHeight,
                ),
                AHTab(
                  text: " Settings",
                  textColor: AHStyle.COLOR_BACKGROUND,
                ),
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AQI_FilesTabPage(),
          AQI_ActiveQuoteTabPage(),
          AQI_SettingsTabPage(),
        ],
      ),
      floatingActionButton: AHStyle.iosKeyboardDoneButton,
      floatingActionButtonLocation: AHStyle.iosKeyboardDoneButtonLocation,
      floatingActionButtonAnimator: AHStyle.iosKeyboardDoneButtonAnimator,
    );
    _buildIsInProgress = false;

    return page;
  }

  void closeTheKeyboard() {
    AHAppController.closeTheKeyboard(context);
  }
}
