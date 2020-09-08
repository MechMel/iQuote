import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/TinyButtonWidget.dart';

class M2UIBuilders {
  static Column buildDisplayArea({String title, List<Widget> children}) {
    Column displayArea = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List(),
    );

    displayArea.children.add(AHHeader(title));
    displayArea.children.addAll(children);

    return displayArea;
  }

  static Widget buildIncDecButtons2(
      {@required BuildContext context,
      @required void Function() incrementValue,
      @required void Function() decrementValue}) {
    return Container(
        // TODO: Clean up the button stack, and make the bottom button animate, not the top one.
        width: 0.1 * 0.925 * MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 0.7 * AHStyle.lineHeight,
                  width: 0.85 * 0.1 * 0.925 * MediaQuery.of(context).size.width,
                  child: TinyButtonWidget(
                    icon: Icon(
                      Icons.add,
                      size: 15,
                      color: AHStyle.COLOR_BACKGROUND,
                    ),
                    function: () => {},
                  ),
                ),
                Container(height: 0.14 * AHStyle.lineHeight),
                Container(
                  height: 0.7 * AHStyle.lineHeight,
                  width: 0.85 * 0.1 * 0.925 * MediaQuery.of(context).size.width,
                  child: TinyButtonWidget(
                    icon: Icon(
                      Icons.remove,
                      size: 15,
                      color: AHStyle.COLOR_BACKGROUND,
                    ),
                    function: () => {},
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: AHStyle.lineHeight,
                  child: TinyButtonWidget(
                    color: Colors.transparent,
                    function: incrementValue,
                  ),
                ),
                Container(
                  height: AHStyle.lineHeight,
                  child: TinyButtonWidget(
                    color: Colors.transparent,
                    function: decrementValue,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
