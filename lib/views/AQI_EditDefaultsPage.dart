import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_CraneCategoriesController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_CraneCategorySettingsView.dart';
import 'package:axiom_hoist_quote_calculator/views/IOSKeyboardDoneButton.dart';
import 'package:flutter/material.dart';

class AQI_EditDefaultsPage extends StatefulWidget {
  AQI_EditDefaultsPage({Key key}) : super(key: key);

  @override
  _AQI_EditDefaultsPageState createState() => _AQI_EditDefaultsPageState();
}

class _AQI_EditDefaultsPageState extends State<AQI_EditDefaultsPage> {
  bool _buildIsInProgress = false;

  void updateState() async {
    await M2FlutterUtilities.when(() {
      return !_buildIsInProgress;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _buildIsInProgress = true;

    Scaffold page = Scaffold(
      appBar: AppBar(
        //title: AHHeadlineText(title),
        title: Container(
          height: 1.35 * AHStyle.lineHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AHHeadlineText("Edit Crane Categories",
                  color: AHStyle.COLOR_BACKGROUND),
            ],
          ),
        ),
        backgroundColor: AHStyle.COLOR_PRIMARY,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(AHStyle.pageMargins),
            child:
                Column(children: _buildCraneCategoriesAndDefaultsArea(context)),
          ),
        ],
      ),
      floatingActionButton: AHStyle.iosKeyboardDoneButton,
      floatingActionButtonLocation: AHStyle.iosKeyboardDoneButtonLocation,
      floatingActionButtonAnimator: AHStyle.iosKeyboardDoneButtonAnimator,
    );
    _buildIsInProgress = false;

    return page;
  }

  List<Widget> _buildCraneCategoriesAndDefaultsArea(BuildContext context) {
    List<Widget> craneCategoryWidgets = List();

    // Active Crane Categories
    for (int id in AQI_CraneCategoriesController.getAllCraneCategoriesIDs()) {
      if (craneCategoryWidgets.length != 0) {
        craneCategoryWidgets.add(Container(
          height: AHStyle.pageMargins,
        ));
      }
      craneCategoryWidgets.add(AQI_CraneCategorySettingsView(id, updateState));
      craneCategoryWidgets.add(Container(
        height: AHStyle.pageMargins,
      ));
    }

    craneCategoryWidgets.add(Container(
      height: AHStyle.pageMargins,
    ));
    craneCategoryWidgets.add(
      Container(
        height: 1.5 * AHStyle.lineHeight,
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: AHStyle.COLOR_BACKGROUND,
              ),
              AHBodyText(
                " Create New Category",
                color: AHStyle.COLOR_BACKGROUND,
              ),
            ],
          ),
          onPressed: () {
            AQI_CraneCategoriesController.createNewCraneCategory();
            updateState();
          },
          color: AHStyle.COLOR_PRIMARY,
        ),
      ),
    );
    craneCategoryWidgets.add(Container(
      height: AHStyle.pageMargins,
    ));
    craneCategoryWidgets.add(
      Container(
        height: 1.5 * AHStyle.lineHeight,
        child: OutlineButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.mail,
                color: AHStyle.COLOR_PRIMARY,
              ),
              AHBodyText(
                " Mail Categories to Dev",
                color: AHStyle.COLOR_PRIMARY,
              ),
            ],
          ),
          onPressed: () {
            AHAppController.mailCraneCategoriesToTKE();
          },
          borderSide: BorderSide(color: AHStyle.COLOR_PRIMARY),
        ),
      ),
    );

    return craneCategoryWidgets;
  }
}
