import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHEmailController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:path/path.dart' as Path;

class AHEstimationFileView extends StatelessWidget {
  final String fileName;

  AHEstimationFileView(this.fileName, {Key key}) : super(key: key);

  void openFile() {
    AHAppController.swapToEstimation(fileName);
  }

  void deleteFile() {
    AHAppController.deleteEstimationFile(fileName);
  }

  Widget getDeleteDialog(BuildContext context) {
    return AlertDialog(
      //title: AHBodyText("Are you sure you want to delete $fileName"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AHBodyText("Are you sure you want to delete $fileName."),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            deleteFile();
            Navigator.of(context).pop();
          },
          textColor: AHStyle.COLOR_PRIMARY,
          child: const Text('Yes'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: AHStyle.COLOR_PRIMARY,
          child: const Text('No'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: AHStyle.internalPageWidth,
        height: 1.25 * AHStyle.lineHeight,
        child: OutlineButton(
          onPressed: openFile,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AHBodyText(getDisplayNameForQuoteFile(fileName)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {
                      AQI_QuoteController quoteToEmail =
                          AQI_QuoteController.fromFile(fileName);
                      AHEmailController.emailEstimation(quoteToEmail);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            getDeleteDialog(context),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  String getDisplayNameForQuoteFile(String quoteFileName) {
    String fileLabel = "";
    String quoteFileNameWithoutExtension =
        Path.basenameWithoutExtension(quoteFileName);
    List<String> labelPieces = quoteFileNameWithoutExtension.split("_");

    // We'll handle the last two pieces differently
    for (int pieceIndex = 0;
        pieceIndex < labelPieces.length - 2;
        pieceIndex++) {
      fileLabel += labelPieces[pieceIndex] + " ";
    }
    fileLabel += labelPieces[labelPieces.length - 2] +
        " - #" +
        labelPieces[labelPieces.length - 1];

    return fileLabel;
  }
}
