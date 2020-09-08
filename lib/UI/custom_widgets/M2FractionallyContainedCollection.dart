import 'dart:developer';
import 'package:flutter/material.dart';

class M2FractonalContainer {
  final double heightFactor;
  final double widthFactor;
  final Alignment alignment;
  final Widget widget;

  M2FractonalContainer({this.heightFactor = 1, this.widthFactor = 1, this.alignment = Alignment.center, this.widget});
  
  double getSizeFactorOnAxis(Axis axis) {
    if (axis == Axis.vertical) {
      return heightFactor;
    } else {
      return widthFactor;
    }
  }
}

class M2FractionallyContainedCollection extends StatelessWidget{
  final Axis axis;
  // TODO: At some point, maybe make these width & height factor of AHStyle.LINE_HEIGHT.
  final double height;
  final double width;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<M2FractonalContainer> elements;

  M2FractionallyContainedCollection({
    Key key,
    // TODO: Add a flag to enable and disable red outline boxes to show how much space each fractonal element takes up.
    this.axis = Axis.horizontal,
    this.height,
    this.width,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.elements,
  }) : super(key: key) {
    if (calculateTotalSizeFactorOnAxis(axis, elements) > 1.0) {
      log("WARNNING! The total ${axis.toString()} size factor is to big: ${getPrintableSizeFactorSumOnAxis(axis, elements)}");
    }
  }

  @override Widget build(BuildContext context) {
    Widget childrenCollection;
    double tempHeight = height;
    double tempWidth = width;

    if (tempHeight == null) {
      tempHeight = MediaQuery.of(context).size.height;
    }
    if (tempWidth == null) {
      tempWidth = MediaQuery.of(context).size.width;
    }
    if (axis == Axis.vertical) {
      childrenCollection = Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _buildChildrenFromElements(tempHeight, tempWidth, elements),
      );
    }
    else {
      childrenCollection = Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _buildChildrenFromElements(tempHeight, tempWidth, elements),
      );
    }

    return Container(
      height: tempHeight,
      width: tempWidth,
      child: childrenCollection,
    );
  }

  static getPrintableSizeFactorSumOnAxis(Axis axis, List<M2FractonalContainer> elements) {
    double totalSizeFactor = calculateTotalSizeFactorOnAxis(axis, elements);
    String sumText = "";

    for (M2FractonalContainer element in elements) {
      sumText += "${element.getSizeFactorOnAxis(axis)} + ";
    }
    sumText = sumText.substring(0, sumText.length - 1 - 3);
    sumText += " = $totalSizeFactor";
    
    return sumText;
  }

  static double calculateTotalSizeFactorOnAxis(Axis axis, List<M2FractonalContainer> elements) {
    double totalSizeFactor = 0;

    for (M2FractonalContainer element in elements) {
      totalSizeFactor += element.getSizeFactorOnAxis(axis);
    }

    return totalSizeFactor;
  }

  static List<Widget> _buildChildrenFromElements(double height, double width, List<M2FractonalContainer> elements) {
    List<Widget> children = List();

    for (M2FractonalContainer element in elements) {
      children.add(
        Container(
          // TODO: At some point make sure this is actually what we want to do.
          alignment: element.alignment,
          height: element.heightFactor * height,
          width: element.widthFactor * width,
          child: element.widget,
        )
      );
    }

    return children;
  }
}