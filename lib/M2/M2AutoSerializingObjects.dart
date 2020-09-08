import 'dart:developer';

import 'package:axiom_hoist_quote_calculator/M2/M2SerializableDate.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableQuantityAtRate.dart';
import 'package:flutter/material.dart';
import 'M2FlutterUtilities.dart';

abstract class M2IAutoSerializing {
  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson);
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson);
}

abstract class M2AutoSerializing<ObjectType> implements M2IAutoSerializing {
  final String jsonKey;
  final ObjectType defaultValue;
  ObjectType value;

  M2AutoSerializing({@required this.defaultValue, @required this.jsonKey, @required List<M2IAutoSerializing> listToAddTo}) {
    value = defaultValue;
    if (listToAddTo != null) {
      listToAddTo.add(this);
    }
  }

  M2AutoSerializing.uniqueInitialValues({@required this.value, @required this.defaultValue, @required this.jsonKey, @required List<M2IAutoSerializing> listToAddTo}) {
    if (listToAddTo != null) {
      listToAddTo.add(this);
    }
  }

  // Getters and setters
  ObjectType getValue() {
    return value;
  }
  void setValue(ObjectType newValue) {
    value = newValue;
  }
  ObjectType getDefaultValue() {
    return defaultValue;
  }

  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson);
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson);
}

class M2AutoSerializingObject<ObjectType> extends M2AutoSerializing<ObjectType> {
  M2AutoSerializingObject({@required ObjectType defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super(defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  M2AutoSerializingObject.uniqueInitialValues({@required ObjectType value, @required ObjectType defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super.uniqueInitialValues(value: value, defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);
  
  @override
  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson) {
    value = M2FlutterUtilities.tryReadJson(decodedJson, jsonKey, defaultValue);
  }
  
  @override
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson) {
    decodedJson[jsonKey] = value;
  }
}

class M2AutoSerializingEnum<EnumType> extends M2AutoSerializingObject {
  final List<EnumType> enumValues;

  M2AutoSerializingEnum({@required EnumType defaultValue, @required this.enumValues, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super(defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  M2AutoSerializingEnum.uniqueInitialValues({@required EnumType value, @required EnumType defaultValue, @required this.enumValues, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super.uniqueInitialValues(value: value, defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  @override
  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson) {
    value = enumValues[M2FlutterUtilities.tryReadJson(decodedJson, jsonKey, defaultValue.index)];
  }

  @override
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson) {
    decodedJson[jsonKey] = value.index;
  }
}

class M2AutoSerializingDate extends M2AutoSerializingObject<M2SerializableDate> {
  M2AutoSerializingDate({@required M2SerializableDate defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super(defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  M2AutoSerializingDate.uniqueInitialValues({@required M2SerializableDate value, @required M2SerializableDate defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super.uniqueInitialValues(value: value, defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  @override
  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson) {
    value = M2SerializableDate.fromDecodedJson(decodedJson[jsonKey]);
  }

  @override
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson) {
    decodedJson[jsonKey] = value.toJson();
  }
}

class M2AutoSerializingQuantityAtRate<QuantityType extends num, RateType extends num> extends M2AutoSerializingObject<M2SerializableQuantityAtRate> {
  M2AutoSerializingQuantityAtRate({@required M2SerializableQuantityAtRate<QuantityType, RateType> defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super(defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);
   
  M2AutoSerializingQuantityAtRate.uniqueInitialValues({@required M2SerializableQuantityAtRate<QuantityType, RateType> value, @required M2SerializableQuantityAtRate<QuantityType, RateType> defaultValue, @required String jsonKey, List<M2IAutoSerializing> listToAddTo})
   : super.uniqueInitialValues(value: value, defaultValue: defaultValue, jsonKey: jsonKey, listToAddTo: listToAddTo);

  @override
  void retrieveValueFromDecodedJson(Map<String, dynamic> decodedJson) {
    QuantityType defaultQuantity;
    RateType defaultRate;

    log("Key: $jsonKey");

    if (value != null) {
      defaultQuantity = value.defaultQuantity;
      defaultRate = value.defaultRate;
    } else  {
      defaultQuantity = 0 as QuantityType;
      defaultRate = 0 as RateType;
    }

    value = M2SerializableQuantityAtRate.fromDecodedJson(decodedJson[jsonKey], defaultQuantity, defaultRate);
  }

  @override
  void insertValueIntoDecodedJson(Map<String, dynamic> decodedJson) {
    decodedJson[jsonKey] = value.toJson();
  }
}