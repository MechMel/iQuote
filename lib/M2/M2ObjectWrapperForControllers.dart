import 'package:axiom_hoist_quote_calculator/M2/M2AutoSerializingObjects.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_AutoSavingProperty.dart';
import 'package:flutter/material.dart';

class M2ObjectWrapperForControllers<ObjectType> {
  //final M2AutoSerializing<ObjectType> _source;
  final ObjectType Function() _getSourceValue;
  final void Function(ObjectType) _setSourceValue;
  final ObjectType Function() _getSourceDefaultValue;
  final void Function() _onBeforeGet;
  final void Function(ObjectType) _onBeforeSet;
  final void Function() _onAfterSet;

  // Wrappers
  ObjectType get value {
    _tryCallOnBeforeGet();
    return _getSourceValue();
  }
  set value(ObjectType newValue) {
    _tryCallOnBeforeSet(newValue);
    _setSourceValue(newValue);
    _tryCallOnAfterSet();
  }
  ObjectType get defaultValue {
    return _getSourceDefaultValue();
  }

  M2ObjectWrapperForControllers({
    @required ObjectType Function() getSourceValue,
    @required Function(ObjectType) setSourceValue,
    @required ObjectType Function() getSourceDefaultValue,
    void Function() onBeforeGet,
    void Function(ObjectType) onBeforeSet,
    void Function() onAfterSet,})
   : _getSourceValue = getSourceValue,
   _setSourceValue = setSourceValue,
   _getSourceDefaultValue = getSourceDefaultValue,
   _onBeforeGet = onBeforeGet,
   _onBeforeSet = onBeforeSet,
   _onAfterSet = onAfterSet;

  M2ObjectWrapperForControllers.fromAutoSerializing({
    @required M2AutoSerializing<ObjectType> source,
    void Function() onBeforeGet,
    void Function(ObjectType) onBeforeSet,
    void Function() onAfterSet,})
   : _getSourceValue = source.getValue,
   _setSourceValue = source.setValue,
   _getSourceDefaultValue = source.getDefaultValue,
   _onBeforeGet = onBeforeGet,
   _onBeforeSet = onBeforeSet,
   _onAfterSet = onAfterSet;

  ObjectType getValue() {
    return value;
  }

  void setValue(ObjectType newValue) {
    value = newValue;
  }

  ObjectType getDefaultValue() {
    return defaultValue;
  }

  void _tryCallOnBeforeGet() {
    if (_onBeforeGet != null) {
      _onBeforeGet();
    }
  }

  void _tryCallOnBeforeSet(ObjectType newValue) {
    if (_onBeforeSet != null) {
      _onBeforeSet(newValue);
    }
  }

  void _tryCallOnAfterSet() {
    if (_onAfterSet != null) {
      _onAfterSet();
    }
  }
}