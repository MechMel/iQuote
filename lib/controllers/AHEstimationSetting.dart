import 'dart:convert';
import 'package:axiom_hoist_quote_calculator/M2/M2Setting.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';

class AHEstimationSetting extends M2Setting<AQI_Quote> {
  AHEstimationSetting({AQI_Quote defaultValue}) : super(defaultValue: defaultValue);

  @override
  String toString() {
    return jsonEncode(value);
  }

  @override
  void parse(String textValue) {
    if (textValue != null) {
      Map<String, dynamic> decodedJson = jsonDecode(textValue);
      value = AQI_Quote.fromDecodedJson(decodedJson);
    } else {
      value = defaultValue;
    }
  }
}