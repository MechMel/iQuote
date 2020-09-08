import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:flutter/foundation.dart';

class M2SerializableQuantityAtRate<QuantityType extends num, RateType extends num> {
  // Constants
  static const String QUANTITY_JSON_KEY = "quantity";
  static const String RATE_JSON_KEY = "rate";

  // Properties
  final QuantityType defaultQuantity;
  final RateType defaultRate;
  QuantityType quantity;
  RateType rate;

  // Getters
  double get total {
    return quantity * rate; 
  }

  // Constructors
  M2SerializableQuantityAtRate({@required this.defaultQuantity, @required this.defaultRate}) {
    quantity = defaultQuantity;
    rate = defaultRate;
  }

  M2SerializableQuantityAtRate.uniqueInitialValues({@required this.quantity, @required this.defaultQuantity, @required this.rate, @required this.defaultRate});

  M2SerializableQuantityAtRate.fromDecodedJson(Map<String, dynamic> decodedJson, this.defaultQuantity, this.defaultRate) {
    quantity = M2FlutterUtilities.tryReadJson(decodedJson, QUANTITY_JSON_KEY, defaultQuantity);
    rate = M2FlutterUtilities.tryReadJson(decodedJson, RATE_JSON_KEY, defaultRate);
  }
        
  Map<String, dynamic> toJson()  => {
    QUANTITY_JSON_KEY: quantity,
    RATE_JSON_KEY: rate,
  };
}