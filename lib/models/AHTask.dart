import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_CraneCategoriesController.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';

class AHTask {
  // Fields
  final int craneCategoryID;
  int quantity;
  double _periodicPerUnitManHours;
  double _frequentPerUnitManHours;
  String get taskName {
    return AQI_CraneCategoriesController.getCraneCategoryNameWrapper(craneCategoryID).value;
  }

  // Constructors
  AHTask(this.craneCategoryID) {
    _periodicPerUnitManHours = getDefaultPerUnitManHours(InspectionFrequency.PERIODIC);
    _frequentPerUnitManHours = getDefaultPerUnitManHours(InspectionFrequency.FREQUENT);
    quantity = 0;
  }

  AHTask.fromDecodedJson(Map<String, dynamic> decodedJson)
    : this.craneCategoryID = M2FlutterUtilities.tryReadJson(decodedJson, "craneCategoryID", -1) {
    this.quantity = M2FlutterUtilities.tryReadJson(decodedJson, "quantity", 0);
    this._periodicPerUnitManHours = M2FlutterUtilities.tryReadJson(decodedJson, "periodicPerUnitManHours", getDefaultPerUnitManHours(InspectionFrequency.PERIODIC));
    this._frequentPerUnitManHours = M2FlutterUtilities.tryReadJson(decodedJson, "frequentPerUnitManHours", getDefaultPerUnitManHours(InspectionFrequency.FREQUENT));
  }

  Map<String, dynamic> toJson() => {
    "craneCategoryID": craneCategoryID,
    "periodicPerUnitManHours": _periodicPerUnitManHours,
    "frequentPerUnitManHours": _frequentPerUnitManHours,
    "quantity": quantity,
  };

  // Functions
  double getPerUnitManHours(InspectionFrequency frequency) {
    if (frequency == InspectionFrequency.PERIODIC) {
      return _periodicPerUnitManHours;
    } else if (frequency == InspectionFrequency.FREQUENT) {
      return _frequentPerUnitManHours;
    } else {
      throw("AHTask - getPerUnitManHours() does not handle " + frequency.toString() + "!");
    }
  }

  setPerUnitManHours(InspectionFrequency frequency, double value) {
    if (frequency == InspectionFrequency.PERIODIC) {
      _periodicPerUnitManHours = value;
    } else if (frequency == InspectionFrequency.FREQUENT) {
      _frequentPerUnitManHours = value;
    }
  }

  double getTotalManHours(InspectionFrequency frequency) {
    return getPerUnitManHours(frequency) * quantity;
  }

  double getDefaultPerUnitManHours(InspectionFrequency frequency) {
    return AQI_CraneCategoriesController.getCraneCategoryDefaultManHoursWrapper(craneCategoryID, frequency).value;
  }

  bool doesTaskActuallyHaveReleventChanges() {
    return (
      quantity != 0 ||
      _periodicPerUnitManHours != getDefaultPerUnitManHours(InspectionFrequency.PERIODIC) ||
      _frequentPerUnitManHours != getDefaultPerUnitManHours(InspectionFrequency.FREQUENT)
    );
  }
}