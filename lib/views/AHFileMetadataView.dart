import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';

class AHFileMetadataView extends StatefulWidget {
  //final AHFileMetadata fileMetadata;
  final String fileName;
  final Function onSetState;

  AHFileMetadataView(this.fileName, {Key key, this.onSetState})
      : super(key: key);

  @override
  _AHFileMetadataViewState createState() => _AHFileMetadataViewState();
}

class _AHFileMetadataViewState extends State<AHFileMetadataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.75 * AHStyle.lineHeight,
      width: 3.75 * AHStyle.lineHeight,
      child: AHOutlinedButton(
        onPressed: () => null,
        child: AHBodyText(widget.fileName),
      ),
    );
  }
}
