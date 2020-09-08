import 'M2Events.dart';

class M2ISetting {
  M2Event onValueChanged;
  void resetToDefaultValue() {}
  String toString() { return null; }
  void parse(String textValue) {}
}

class M2Setting<ValueType> implements M2ISetting{
  // Fields
  ValueType _defaultValue;
  ValueType _value;
  M2Event onValueChanged;

  // Properties
  ValueType get value {
    return _value;
  }
  set value(ValueType newValue) {
    _value = newValue;
    onValueChanged.trigger();
  }
  ValueType get defaultValue {
    return _defaultValue;
  }

  // Constructor
  M2Setting({ValueType defaultValue}) {
    _defaultValue = defaultValue;
    _value = _defaultValue;
    onValueChanged = M2Event();
  }

  // Functions
  void resetToDefaultValue() {
    value = _defaultValue;
  }

  String toString() {
    return value.toString();
  }

  void parse(String textValue) {
    if (textValue != null) {
      switch (ValueType) {
        case bool:
          value = (textValue == true.toString()) as ValueType;
          break;
        case int:
          value = int.parse(textValue) as ValueType;
          break;
        case double:
          value = double.parse(textValue) as ValueType;
          break;
        case String:
          value = textValue as ValueType;
          break;
        default:
          value = _defaultValue;
      }
    } else {
      value = _defaultValue;
    }
  }
}