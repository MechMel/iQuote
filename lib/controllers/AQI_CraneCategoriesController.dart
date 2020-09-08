import 'dart:convert';
import 'package:axiom_hoist_quote_calculator/M2/M2ObjectWrapperForControllers.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_CraneCategory.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';

class AQI_CraneCategoriesController {
  static const CRANE_CATEGORIES_FILE_NAME = "crane_categories.json";
  static int get _nextCraneCategoryID {
    return _craneCategoriesByID.length;
  }
  static Map<int, AQI_CraneCategory> _craneCategoriesByID;

  // Startup properties
  static bool _craneCategoriesControllerHasBeenSetup = false;
  static bool get craneCategoriesControllerHasBeenSetup {
    return _craneCategoriesControllerHasBeenSetup;
  }

  // Run this before attempting to use AQI_CraneCategoriesController 
  static void setupCraneCategoriesController() {
    if (!_craneCategoriesControllerHasBeenSetup) {
      // Attempt to load the crane categories file
      String encodedCraneCategoriesByID = AHDiskController.loadFileAsString(CRANE_CATEGORIES_FILE_NAME);

      if (encodedCraneCategoriesByID != null) {
        // Load crane categories from the file
        _craneCategoriesByID = _parseCraneCategories(encodedCraneCategoriesByID);
      } else  { // If no crane categories file exists, then this is the first time the app has been run
        // Setup default crane categories
        _craneCategoriesByID = _getDefaultCraneCategoriesByID();
        _saveCraneCategories();
      }

      // Make setup as complete
      _craneCategoriesControllerHasBeenSetup = true;
    }
  }

  // Getters
  static List<int> getAllCraneCategoriesIDs() {
    List<int> allCraneCategoriesIDs = List();

    for (int id in _craneCategoriesByID.keys) {
        allCraneCategoriesIDs.add(id);
    }

    return allCraneCategoriesIDs;
  }

  static List<int> getActiveOrLegacyCraneCategoriesIDs(bool shouldGetActiveCraneCategoriesIDs) {
    List<int> requestedCraneCategoriesIDs = List();

    for (int id in _craneCategoriesByID.keys) {
      if (_craneCategoriesByID[id].isActiveCraneCategory.value == shouldGetActiveCraneCategoriesIDs) {
        requestedCraneCategoriesIDs.add(id);
      }
    }

    return requestedCraneCategoriesIDs;
  }

  static bool isCraneCategoryActive(int id) {
    return _craneCategoriesByID[id].isActiveCraneCategory.value;
  }

  static M2ObjectWrapperForControllers<String> getCraneCategoryNameWrapper(int id) {
    return M2ObjectWrapperForControllers.fromAutoSerializing(
      source: _craneCategoriesByID[id].name,
      onAfterSet: _saveCraneCategories,
    );
  }

  static M2ObjectWrapperForControllers<double> getCraneCategoryDefaultManHoursWrapper(int id, InspectionFrequency frequency) {
    if (frequency == InspectionFrequency.PERIODIC) {
      return M2ObjectWrapperForControllers.fromAutoSerializing(
        source: _craneCategoriesByID[id].defaultPeriodicPerUnitManHours,
        onAfterSet: _saveCraneCategories,
      );
    } else if (frequency == InspectionFrequency.FREQUENT) {
      return M2ObjectWrapperForControllers.fromAutoSerializing(
        source: _craneCategoriesByID[id].defaultFrequentPerUnitManHours,
        onAfterSet: _saveCraneCategories,
      );
    } else {
      throw("AQI_CraneCategoriesController.getCraneCategoryDefaultManHours() does not handle " + frequency.toString() + "!");
    }
  }

  // Setters
  static int createNewCraneCategory({String name = "", double defaultPeriodicPerUnitManHours = 0.0, double defaultFrequentPerUnitManHours = 0.0,}) {
    AQI_CraneCategory newCraneCategory = AQI_CraneCategory(name, defaultPeriodicPerUnitManHours, defaultFrequentPerUnitManHours);
    return _registerNewCraneCategory(newCraneCategory);
  }

  static void setCraneCategoryToActiveOrLegacy(int id, bool shouldBeActive) {
    _craneCategoriesByID[id].isActiveCraneCategory.value = shouldBeActive;
    _saveCraneCategories();
  }
  
  // Private Crane Category List Functions
  static int _registerNewCraneCategory(AQI_CraneCategory newCraneCategory) {
    int newCraneCategoryID = _nextCraneCategoryID;
    _craneCategoriesByID[newCraneCategoryID] = newCraneCategory;
    _saveCraneCategories();
    return newCraneCategoryID;
  }
  
  static void _saveCraneCategories() {
    // Convert the crane categories to maps
    Map<String, AQI_CraneCategory> encodableCraneCategoriesByID = Map();
    for(int id in _craneCategoriesByID.keys) {
      String idAsText = id.toString();
      encodableCraneCategoriesByID[idAsText] = _craneCategoriesByID[id];
    }

    // Save a josn of the crane categories
    String encodedCraneCategoriesByID = jsonEncode(encodableCraneCategoriesByID);
    AHDiskController.saveFileAsString(CRANE_CATEGORIES_FILE_NAME, encodedCraneCategoriesByID);
  }
  
  static Map<int, AQI_CraneCategory> _parseCraneCategories(String encodedCraneCategoriesByTextID) {
    Map<String, dynamic> craneCategoriesByTextID = jsonDecode(encodedCraneCategoriesByTextID);
    Map<int, AQI_CraneCategory> craneCategoriesByID = Map();

    for(String idAsText in craneCategoriesByTextID.keys) {
      int id = int.parse(idAsText);
      AQI_CraneCategory craneCategory = AQI_CraneCategory.fromDecodedJson(craneCategoriesByTextID[idAsText]);
      craneCategoriesByID[id] = craneCategory;
    }
    
    return craneCategoriesByID;
  }

  static Map<int, AQI_CraneCategory> _getDefaultCraneCategoriesByID() {
    Map<int, AQI_CraneCategory> defaultCraneCategoriesByID = Map();
    List<AQI_CraneCategory> defaultCraneCategories = [
      AQI_CraneCategory("Fixed hoists, spare hoists up to 3T", 0.75, 0.5),
      AQI_CraneCategory("Fixed hoists over 3T", 1, 0.5),
      AQI_CraneCategory("Bridge Cranes p/p, Jib, Monorail, Gantry < 2T", 0.75, 0.5),
      AQI_CraneCategory("Bridge Cranes p/p, Jib, Monorail, Gantry 2T-5T", 1, 0.5),
      AQI_CraneCategory("Bridge Cranes 5T+ to 10Ton", 1.5, 0.5),
      AQI_CraneCategory("Bridge Cranes 10T+ to 30T", 2, 0.75),
      AQI_CraneCategory("Bridge Cranes 30T+ to 50T", 3, 0.75),
      AQI_CraneCategory("Bridge Cranes over 50T", 6, 1.5),
    ];

    for (int id = 0;  id < defaultCraneCategories.length; id++) {
      defaultCraneCategoriesByID[id] = defaultCraneCategories[id];
    }
        
    return defaultCraneCategoriesByID;
  }
}