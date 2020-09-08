import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';

// Tab Widget
class AHTab extends Tab {
  AHTab({Key key, String text, Icon icon, Color textColor})
      : super(
          key: key,
          child: Text(
            text,
            style: AHStyle.textStyleBody.apply(color: textColor),
          ),
          icon: icon,
        );
}

// Headline Text Widget
class AHHeadlineText extends Text {
  AHHeadlineText(
    String text, {
    Key key,
    TextAlign textAlign = TextAlign.left,
    Color color = AHStyle.COLOR_BLACK,
  }) : super(text,
            key: key,
            textAlign: textAlign,
            style: AHStyle.textStyleHeadline.apply(
              color: color,
            ));
}

// Body Text Widget
class AHBodyText extends Text {
  AHBodyText(
    String text, {
    Key key,
    TextAlign textAlign = TextAlign.left,
    Color color = AHStyle.COLOR_BLACK,
  }) : super(text,
            key: key,
            textAlign: textAlign,
            style: AHStyle.textStyleBody.apply(
              color: color,
            ));
}

// Header Widget
class AHHeader extends Container {
  AHHeader(String headerText, {Key key})
      : super(
            key: key,
            height: AHStyle.lineHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AHHeadlineText(headerText),
            ));
}

// Progress Indicator Widget
class AHProgressIndicator extends CircularProgressIndicator {
  AHProgressIndicator({Key key, Color color = AHStyle.COLOR_PRIMARY})
      : super(
          key: key,
          backgroundColor: color,
        );
}

// Outlined Button Widget
class AHOutlinedButton extends OutlineButton {
  AHOutlinedButton({
    Key key,
    Function onPressed,
    Widget child,
  }) : super(
          key: key,
          color: AHStyle.COLOR_PRIMARY,
          onPressed: onPressed,
          child: child,
        );
}
