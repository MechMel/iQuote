import 'dart:developer';

import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2ObjectWrapperForControllers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';

// TODO: Make email and physical address input fields have input validation
// TODO: Turn the TextField red if the input is not formatted properly.
// TODO: In large numeric input fields, insert a comman(10,000)

class AHNumericField extends StatelessWidget {
  final Type _specficNumType;
  final num Function() getValue;
  final void Function(num) setValue;
  final num defaultValue;
  final Color nonDefaultValueColor;
  final Color defaultValueColor;
  final bool shouldChangeColorIfNotEqualToDefaultValue;
  final void Function() onSubmitted;
  //final FocusNode focusNode;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextEditingController controller = TextEditingController();
  final int maxLength;
  final int decimalCount;

  AHNumericField({
    Key key,
    @required this.getValue,
    @required this.setValue,
    @required this.defaultValue,
    this.defaultValueColor = AHStyle.COLOR_HINT,
    this.nonDefaultValueColor = AHStyle.COLOR_BLACK,
    this.shouldChangeColorIfNotEqualToDefaultValue = true,
    //this.focusNode,
    this.onSubmitted,
    this.textAlign = TextAlign.center,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.maxLength = 10,
    this.decimalCount = 0,
  })  : _specficNumType = null,
        this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  AHNumericField.fromDoubleWrapper({
    Key key,
    @required M2ObjectWrapperForControllers<double> source,
    this.defaultValueColor = AHStyle.COLOR_HINT,
    this.nonDefaultValueColor = AHStyle.COLOR_BLACK,
    this.shouldChangeColorIfNotEqualToDefaultValue = true,
    //this.focusNode,
    this.onSubmitted,
    this.textAlign = TextAlign.center,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.maxLength = 10,
    this.decimalCount = 2,
  })  : _specficNumType = double,
        getValue = source.getValue,
        setValue = source.setValue,
        defaultValue = source.defaultValue,
        this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  AHNumericField.fromIntWrapper({
    Key key,
    @required M2ObjectWrapperForControllers<int> source,
    this.defaultValueColor = AHStyle.COLOR_HINT,
    this.nonDefaultValueColor = AHStyle.COLOR_BLACK,
    this.shouldChangeColorIfNotEqualToDefaultValue = true,
    //this.focusNode,
    this.onSubmitted,
    this.textAlign = TextAlign.center,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.maxLength = 10,
  })  : _specficNumType = int,
        getValue = source.getValue,
        setValue = source.setValue,
        defaultValue = source.defaultValue,
        decimalCount = 0,
        this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AHInputField(
      key: key,
      getValue: getValueAsString,
      setValue: setValueFromString,
      defaultValue: defaultValue.toStringAsFixed(decimalCount),
      onSubmitted: onSubmitted,
      hintText: defaultValue.toStringAsFixed(decimalCount),
      textColor: nonDefaultValueColor,
      hintColor: defaultValueColor,
      //getInputBorder: _getInputBorder,
      inputBorder: _getInputBorder(),
      //focusNode: focusNode,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      textAlign: textAlign,
      keyboardType: TextInputType.numberWithOptions(
          signed: false, decimal: decimalCount != 0),
      textInputAction: textInputAction,
      textStyle: style,
      maxLength: maxLength,
    );
  }

  String getValueAsString() {
    return getValue().toStringAsFixed(decimalCount);
  }

  void setValueFromString(String newValueAsString) {
    newValueAsString = newValueAsString.replaceAll(RegExp(r"[^0-9.]"), "");
    num newValueAsNum = num.tryParse(newValueAsString);
    if (newValueAsString != "" && newValueAsNum != null) {
      if (_specficNumType != null) {
        if (_specficNumType == double) {
          setValue(newValueAsNum.toDouble());
        } else if (_specficNumType == int) {
          setValue(newValueAsNum.toInt());
        } else {
          throw ("AHNumericField._specficNumType = ${_specficNumType.toString()}, but AHNumericField.setValueFromString() does not handle this type.");
        }
      } else {
        setValue(newValueAsNum);
      }
    } else {
      setValue(defaultValue);
    }
  }

  InputBorder _getInputBorder() {
    if (shouldChangeColorIfNotEqualToDefaultValue &&
        getValue() == defaultValue) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: defaultValueColor, width: 1.0),
      );
    } else {
      return OutlineInputBorder(
        borderSide: BorderSide(color: nonDefaultValueColor, width: 1.0),
      );
    }
  }
}

class AHTextField extends StatelessWidget {
  final String Function() getValue;
  final void Function(String) setValue;
  final void Function() onSubmitted;
  //final FocusNode focusNode;
  final Icon icon;
  final String hintText;
  final Color nonDefaultValueColor;
  final Color defaultValueColor;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextStyle style;
  final String labelText;
  final String helperText;
  final int maxLength;
  final int maxLines;
  final TextEditingController controller = TextEditingController();

  AHTextField({
    Key key,
    @required this.getValue,
    @required this.setValue,
    //this.focusNode,
    this.onSubmitted,
    this.icon,
    this.hintText,
    this.nonDefaultValueColor = AHStyle.COLOR_BLACK,
    this.defaultValueColor = AHStyle.COLOR_HINT,
    this.autocorrect = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.labelText,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
  })  : this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  AHTextField.fromTextWrapper({
    Key key,
    @required M2ObjectWrapperForControllers<String> source,
    //@required
    //this.focusNode,
    this.onSubmitted,
    this.icon,
    this.hintText,
    this.nonDefaultValueColor = AHStyle.COLOR_BLACK,
    this.defaultValueColor = AHStyle.COLOR_HINT,
    this.autocorrect = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.labelText,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
  })  : getValue = source.getValue,
        setValue = source.setValue,
        this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder;
    if (getValue() == "") {
      inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: defaultValueColor),
      );
    } else {
      inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: nonDefaultValueColor),
      );
    }

    return AHInputField(
      key: key,
      getValue: getValue,
      setValue: setValue,
      onSubmitted: onSubmitted,
      icon: icon,
      hintText: hintText,
      textColor: nonDefaultValueColor,
      hintColor: defaultValueColor,
      inputBorder: inputBorder,
      //focusNode: focusNode,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textStyle: style,
      labelText: labelText,
      helperText: helperText,
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}

class AHInputField extends StatefulWidget {
  final String Function() getValue;
  final void Function(String) setValue;
  final String defaultValue;
  final void Function() onSubmitted;
  final Icon icon;
  final String hintText;
  final Color textColor;
  final Color hintColor;
  @required
  final InputBorder inputBorder;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextStyle style;
  final String labelText;
  final String helperText;
  final int maxLength;
  final int maxLines;

  AHInputField({
    Key key,
    @required this.getValue,
    @required this.setValue,
    this.defaultValue,
    //this.focusNode,
    this.onSubmitted,
    this.icon,
    this.hintText,
    this.textColor = AHStyle.COLOR_BLACK,
    this.hintColor = AHStyle.COLOR_HINT,
    this.inputBorder,
    this.autocorrect = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.left,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    TextStyle textStyle,
    this.labelText,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
  })  : this.style = (textStyle == null) ? AHStyle.textStyleBody : textStyle,
        super(key: key);

  @override
  _AHInputFieldState createState() => _AHInputFieldState();
}

class _AHInputFieldState extends State<AHInputField> {
  bool _buildIsInProgress = false;
  final TextEditingController _controller;
  final FocusNode _focusNode;

  _AHInputFieldState()
      : _focusNode = FocusNode(),
        _controller = TextEditingController() {
    _controller.addListener(applyTextChangesToValue);
    _focusNode.addListener(focusChanged);
  }

  void updateState() async {
    await M2FlutterUtilities.when(() {
      return _buildIsInProgress == false;
    });
    setState(() {});
  }

  void focusChanged() {
    if (_focusNode.hasFocus) {
      log("Yes Focus.");
    } else {
      updateState();

      log("No Focus.");

      if (widget.onSubmitted != null) {
        widget.onSubmitted();
      }
    }
  }

  void applyTextChangesToValue() {
    widget.setValue(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    _buildIsInProgress = true;
    // Apply any external changes to the value
    if (widget.defaultValue != null &&
        widget.getValue() == widget.defaultValue) {
      _controller.text = "";
    } else {
      _controller.text = widget.getValue();
    }

    Widget inputField = TextField(
      //onFieldSubmitted: (submittedText) { onSubmitted(context); },
      //onSubmitted: (submittedText) { onSubmitted(context); },
      focusNode: _focusNode,
      autocorrect: widget.autocorrect,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      controller: _controller,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      keyboardAppearance: Brightness.light,
      style: widget.style.apply(color: widget.textColor),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        icon: widget.icon,
        contentPadding: EdgeInsets.all(0.0),
        hintText: widget.hintText,
        hintStyle: widget.style.apply(color: widget.hintColor),
        labelText: widget.labelText,
        labelStyle: widget.style.apply(color: widget.hintColor),
        helperText: widget.helperText,
        border: widget.inputBorder,
        enabledBorder: widget.inputBorder,
        counterText: "",
      ),
    );

    _buildIsInProgress = false;

    return inputField;
  }
}
