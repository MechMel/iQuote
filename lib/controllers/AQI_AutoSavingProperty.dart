import 'dart:convert';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';

class AQI_AutoSavingProperty<PropertyType> {
  final String _saveFileName;
  PropertyType _value;
  PropertyType get value {
    return _value;
  }
  set value(PropertyType newValue) {
    _value = newValue;
    _saveValue();
  }


  AQI_AutoSavingProperty(PropertyType defaultValue, this._saveFileName) {
    _attemptLoadValue(defaultValue);
  }

  void _saveValue() {
    String encodedJson = jsonEncode(_value);
    AHDiskController.saveFileAsString(_saveFileName, encodedJson);
  }

  void _attemptLoadValue(PropertyType defaultValue) {
    String encodedJson = AHDiskController.loadFileAsString(_saveFileName);

    if (encodedJson != null) {
      _value = json.decode(encodedJson);
    } else {
      _value = defaultValue;
    }
  }
}