import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:flutter/material.dart';

class AQI_LoadingPage extends StatelessWidget {
  bool _isImagePage;
  IconData _iconData;
  String _imageLocation;
  String _loadingText;
  Color _color;

  AQI_LoadingPage.icon(this._iconData, this._loadingText, {Color color = AHStyle.COLOR_HINT}) : _isImagePage = false, _color = color;
  AQI_LoadingPage.image(this._imageLocation, this._loadingText, {Color color = AHStyle.COLOR_HINT}) : _isImagePage = true, _color = color;

  @override
  Widget build(BuildContext context) {
    double loadingAnimationWidth = AHStyle.internalPageWidth / 4.0;
    double loadingAnimationHeight = loadingAnimationWidth;

    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                getGraphics(),
                Container(
                  width: loadingAnimationWidth,
                  height: loadingAnimationHeight,
                  child: CircularProgressIndicator(
                    backgroundColor: _color,
                    strokeWidth: AHStyle.pageMargins / 3.5,
                  ),
                ),
              ],
            ),
            Container(
              height: AHStyle.pageMargins,
            ),
            Container(
              child: AHBodyText(
                _loadingText,
                color: _color,
              ),
            ),
          ],
        );
  }

  Widget getGraphics() {
    double size = AHStyle.internalPageWidth / 6.0;

    if (_isImagePage) {
      return Image.asset(
        _imageLocation,
        width: size,
        height: size,
      );
    } else  {
      return Icon(
        _iconData,
        size: size,
        color: _color,
      );
    }
  }
}