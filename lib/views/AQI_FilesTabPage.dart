import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHEstimationFileView.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_LoadingPage.dart';
import 'package:flutter/material.dart';

class AQI_FilesTabPage extends StatefulWidget {
  AQI_FilesTabPage({Key key}) : super(key: key);

  @override
  _AQI_FilesTabPageState createState() => _AQI_FilesTabPageState();
}

class _AQI_FilesTabPageState extends State<AQI_FilesTabPage> {
  bool buildIsInProgress = false;

  void updateState() async {
    await M2FlutterUtilities.when(() {return buildIsInProgress == false;});
    setState(() {});
  }

  @override
  void initState() {
    AHAppController.onEstimationSaveFilesChanged.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    AHAppController.onEstimationSaveFilesChanged.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget fileManagerView;
    buildIsInProgress = true;
    if (AHDiskController.diskControllerHasBeenSetup) {
      fileManagerView = ListView(
        children: [
          Container(
            padding: EdgeInsets.all(AHStyle.pageMargins),
            child: _generateFileManagerArea(context),
          ),
        ],
      );
    } else {
      fileManagerView = AQI_LoadingPage.icon(Icons.folder, "Loading Files...");
    }
    buildIsInProgress = false;
    return fileManagerView;
  }

  Widget _generateFileManagerArea(BuildContext context) {
    List<String> estimationFileNames = AHAppController.getSavedQuotesFileNames();
    Column filesColumn = Column(children: <Widget>[],);

    for (String estimationFileName in estimationFileNames) {
      AHEstimationFileView estimationFileWidget = AHEstimationFileView(estimationFileName);
      filesColumn.children.add(estimationFileWidget);
    }

    return filesColumn;
  }
}