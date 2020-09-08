import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:flutter/material.dart';

class TinyButtonWidget extends StatelessWidget {
  final Function function;
  final Icon icon;
  final Color color;

  TinyButtonWidget({Key key, this.icon, this.function, this.color = AHStyle.COLOR_PRIMARY}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlatButton(
          onPressed: () => null,
          color: color,
          child: Container(),
        ),
        Center(
          child: icon,
        ),
        FlatButton(
          onPressed: function,
          color: Colors.transparent,
          child: Container(),
        ),
      ],
    );
  }
}