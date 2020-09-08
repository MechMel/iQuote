import 'dart:developer';

import 'package:axiom_hoist_quote_calculator/M2/M2AutoSerializingObjects.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableDate.dart';
import 'package:axiom_hoist_quote_calculator/M2/M2SerializableQuantityAtRate.dart';
import 'package:axiom_hoist_quote_calculator/models/AHTask.dart';
import 'package:flutter/cupertino.dart';

enum InspectionFrequency { PERIODIC, FREQUENT }

class AQI_Quote {
  // Constant values
  static const String PERIODIC_QUOTE_NUMBER_JSON_KEY = "periodicQuoteNumber";
  static const String FREQUENT_QUOTE_NUMBER_JSON_KEY = "frequentQuoteNumber";

  // Properties
  List<M2IAutoSerializing> propertiesToSave;
  M2AutoSerializingObject<int> periodicQuoteNumber;
  M2AutoSerializingObject<int> frequentQuoteNumber;
  M2AutoSerializingDate creationDate;
  M2AutoSerializingEnum<InspectionFrequency> frequency;
  M2AutoSerializingObject<String> companyName;
  M2AutoSerializingObject<String> contactName;
  M2AutoSerializingObject<String> contactEmailAddress;
  M2AutoSerializingObject<String> companyAddressLine1;
  M2AutoSerializingObject<String> companyAddressLine2;
  M2AutoSerializingObject<double> hourlyRate;
  M2AutoSerializingQuantityAtRate<int, double> periodicManLifts;
  M2AutoSerializingQuantityAtRate<int, double> frequentManLifts;
  M2AutoSerializingQuantityAtRate<double, double> transportation;
  M2AutoSerializingObject<double> fees;
  M2AutoSerializingObject<double> discounts;
  M2AutoSerializingObject<bool> shouldShowTaskBreakDownInExport;
  Map<int, AHTask> tasksByID;

  void _initializeProperties({@required int givenPeriodicQuoteNumber, @required int givenFrequentQuoteNumber}) {
    propertiesToSave = List();
    periodicQuoteNumber = M2AutoSerializingObject.uniqueInitialValues(
      value: givenPeriodicQuoteNumber,
      defaultValue: -1,
      jsonKey: PERIODIC_QUOTE_NUMBER_JSON_KEY,
      listToAddTo: propertiesToSave,
    );
    frequentQuoteNumber = M2AutoSerializingObject.uniqueInitialValues(
      value: givenFrequentQuoteNumber,
      defaultValue: -1,
      jsonKey: FREQUENT_QUOTE_NUMBER_JSON_KEY,
      listToAddTo: propertiesToSave,
    );
    creationDate = M2AutoSerializingDate(
      defaultValue: M2SerializableDate.fromDateTime(DateTime.now()),
      jsonKey: "creationDate",
      listToAddTo: propertiesToSave,
    );
    frequency = M2AutoSerializingEnum(
      defaultValue: InspectionFrequency.PERIODIC,
      enumValues: InspectionFrequency.values,
      jsonKey: "frequency",
      listToAddTo: propertiesToSave,
    );
    companyName = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "companyName",
      listToAddTo: propertiesToSave,
    );
    contactName = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "contactName",
      listToAddTo: propertiesToSave,
    );
    contactEmailAddress = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "contactEmailAddress",
      listToAddTo: propertiesToSave,
    );
    companyAddressLine1 = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "companyAddressLine1",
      listToAddTo: propertiesToSave,
    );
    companyAddressLine2 = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "companyAddressLine2",
      listToAddTo: propertiesToSave,
    );
    hourlyRate = M2AutoSerializingObject(
      defaultValue: 100.00,
      jsonKey: "hourlyRate",
      listToAddTo: propertiesToSave,
    );
    periodicManLifts = M2AutoSerializingQuantityAtRate(
      defaultValue: M2SerializableQuantityAtRate<int, double>(
        defaultQuantity: 0,
        defaultRate: 150.00,
      ),
      jsonKey: "periodicManLifts",
      listToAddTo: propertiesToSave,
    );
    frequentManLifts = M2AutoSerializingQuantityAtRate(
      defaultValue: M2SerializableQuantityAtRate<int, double>(
        defaultQuantity: 0,
        defaultRate: 150.00,
      ),
      jsonKey: "frequentManLifts",
      listToAddTo: propertiesToSave,
    );
    transportation = M2AutoSerializingQuantityAtRate(
      defaultValue: M2SerializableQuantityAtRate<double, double>(
        defaultQuantity: 0.0,
        defaultRate: 1.50,
      ),
      jsonKey: "transportation",
      listToAddTo: propertiesToSave,
    );
    fees = M2AutoSerializingObject(
      defaultValue: 0.00,
      jsonKey: "fees",
      listToAddTo: propertiesToSave,
    );
    discounts = M2AutoSerializingObject(
      defaultValue: 0.00,
      jsonKey: "discounts",
      listToAddTo: propertiesToSave,
    );
    shouldShowTaskBreakDownInExport = M2AutoSerializingObject(
      defaultValue: false,
      jsonKey: "shouldShowTaskBreakDownInExport",
      listToAddTo: propertiesToSave,
    );
    tasksByID = Map();
  }

  AQI_Quote(int givenPeriodicQuoteNumber, int givenFrequentQuoteNumber) {
    _initializeProperties(
      givenPeriodicQuoteNumber: givenPeriodicQuoteNumber,
      givenFrequentQuoteNumber: givenFrequentQuoteNumber,
    );
  }

  AQI_Quote.fromDecodedJson(Map<String, dynamic> decodedJson) {
    _initializeProperties(
      givenPeriodicQuoteNumber: decodedJson[PERIODIC_QUOTE_NUMBER_JSON_KEY],
      givenFrequentQuoteNumber: decodedJson[FREQUENT_QUOTE_NUMBER_JSON_KEY],
    );

    // Roll any legacy values forward
    updateLegacyQuantityAtRateInDecodedJson(
      decodedJson: decodedJson,
      legacyQuantityJsonKey: "scissorLiftQuanity",
      legacyRateJsonKey: "perScissorLiftCost",
      defaultQuantityAtRate: periodicManLifts,
    );
    updateLegacyQuantityAtRateInDecodedJson(
      decodedJson: decodedJson,
      legacyQuantityJsonKey: "roundTripDistance",
      legacyRateJsonKey: "perMileCost",
      defaultQuantityAtRate: transportation,
    );

    log(decodedJson.toString());

    // Load quote data from the json
    for (M2IAutoSerializing property in propertiesToSave) {
      property.retrieveValueFromDecodedJson(decodedJson);
    }

    tasksByID = _getTasksByIDFromDecodedJson(decodedJson["tasksByID"]);
  }

  static void updateLegacyQuantityAtRateInDecodedJson<QuantityType extends num, RateType extends num>({
      @required Map<String, dynamic> decodedJson,
      @required String legacyQuantityJsonKey,
      @required String legacyRateJsonKey,
      @required M2AutoSerializingQuantityAtRate<QuantityType, RateType> defaultQuantityAtRate,
    }) {
    if (decodedJson.containsKey(legacyQuantityJsonKey) || decodedJson.containsKey(legacyRateJsonKey)) {
      // If there are legacy values, then update them.
      QuantityType legacyQuantity = M2FlutterUtilities.tryReadJson(decodedJson, legacyQuantityJsonKey, defaultQuantityAtRate.value.defaultQuantity);
      RateType legacyRate = M2FlutterUtilities.tryReadJson(decodedJson, legacyRateJsonKey, defaultQuantityAtRate.value.defaultRate);

      // Remove the legacy entries from the decoded json
      if (decodedJson.containsKey(legacyQuantityJsonKey)) {
        decodedJson.remove(legacyQuantityJsonKey);
      }
      if (decodedJson.containsKey(legacyRateJsonKey)) {
        decodedJson.remove(legacyRateJsonKey);
      }

      // We need to create a temporary quantityAtRate so we can re-insert an updated version of this quantityAtRate.
      M2AutoSerializingQuantityAtRate tempQuantityAtRate = M2AutoSerializingQuantityAtRate(
        defaultValue: M2SerializableQuantityAtRate<QuantityType, RateType>.uniqueInitialValues(
          quantity: legacyQuantity,
          defaultQuantity: defaultQuantityAtRate.value.defaultQuantity,
          rate: legacyRate,
          defaultRate: defaultQuantityAtRate.value.defaultRate,
        ),
        jsonKey: defaultQuantityAtRate.jsonKey,
      );

      // Re-insert an updated version of this quantityAtRate.
      tempQuantityAtRate.insertValueIntoDecodedJson(decodedJson);
    }
  }

  static Map<int, AHTask> _getTasksByIDFromDecodedJson(Map<String, dynamic> tasksByTextID) {
    Map<int, AHTask> tasksByID = Map();

    for(String idAsText in tasksByTextID.keys) {
      int id = int.parse(idAsText);
      AHTask task = AHTask.fromDecodedJson(tasksByTextID[idAsText]);
      tasksByID[id] = task;
    }
    
    return tasksByID;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> decodedJson = Map();
    
    for (M2IAutoSerializing property in propertiesToSave) {
      property.insertValueIntoDecodedJson(decodedJson);
    }

    decodedJson["tasksByID"] = _getEncodableTasksByID();
    return decodedJson;
  }
  
  Map<String, AHTask> _getEncodableTasksByID() {
    Map<String, AHTask> tasksByTextID = Map();

    for(int id in tasksByID.keys) {
      AHTask task = tasksByID[id];
      if (task.doesTaskActuallyHaveReleventChanges()) {
        String idAsText = id.toString();
        tasksByTextID[idAsText] = tasksByID[id];
      }
    }

    return tasksByTextID;
  }

  // Calculators
  double get totalCost {
    double totalCost = 0;
    
    totalCost += totalLaborCost;
    totalCost += totalTransportationCost;
    totalCost += totalManLiftCost;
    totalCost += fees.value;
    totalCost -= discounts.value;

    return totalCost;
  }

  double get totalLaborCost {
    return hourlyRate.value * totalManHours;
  }

  double get totalManHours {
    double totalTasksTime = 0;
    
    for (int taskID in tasksByID.keys) {
      totalTasksTime += tasksByID[taskID].getTotalManHours(frequency.value);
    }

    return totalTasksTime;
  }

  double get totalManLiftCost {
    double manliftsTotal;

    if (frequency.value == InspectionFrequency.PERIODIC) {
      manliftsTotal = periodicManLifts.value.total;
    } else if (frequency.value == InspectionFrequency.FREQUENT) {
      manliftsTotal = frequentManLifts.value.total;
    } else {
      throw("AQI_Quote.totalManLiftCost does not handle ${frequency.value.toString()}!");
    }
    return manliftsTotal;
  }

  double get totalTransportationCost {
    return transportation.value.total;
  }
}