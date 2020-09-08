import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:flutter/material.dart';

class AQI_EmergencyExportAllDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: getContentsForWaitingForArchiveToComplete(),
    );
  }

  List<Widget> getContentsForWaitingForArchiveToComplete() {
    return [
      AHBodyText(
        "Copying all files into an archive...",
        textAlign: TextAlign.center,
      ),
      Container(
        height: 0.25 * AHStyle.lineHeight,
      ),
      Container(
        alignment: Alignment.center,
        height: 1.0 * AHStyle.lineHeight,
        width: 1.0 * AHStyle.lineHeight,
        child: CircularProgressIndicator(
          backgroundColor: AHStyle.COLOR_ERROR,
        ),
      ),
    ];
  }
}
