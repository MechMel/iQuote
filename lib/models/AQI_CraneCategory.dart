import 'package:axiom_hoist_quote_calculator/M2/M2AutoSerializingObjects.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';

class AQI_CraneCategory {
  List<M2AutoSerializing> _autoSerializingProperties;
  M2AutoSerializingObject<bool> isActiveCraneCategory;
  M2AutoSerializingObject<String> name;
  M2AutoSerializingObject<double> defaultPeriodicPerUnitManHours;
  M2AutoSerializingObject<double> defaultFrequentPerUnitManHours;
  Map<InspectionFrequency, double> get  defaultPerUnitManHoursReadOnly {
    return {
      InspectionFrequency.PERIODIC: defaultPeriodicPerUnitManHours.value,
      InspectionFrequency.FREQUENT: defaultFrequentPerUnitManHours.value,
    };
  }

  void _initializeProperties() {
    _autoSerializingProperties = List();
    isActiveCraneCategory = M2AutoSerializingObject(
      defaultValue: true,
      jsonKey: "isActiveCraneCategory",
      listToAddTo: _autoSerializingProperties,
    );
    name = M2AutoSerializingObject(
      defaultValue: "",
      jsonKey: "name",
      listToAddTo: _autoSerializingProperties,
    );
    defaultPeriodicPerUnitManHours = M2AutoSerializingObject(
      defaultValue: 0.0,
      jsonKey: "defaultPeriodicPerUnitManHours",
      listToAddTo: _autoSerializingProperties,
    );
    defaultFrequentPerUnitManHours = M2AutoSerializingObject(
      defaultValue: 0.0,
      jsonKey: "defaultFrequentPerUnitManHours",
      listToAddTo: _autoSerializingProperties,
    );
  }

  AQI_CraneCategory(String givenName, double givenDefaultPeriodicPerUnitManHours, double givenDefaultFrequentPerUnitManHours) {
    _initializeProperties();
    name.value = givenName;
    defaultPeriodicPerUnitManHours.value = givenDefaultPeriodicPerUnitManHours;
    defaultFrequentPerUnitManHours.value = givenDefaultFrequentPerUnitManHours;
  }

  AQI_CraneCategory.fromDecodedJson(Map<String, dynamic> decodedJson){
    _initializeProperties();

    for (M2AutoSerializing autoSerializingProperty in _autoSerializingProperties) {
      autoSerializingProperty.retrieveValueFromDecodedJson(decodedJson);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> decodedJson = Map();

    for (M2AutoSerializing autoSerializingProperty in _autoSerializingProperties) {
      autoSerializingProperty.insertValueIntoDecodedJson(decodedJson);
    }

    return decodedJson;
  }
}