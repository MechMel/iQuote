import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHLaborInfoView.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomerInfoView.dart';

class AQI_ActiveQuoteTabPage extends StatefulWidget {
  AQI_ActiveQuoteTabPage({Key key}) : super(key: key);

  @override
  _AQI_ActiveQuoteTabPageState createState() => _AQI_ActiveQuoteTabPageState();
}

class _AQI_ActiveQuoteTabPageState extends State<AQI_ActiveQuoteTabPage> {
  AHCustomerInfoView _customerInfoView;
  AHLaborInfoView _laborInfoView;
  ScrollController _scrollController;
  bool _buildIsInProgress = false;

  void rebuildCustomerInfoView() {
    if (AHAppController.activeQuoteController != null) {
      _customerInfoView = AHCustomerInfoView(
          AHAppController.activeQuoteController, _applyCustomerInfoChanges);
    }
  }

  void rebuildLaborInfoView() {
    if (AHAppController.activeQuoteController != null) {
      _laborInfoView = AHLaborInfoView(
          AHAppController.activeQuoteController, _applyLaborInfoChanges);
    }
  }

  void _applyCustomerInfoChanges(bool shouldReloadUI) {
    if (shouldReloadUI) {
      _updateState();
    }
  }

  void _applyLaborInfoChanges() {
    _updateState();
  }

  void rebuildActiveEstimationView() {
    _updateState();
  }

  void _newEstimationButtonPressed() {
    AHAppController.setActiveQuoteControllerToNewQuote();
    _scrollController.position.animateTo(0.0,
        duration: Duration(milliseconds: 175), curve: Curves.linear);
  }

  @override
  void initState() {
    AHAppController.onActiveEstimationChanged
        .addListener(rebuildActiveEstimationView);
    rebuildCustomerInfoView();
    rebuildLaborInfoView();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    AHAppController.onActiveEstimationChanged
        .removeListener(rebuildActiveEstimationView);
    super.dispose();
  }

  void _updateState() async {
    await M2FlutterUtilities.when(() {
      return !_buildIsInProgress;
    });
    setState(() {
      rebuildCustomerInfoView();
      rebuildLaborInfoView();
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildIsInProgress = true;
    Widget page = getEstimationView(context);
    _buildIsInProgress = false;
    return page;
  }

  Widget getEstimationView(BuildContext context) {
    if (AHAppController.activeQuoteController != null) {
      return ListView(
        controller: _scrollController,
        children: [
          Container(
            padding: EdgeInsets.all(AHStyle.pageMargins),
            child: Column(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.875,
                  child: _customerInfoView,
                ),
                Container(
                  height: AHStyle.pageMargins,
                ),
                _laborInfoView,
                Container(
                  height: 1.25 * AHStyle.lineHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        // TODO: This export should be relative to the current estimation, or this button should be part of AHAppUI.
                        onPressed: _newEstimationButtonPressed,
                        color: AHStyle.COLOR_PRIMARY,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.assignment,
                                color: AHStyle.COLOR_BACKGROUND,
                              ),
                              AHBodyText(
                                " New",
                                color: AHStyle.COLOR_BACKGROUND,
                              ),
                            ],
                          ),
                        ),
                      ),
                      FlatButton(
                        // TODO: This export should be relative to the current estimation, or this button should be part of AHAppUI.
                        onPressed: AHAppController.emailActiveQuote,
                        color: AHStyle.COLOR_PRIMARY,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: AHStyle.COLOR_BACKGROUND,
                              ),
                              AHBodyText(
                                " Send",
                                color: AHStyle.COLOR_BACKGROUND,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return AQI_LoadingPage.icon(Icons.assignment, "Loading Quote...");
    }
  }
}
