import 'package:axiom_hoist_quote_calculator/M2/M2AutoSerializingObjects.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2ObjectWrapperForControllers.dart';
import 'package:flutter/material.dart';

class M2QuantityAtRateWrapperForControllers<QuantityType extends num, RateType extends num> {
  M2ObjectWrapperForControllers<QuantityType> _quantity;
  M2ObjectWrapperForControllers<QuantityType> get quantityWrapper {
    return _quantity;
  }
  QuantityType get quantity {
    return _quantity.value;
  }
  set quantity(QuantityType newValue) {
    _quantity.value = newValue;
  }
  QuantityType get defaultQuantity {
    return _quantity.defaultValue;
  }
  M2ObjectWrapperForControllers<RateType> _rate;
  M2ObjectWrapperForControllers<RateType> get rateWrapper {
    return _rate;
  }
  RateType get rate {
    return _rate.value;
  }
  set rate(RateType newValue) {
    _rate.value = newValue;
  }
  RateType get defaultRate {
    return _rate.defaultValue;
  }

  M2QuantityAtRateWrapperForControllers({
    @required QuantityType Function() getSourceQuantity,
    @required void Function(QuantityType) setSourceQuantity,
    @required QuantityType Function() getSourceDefaultQuantity,
    @required RateType Function() getSourceRate,
    @required void Function(RateType) setSourceRate,
    @required RateType Function() getSourceDefaultRate,
    // On get/set functions
    void Function() onBeforeGetQuantity,
    void Function(QuantityType) onBeforeSetQuantity,
    void Function() onAfterSetQuantity,
    void Function() onBeforeGetRate,
    void Function(RateType) onBeforeSeRate,
    void Function() onAfterSetRate,
  }) {
    _quantity = M2ObjectWrapperForControllers(
      getSourceValue: getSourceQuantity,
      setSourceValue: setSourceQuantity,
      getSourceDefaultValue: getSourceDefaultQuantity,
      onBeforeGet: onBeforeGetQuantity,
      onBeforeSet: onBeforeSetQuantity,
      onAfterSet: onAfterSetQuantity,
    );
    _rate = M2ObjectWrapperForControllers(
      getSourceValue: getSourceRate,
      setSourceValue: setSourceRate,
      getSourceDefaultValue: getSourceDefaultRate,
      onBeforeGet: onBeforeGetRate,
      onBeforeSet: onBeforeSeRate,
      onAfterSet: onAfterSetRate,
    );
  }

  M2QuantityAtRateWrapperForControllers.fromQuantityAtRate({
    @required M2AutoSerializingQuantityAtRate<QuantityType, RateType> source,
    // On get/set functions
    void Function() onBeforeGetQuantity,
    void Function(QuantityType) onBeforeSetQuantity,
    void Function() onAfterSetQuantity,
    void Function() onBeforeGetRate,
    void Function(RateType) onBeforeSeRate,
    void Function() onAfterSetRate,
  }) {
    _quantity = M2ObjectWrapperForControllers(
      getSourceValue: () { return source.value.quantity; },
      setSourceValue: (QuantityType value) { source.value.quantity = value; },
      getSourceDefaultValue: () { return source.value.defaultQuantity; },
      onBeforeGet: onBeforeGetQuantity,
      onBeforeSet: onBeforeSetQuantity,
      onAfterSet: onAfterSetQuantity,
    );
    _rate = M2ObjectWrapperForControllers(
      getSourceValue: () { return source.value.rate; },
      setSourceValue: (RateType value) { source.value.rate = value; },
      getSourceDefaultValue: () { return source.value.defaultRate; },
      onBeforeGet: onBeforeGetRate,
      onBeforeSet: onBeforeSeRate,
      onAfterSet: onAfterSetRate,
    );
  }
}